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

x = linspace(0,Lx,Nx);
y = linspace(0,Ly,Ny);

% Define Velocity Components
u = cos(x).*sin(y');
v = -sin(x).*cos(y');

% Initialize phi
phi = zeros(Ny+4,Nx+4,Nt);
phi(3:Ny+2,3:Nx+2,1) = cos(x).*ones(Ny,Nx);

% Boundary Conditions
phi(3:Ny+2, [1 2 Nx+3 Nx+4], 1) = phi(3:Ny+2, [Nx+1 Nx+2  3 4], 1);
phi([1 2 Ny+3 Ny+4], 3:Nx+2, 1) = phi([Ny+1 Ny+2 3 4], 3:Nx+2, 1);

% Time Step
for i = 1:Nt
    phi(3:Ny+2, 3:Nx+2, i+1) = phi(3:Ny+2, 3:Nx+2, i);
end


% hold on
% contourf(phi(3:Ny+2,3:Nx+2,1))
% 
% quiver(x,y,u,v)
% hold off