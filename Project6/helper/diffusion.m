function [u,v] = diffusion(u,v,dx,dy,nu,dt)
    % Get dimensions of Array
    [Nx,Ny] = size(u);
    
    % Get Indexes for Cavity
    x_start = 2;
    x_end = Nx-1;
    y_start = 2;
    y_end = Ny-1;

    % Calculate Diffusion
    u(x_start:x_end,y_start:y_end) = u(x_start:x_end,y_start:y_end) + dt * nu * (ddx2(u,dx,Nx,Ny) + ddy2(u,dy,Nx,Ny));
    v(x_start:x_end,y_start:y_end) = v(x_start:x_end,y_start:y_end) + dt * nu * (ddx2(v,dx,Nx,Ny) + ddy2(v,dy,Nx,Ny));

    % Return
end