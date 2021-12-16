function [u,v] = pressure(P,u,v,dx,dy,rho)
    % Define Constants
    e_max = 1e-8;
    e = 1e10; % Intialize error to some arbitrary large value

    % Allocate space for Intermediate Pressure for Iterations
    P_temp = P;
    dt = 1e-4;

    % Get dimensions of Array
    [Nx,Ny] = size(u);

    % Get Indexes for Cavity
    x_start = 2;
    x_end = Nx-1;
    y_start = 2;
    y_end = Ny-1;
    
    % Compute Divergence
    div = ddx(u,dx,Nx,Ny) + ddy(v,dy,Nx,Ny);

    % Calculate rhs
    rhs = rho/dt * div;

    % Converge to Pressure Term
    while e > e_max
        P = P_temp;

        P_temp(x_start:x_end,y_start:y_end) = P(x_start:x_end,y_start:y_end) + ...
        dt*(ddx2(P,dx,Nx,Ny) + ddy2(P,dy,Nx,Ny) - rhs);

        e = sqrt(sum((P-P_temp).^2,'all')) / (Nx*Ny);
    end
    
    % Update P once iterations are done
    P = P_temp;

    % Compute new u and v from Pressure Term
    u(x_start:x_end,y_start:y_end) = u(x_start:x_end,y_start:y_end) - dt* ddx(P,dx,Nx,Ny)/rho;
    v(x_start:x_end,y_start:y_end) = v(x_start:x_end,y_start:y_end) - dt* ddy(P,dy,Nx,Ny)/rho;

    % Return
end