%% Header
clear; close all; clc;

%% Problem 1
% Analytical solution

dt = 1e-2;
t = 0:dt:10;
Nt = length(t);
Lx = 2*pi;
Ly = 2*pi;
Nx = 31;
Ny = 31;
dx = Lx/Nx;
dy = Ly/Ny;

% Define x and y domains
x = linspace(0,Lx,Nx);
y = linspace(0,Ly,Ny);

[X,Y] = meshgrid(x,y);

% Define Velocity Components
u = cos(x').*sin(y);
v = -sin(x').*cos(y);

% Initialize phi
phi = zeros(Nx+4,Ny+4,Nt);
phi(3:Nx+2,3:Ny+2,1) = cos(x').*ones(Nx,Ny);

% Boundary Conditions
phi(3:Nx+2, [1 2 Ny+3 Ny+4], 1) = phi(3:Nx+2, [Ny+1 Ny+2  3 4], 1);
phi([1 2 Nx+3 Nx+4], 3:Ny+2, 1) = phi([Nx+1 Nx+2 3 4], 3:Ny+2, 1);

% Define velocity matrices
u_max = u;
u_max(u_max < 0) = 0;

u_min = u;
u_min(u_min >= 0) = 0;

v_max = v;
v_max(v_max < 0) = 0;

v_min = v;
v_min(v_min >= 0) = 0;


% Time Step
for i = 1:Nt-1
    
    % x Advection Calculation
    adv_i_pos = (u_max.*(-3*phi(3:Nx+2, 3:Ny+2, i) + 4*phi(2:Nx+1, 3:Ny+2, i) - phi(1:Nx, 3:Ny+2, i))) ./ (2*dx);
    adv_i_neg = (u_min.*(3*phi(3:Nx+2, 3:Ny+2, i) - 4*phi(4:Nx+3, 3:Ny+2, i) + phi(5:Nx+4, 3:Ny+2, i))) ./ (2*dx);

    adv_i = adv_i_pos + adv_i_neg;

    % y Advection Calculation
    adv_j_pos = (v_max.*(-3*phi(3:Nx+2, 3:Ny+2, i) + 4*phi(3:Nx+2, 2:Ny+1, i) - phi(3:Nx+2, 1:Ny, i))) / (2*dy);
    adv_j_neg = (v_min.*(3*phi(3:Nx+2, 3:Ny+2, i) - 4*phi(3:Nx+2, 4:Ny+3, i) + phi(3:Nx+2, 5:Ny+4, i))) / (2*dy);
    
    adv_j = adv_j_pos + adv_j_neg;

    % Final Calculation
    phi(3:Nx+2, 3:Ny+2, i+1) = (adv_i + adv_j) * dt + phi(3:Nx+2, 3:Ny+2, i);

    % Update Boundary Conditions
    phi(3:Nx+2, [1 2 Ny+3 Ny+4], i+1) = phi(3:Nx+2, [Ny+1 Ny+2  3 4], i+1);
    phi([1 2 Nx+3 Nx+4], 3:Ny+2, i+1) = phi([Nx+1 Nx+2 3 4], 3:Ny+2, i+1);

    if mod(i,10) == 0
        disp(i)
        clf;
        hold on;
        contourf(X,Y,phi(3:Nx+2,3:Ny+2,i));
        quiver(x,y,u,v);
        hold off;
        pause(0.5);
    end
end