function [P1, P2] = calculate_2D_point( Proj_Geo_1, Proj_Geo_2,a )

% Calculating 2D Points of image 1
P1 = Proj_Geo_1*a; 
for i = 1:size(P1,2)
    for j = 1:size(P1,1)
        P1(j,i) = P1(j,i)./P1(3,i); % Dividing row 1,2 with third row to make homogeneous coordinates

    end
end
% Calculating 2D Points of image 2
P2 = Proj_Geo_2*a;
for i = 1:size(P2,2)
    for j = 1:size(P2,1)
        P2(j,i) = P2(j,i)./P2(3,i); % Dividing row 1,2 with third row to make homogeneous coordinates

    end
end
end

