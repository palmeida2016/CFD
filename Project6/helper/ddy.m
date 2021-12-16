function out = ddy(arr, d, Nx, Ny)
    % Get Indexes for Cavity
    x_start = 2;
    x_end = Nx-1;
    y_start = 2;
    y_end = Ny-1;

    % Compute Derivative
    out = (-arr(x_start:x_end, (y_start:y_end)-1) + arr(x_start:x_end, (y_start:y_end)+1))/(2*d);
end