function R = orm(theta)
%Returns the matrix that tells the velocities in the global frame from the
%oritentation of the robot

R = [ cos(theta) sin(theta) 0
     -sin(theta) cos(theta) 0
      0          0          1
      ];

end

