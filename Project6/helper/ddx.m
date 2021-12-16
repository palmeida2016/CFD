function out = ddx(arr, d, Nx, Ny)
    % Get Indexes for Cavity
    x_start = 2;
    x_end = Nx-1;
    y_start = 2;
    y_end = Ny-1;

    % Compute Derivative
    out = (-arr((x_start:x_end)-1, y_start:y_end) + arr((x_start:x_end)+1, y_start:y_end))/(2*d);
end