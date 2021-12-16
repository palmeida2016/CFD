function [u,v] = advection(u,v,dx,dy,dt)
    % Get dimensions of Array
    [Nx,Ny] = size(u);

    % Get Indexes for Cavity
    x_start = 2;
    x_end = Nx-1;
    y_start = 2;
    y_end = Ny-1;

    %  Intermediate Variables
    ududx = u(x_start:x_end,y_start:y_end) .* ddx(u,dx,Nx,Ny);
    udvdx = u(x_start:x_end,y_start:y_end) .* ddx(v,dx,Nx,Ny);
    vdudy = v(x_start:x_end,y_start:y_end) .* ddy(u,dy,Nx,Ny);
    vdvdy = v(x_start:x_end,y_start:y_end) .* ddy(v,dy,Nx,Ny);
    
    % Calculate Advection
    u(x_start:x_end,y_start:y_end) = u(x_start:x_end,y_start:y_end) - dt * (ududx + vdudy);
    v(x_start:x_end,y_start:y_end) = v(x_start:x_end,y_start:y_end) - dt * (udvdx + vdvdy);

    % Return
end