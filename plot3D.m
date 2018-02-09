function plot3D( a,Camera_1_Coordinate,Camera_2_Coordinate )

% Making Camera 1 points
b = [Camera_1_Coordinate(1,1) Camera_1_Coordinate(1,2) Camera_1_Coordinate(1,3); 
     Camera_1_Coordinate(1,1)+0.5 Camera_1_Coordinate(1,2) Camera_1_Coordinate(1,3); 
     Camera_1_Coordinate(1,1)+0.5 Camera_1_Coordinate(1,2)+0.5 Camera_1_Coordinate(1,3); 
     Camera_1_Coordinate(1,1) Camera_1_Coordinate(1,2)+0.5 Camera_1_Coordinate(1,3); 
     Camera_1_Coordinate(1,1) Camera_1_Coordinate(1,2) Camera_1_Coordinate(1,3)]';
% Making Camera 2 points
c = [Camera_2_Coordinate(1,1) Camera_2_Coordinate(1,2) Camera_2_Coordinate(1,3); 
     Camera_2_Coordinate(1,1)+0.5 Camera_2_Coordinate(1,2) Camera_2_Coordinate(1,3); 
     Camera_2_Coordinate(1,1)+0.5 Camera_2_Coordinate(1,2)+0.5 Camera_2_Coordinate(1,3); 
     Camera_2_Coordinate(1,1) Camera_2_Coordinate(1,2)+0.5 Camera_2_Coordinate(1,3); 
     Camera_2_Coordinate(1,1) Camera_2_Coordinate(1,2) Camera_2_Coordinate(1,3)]';

% figure;
title('3D Plot of Object');
hold on;

plot3(a(1,:),a(2,:),a(3,:));
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
axis([0 15 0 15 0 15]);

plot3(b(1,:),b(2,:),b(3,:));
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
axis([0 15 0 15 0 15]);

plot3(c(1,:),c(2,:),c(3,:));
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
axis([0 15 0 15 0 15]);
legend('object','camera 1','camera 2');
end

