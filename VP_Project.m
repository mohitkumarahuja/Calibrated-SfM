
%%%%%%%%%%%% SSDN %%%%%%%%%%%%%
%%%%%% Mohit Kumar Ahuja %%%%%%
%%%%%%%%%%%  MSCV 1 %%%%%%%%%%%

%%%% Practical Session #2  %%%%
%%%%%   Calibrated SfM    %%%%%

close all;
clear;
clc;



%% Part 1 : Compute the Essential Matrix E, knowing R and T

% Set coordinates where to keep both Camera's
Camera_1_Coordinate = [0 0 0];
Camera_2_Coordinate = [2 0 0];
s = pcread('teapot.ply'); % Internal Point cloud of matlab
a1  = s.Location; % Reading x,y,z coordinates
a1 = a1+5;
a = [a1 ones(size(a1,1),1)]'; % Making homogeneous coordinates
plot3D(a, Camera_1_Coordinate, Camera_2_Coordinate);


%%%%%%%%%%%%%%%%%%% For Camera 1 %%%%%%%%%%%%%%%%%%%%%%
Rotation_Matrix = [eye(3) ;0 0 0] ; % Rotational matrix
Translation_Matrix = [Camera_1_Coordinate(1,1)...
    Camera_1_Coordinate(1,2) Camera_1_Coordinate(1,3) 1]'; % Translation Matrix
RT_Matrix = [Rotation_Matrix Translation_Matrix];
e1 = [eye(3) ; 0 0 0]';                          % Extrinsic Parameters (Rotation and Translation both)
Intrinsic_Parameters = [1 0 0;0 1 0; 0 0 1];     % Intrinsic Parameters
Proj_Geo_1 = Intrinsic_Parameters*e1*RT_Matrix;  % Calculating Projection Matrix for camera 1


%%%%%%%%%%%%%%%%%%%%% For Camera 2 %%%%%%%%%%%%%%%%%%%
Rotation_Matrix2 = [0 -1 0;1 0 0; 0 0 1;0 0 0];  % Rotational matrix with 90 degree rotation
% Rotation_Matrix2 = [1 0 0;0 1 0; 0 0 1;0 0 0] ; % Rotational matrix with no Rotation
% Rotation_Matrix2 = [0.7 0.8 0;0.7 0.7 0; 0 0 1;0 0 0] ; % Rotational matrix with 45 degree rotation

Translation_Matrix2 = [Camera_2_Coordinate(1,1)...
    Camera_2_Coordinate(1,2) Camera_2_Coordinate(1,3) 1]'; % Translation Matrix
RT_Matrix2 = [Rotation_Matrix2 Translation_Matrix2]; % Extrinsic Parameters (Rotation and Translation both)
e2 = [eye(3) ; 0 0 0]';
Intrinsic_Parameters2 = [1 0 0;0 1 0; 0 0 1];        % Intrinsic Parameters
Proj_Geo_2 = Intrinsic_Parameters2*e2*RT_Matrix2;    % Calculating Projection Matrix for camera 2

[P1, P2] = calculate_2D_point(Proj_Geo_1, Proj_Geo_2,a);   % Calculating 2D points from Projection Matrix
Image_1 = [(P1(1,:)) ;(P1(2,:)); ones(size(P1(2,:)))];     % Points of 2D Image 1
Image_2 = [(P2(1,:)) ;(P2(2,:)); ones(size(P2(2,:)))];     % Points of 2D Image 2

Cross_Prod_Translation = [0 -Translation_Matrix2(3) Translation_Matrix2(2); % Calculating [t]x
    Translation_Matrix2(3) 0 -Translation_Matrix2(1) ;
    -Translation_Matrix2(2) Translation_Matrix2(1) 0 ];

Essential_Matrix = (Cross_Prod_Translation'*Rotation_Matrix2(1:3,:)); % Calculating Essential Matrix





%%  Part 2 : Extract R and T from E using paper.


[U,S,V] = svd(Essential_Matrix); % Translation and Rotation Matrix decomposed
                                 % from Essential Matrix usin SVD.
                                 
Computed_Trans_Matrix = [U(1,3) U(2,3) U(3,3)]'; % Calculated New Translated Matrix
D = [0 1 0;-1 0 0; 0 0 1];
Ra = U*D*V';   % Calculated New Rotation Matrix 1
Rb = U*D'*V'; % Calculated New Rotation Matrix 2





%% Part 3: Use the so-called cheirality constraint to choose between the four putative solutions.

% As mentioned in Paper; One of the four choices corresponds to the true configuration.
PA = [Ra  Computed_Trans_Matrix];   % PA = [Ra | tu]
PB = [Ra  -Computed_Trans_Matrix];  % PB = [Ra | ?tu]
PC = [Rb  Computed_Trans_Matrix];   % PC = [Rb | tu]
PD = [Rb  -Computed_Trans_Matrix];  % PD = [Rb | ?tu]

Proj_Geo_3 = Proj_Geo_1;  % As there is no translation for first camera
Proj_Geo_4 = PC;          % Updated Projection matrix for second camera

Three_D_Points = triangulate(Image_1(1:2,:)',Image_2(1:2,:)',Proj_Geo_3',Proj_Geo_4'); % 3D points calculated by triangulation
Three_D_Points = [Three_D_Points ones(size(Three_D_Points,1),1)];

Q = Three_D_Points(1,:); % one 3D point is sufficient to resolve the ambiguity.
Q3 = Q(1,3);             % Third value of Q vector
Q4 = Q(1,4);             % Forth  value of Q vector
C1 = Q3*Q4;              % If c1 = Q3Q4 < 0, the point is behind the first camera.
A = Proj_Geo_4*Q';       % Calculating A = (PA*Q)3
C2 = A(3,1)*Q4;          % If c2 = (PAQ)3Q4 < 0, the point is behind the second camera.





%% Part 4: Compute and display the 3D reconstruction of a scene. Compare with the ground-truth.


if C1 <0    % If c1 < 0, the point is behind the first camera.
    disp('the point is behind the first camera');
        figure;
    plot3(Three_D_Points(:,1),Three_D_Points(:,2),Three_D_Points(:,3));
    title('3D Plot of Object');
    xlabel('x axis');
    ylabel('y axis');
    zlabel('z axis');
elseif C2< 0    % If c2 < 0, the point is behind the second camera.
    disp('the point is behind the Second camera');
        figure;
    plot3(Three_D_Points(:,1),Three_D_Points(:,2),Three_D_Points(:,3));
    title('3D Plot of Object');
    xlabel('x axis');
    ylabel('y axis');
    zlabel('z axis');
elseif C2< 0 && C1 <0
    disp('the point is behind the camera');
        figure;
    plot3(Three_D_Points(:,1),Three_D_Points(:,2),Three_D_Points(:,3));
    title('3D Plot of Object');
    xlabel('x axis');
    ylabel('y axis');
    zlabel('z axis');
elseif C1>0 && C2>0 % If c1 > 0 and c2 > 0, PA and Q correspond to the true configuration.
    disp('the point is in true configuration');
    plot3D(Three_D_Points', Camera_1_Coordinate, Camera_2_Coordinate);
end





%% Part 5: Optional 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thank You %%%%%%%%%%%%%%%%%%%%%%%%%%%%%