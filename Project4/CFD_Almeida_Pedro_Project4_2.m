%% Header
clear; close all; clc;

%% Problem 1
% Analytical solution

dt = 1e-3;
t_end = 10;
t = 0:dt:t_end;
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
u = zeros(Nx,Ny,Nt);
v = zeros(Nx,Ny,Nt);

% Initialize phi
phi = zeros(Nx+4,Ny+4,Nt);
phi(3:Nx+2,3:Ny+2,1) = cos(x).*ones(Nx,Ny);

% Boundary Conditions
phi(3:Nx+2, [1 2 Ny+3 Ny+4], 1) = phi(3:Nx+2, [Ny+1 Ny+2  3 4], 1);
phi([1 2 Nx+3 Nx+4], 3:Ny+2, 1) = phi([Nx+1 Nx+2 3 4], 3:Ny+2, 1);

figure(1);
hold on;
contourf(X,Y,phi(3:Nx+2,3:Ny+2,1));
% quiver(x,y,u,v);
hold off

% Define velocity matrices
u_max = u;
u_max(u_max < 0) = 0;

u_min = u;
u_min(u_min >= 0) = 0;

v_max = v;
v_max(v_max < 0) = 0;

v_min = v;
v_min(v_min >= 0) = 0;


j=1;
% Time Step
for i = 1:Nt-1
    % Get Velocity Components
    u(:,:,i) = sin(2*pi*(i*dt)/t_end) *cos(x).*sin(y');
    v(:,:,i) = -sin(2*pi*(i*dt)/t_end) *sin(x).*cos(y');
    
    u_max = u(:,:,i);
    u_max(u_max < 0) = 0;

    u_min = u(:,:,i);
    u_min(u_min >= 0) = 0;

    v_max = v(:,:,i);
    v_max(v_max < 0) = 0;

    v_min = v(:,:,i);
    v_min(v_min >= 0) = 0;
    
    
    % x Advection Calculation
    adv_i_pos = (u_max.*(-3*phi(3:Ny+2, 3:Nx+2, i) + 4*phi(3:Ny+2, 2:Nx+1, i) - phi(3:Ny+2, 1:Nx, i))) / (2*dx);
    adv_i_neg = (u_min.*(3*phi(3:Ny+2, 3:Nx+2, i) - 4*phi(3:Ny+2, 4:Nx+3, i) + phi(3:Ny+2, 5:Nx+4, i))) / (2*dx);
    
    adv_i = adv_i_pos + adv_i_neg;

    % y Advection Calculation
    adv_j_pos = (v_max.*(-3*phi(3:Ny+2, 3:Nx+2, i) + 4*phi(2:Ny+1, 3:Nx+2, i) - phi(1:Ny, 3:Nx+2, i))) ./ (2*dy);
    adv_j_neg = (v_min.*(3*phi(3:Ny+2, 3:Nx+2, i) - 4*phi(4:Ny+3, 3:Nx+2, i) + phi(5:Ny+4, 3:Nx+2, i))) ./ (2*dy);
    
    adv_j = adv_j_pos + adv_j_neg;

    % Final Calculation
    phi(3:Nx+2, 3:Ny+2, i+1) = (adv_i + adv_j) * dt + phi(3:Nx+2, 3:Ny+2, i);

    % Update Boundary Conditions
    phi(3:Nx+2, [1 2 Ny+3 Ny+4], i+1) = phi(3:Nx+2, [Ny+1 Ny+2  3 4], i+1);
    phi([1 2 Nx+3 Nx+4], 3:Ny+2, i+1) = phi([Nx+1 Nx+2 3 4], 3:Ny+2, i+1);

    if mod(i,250) == 0
        disp(i)
        clf;
        hold on;
        contourf(X,Y,phi(3:Nx+2,3:Ny+2,i));
        quiver(x,y,u(:,:,i),v(:,:,i));
        hold off;
        path = sprintf('%03d.png', j);
        j = j+1;
        name = sprintf('t = %2.2f s',i*dt);
        title(name);
        xlabel('x');
        ylabel('y');
%         saveas(gcf, path)
        pause(0.1);
    end
end

