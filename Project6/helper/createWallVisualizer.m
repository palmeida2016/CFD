function wall = createWallVisualizer(u)
    % Get Dimensions of Space
    [Nx,Ny] = size(u);
    
    % Create Empty Array for Wall
    wall = ones(Nx,Ny);

    % Assign Wall as Edges of Field
    wall(1:Nx-1,1) = 0;
    wall(1,:) = 0;
    wall(1:Nx-1,Ny) = 0;
end