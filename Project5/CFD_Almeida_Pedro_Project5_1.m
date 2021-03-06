%% Header
clear; close all; clc;
addpath('helper');

%% Problem 1
% Constants
nu = 1e-1;              % Kinematic Viscosity
dt = 1e-2;              % Time Step Size
rho = 1;                % Density
t = 0:dt:10;
Nt = length(t);
Lx = 2*pi;
Ly = 2*pi;
Nx = 31;
Ny = 31;
dx = Lx/Nx;
dy = Ly/Ny;

% Pressure Iteration Constants
dT = 1e-4;
e = 1;
e_max = 1e-6;

% Define x and y domains
x = linspace(0,Lx,Nx);
y = linspace(0,Ly,Ny);

[X,Y] = meshgrid(x,y);

% Define Velocity Components
u = zeros(Nx+2, Ny+2, Nt);
v = zeros(Nx+2, Ny+2, Nt);
u(2:Nx+1,2:Ny+1,1) = cos(x').*sin(y);
v(2:Nx+1,2:Ny+1,1) = -sin(x').*cos(y);

% Define Intermediate Velocity Components for Calculations
u_int = zeros(Nx+2, Ny+2);
v_int = zeros(Nx+2, Ny+2);

% Boundary Conditions
u = ghost(u,Nx,Ny,1);
v = ghost(v,Nx,Ny,1);


% Find Initial Pressure Through Time Convergence
P = zeros(Nx+2, Ny+2, Nt);
P_int = zeros(Nx+2, Nx+2, 2);
while e > e_max % Iterate until error is low
    disp('Initial P0')
    disp(e)
    fm = (rho/dt) * (d(u,dx,Nx,Ny,1) + d(v,dy,Nx,Ny,1));
    P_int(2:Nx+1, 2:Ny+1, 2) = P_int(2:Nx+1, 2:Ny+1, 1) + (dT * ...
    (d2(P_int,dx,Nx,Ny,1) + d2(P_int,dy,Nx,Ny,1) - fm));

    e = sqrt( sum((P_int(:,:,2) - P_int(:,:,1)).^2, 'all')); % Get Error
    
    % Reset for Next Iteration
    P_int(:,:,1) = P_int(:,:,2);
    P_int(:,:,2) = zeros(Nx+2,Ny+2);
end

% When error is low
P(:,:,1) = P_int(:,:,1);
P = ghost(P,Nx,Ny,1);

% Time Step
for i = 1:Nt-1
    % Advection Part
    u_int(2:Nx+1, 2:Ny+1) = u(2:Nx+1, 2:Ny+1, i) + dt *...
        -(u(2:Nx+1, 2:Ny+1, i) .* d(u,dx,Nx,Ny,i) ...
        + v(2:Nx+1, 2:Ny+1, i) .* d(u,dy,Nx,Ny,i));
    
    v_int(2:Nx+1, 2:Ny+1) = v(2:Nx+1, 2:Ny+1, i) + dt *...
        -(u(2:Nx+1, 2:Ny+1, i) .* d(v,dx,Nx,Ny,i) ...
        + v(2:Nx+1, 2:Ny+1, i) .* d(v,dy,Nx,Ny,i));
    
    
    % Update Boundary Conditions for Intermediate Step
    u_int = ghost(u_int,Nx,Ny);
    v_int = ghost(v_int,Nx,Ny);


    % Diffusion Part
    u_int(2:Nx+1, 2:Ny+1) = u_int(2:Nx+1, 2:Ny+1) + dt *...
        (nu * d2(u_int,dx,Nx,Ny) ...
        + nu * d2(u_int,dy,Nx,Ny));

    v_int(2:Nx+1, 2:Ny+1) = v_int(2:Nx+1, 2:Ny+1) + dt *...
        (nu * d2(v_int,dx,Nx,Ny) ...
        + nu * d2(v_int,dy,Nx,Ny));


    % Update Boundary Conditions for Intermediate Step
    u_int = ghost(u_int,Nx,Ny);
    v_int = ghost(v_int,Nx,Ny);


    % Pressure Step Arrays Reset to 0
    P_int = zeros(Nx+2,Ny+2,2);
    P_int(:,:,1) = P(:,:,i);

    errors = zeros(1,2); % Store errors
    dT = 1e-4; % Will be lowered if necessary
    e = 1;
    while e > e_max
        disp('Ongoing')
        disp(e)
        fm = (rho/dt) * (d(u_int,dx,Nx,Ny) + d(v_int,dy,Nx,Ny));
        P_int(2:Nx+1, 2:Ny+1, 2) = P_int(2:Nx+1, 2:Ny+1, 1) + (dT * ...
        (d2(P_int,dx,Nx,Ny,1) + d2(P_int,dy,Nx,Ny,1) - fm));
        P_int = ghost(P_int,Nx,Ny,2);
    
        % Calculate Error
        e = sqrt( sum((P_int(:,:,2) - P_int(:,:,1)).^2, 'all')); % Get Error
        
        % Reset for Next Iteration
        P_int(:,:,1) = P_int(:,:,2);
        P_int(:,:,2) = zeros(Nx+2,Ny+2);
        P_int = ghost(P_int,Nx,Ny,1);

        % Check if need to lower dT
        if (e - errors(1))/dT < 1e6
            dT = dT * 0.1;
        end

        % Update errors array
        errors([1,2]) = [errors(2), 0];
    end

    % If error is lower than threshold, get P
    P(:,:,i+1) = P_int(:,:, 1);

    % Calculate new u,v
    u(2:Nx+1,2:Ny+1,i+1) = u_int(2:Nx+1,2:Ny+1) - (dt/rho)*(d(P,dx,Nx,Ny,i+1) + d(P,dy,Nx,Ny,i+1));
    v(2:Nx+1,2:Ny+1,i+1) = v_int(2:Nx+1,2:Ny+1) - (dt/rho)*(d(P,dx,Nx,Ny,i+1) + d(P,dy,Nx,Ny,i+1));

    % Update Next Time Step
    u(2:Nx+1, 2:Ny+1, i+1) = u_int(2:Nx+1, 2:Ny+1);
    v(2:Nx+1, 2:Ny+1, i+1) = v_int(2:Nx+1, 2:Ny+1);


    % Update Boundary Conditions on New Time Step
    u(2:Nx+1, [1, Ny+2], i+1) = u(2:Nx+1, [Ny+1, 2], i+1);
    u([1, Nx+2], 2:Ny+1, i+1) = u([Nx+1, 2], 2:Ny+1, i+1);
    v(2:Nx+1, [1, Ny+2], i+1) = v(2:Nx+1, [Ny+1, 2], i+1);
    v([1, Nx+2], 2:Ny+1, i+1) = v([Nx+1, 2], 2:Ny+1, i+1);
    

    % Theoretical Solution
    u_theory = cos(x').*sin(y)*exp(-2*nu*i*dt);
    v_theory = -sin(x').*cos(y)*exp(-2*nu*i*dt);

    % Plot Velocity Components
    clf;
    hold on;
    quiver(x,y,u(2:Nx+1, 2:Ny+1,i),v(2:Nx+1, 2:Ny+1,i));
    quiver(x,y,u_theory,v_theory);
    hold off;
    title('t = ', i*dt);
    pause(0.01)
end