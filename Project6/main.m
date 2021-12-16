%% Header
close all; clear; clc;
addpath('helper')

%% Definitions
% Constants
Re = [100 2000 10000];
nu = 1e-1;              % Kinematic Viscosity
dt = 1e-2;              % Time Step Size
rho = 1;                % Density
t_max = 10;

% Pressure Error Tolerance
e_max = 1e-6;
dt_pressure = 1e-4;

% Geometry
Lx = 1;
Ly = 1;
Nx = 31;
Ny = 31;
dx = Lx/(Nx-1);
dy = Ly/(Ny-1);

% Create Mesh Grid
x = linspace(0,Lx,Nx);
y = linspace(0,Ly,Ny);

[X,Y] = meshgrid(x,y);

% Allocate space to arrays
u = zeros(Nx,Ny); % Horizontal Velocity
v = zeros(Nx,Ny); % Vertical Velocity
P = zeros(Nx,Ny); % Pressure
wall = createWallVisualizer(u); % Get Wall to Plot

% Solve for each Reynolds Number Differently
for i = 1:1 % CHANGE TO length(Re)
    % Initialize Velocity Given Reynolds Number
    u = initialU(u,Re(i),nu,rho,Lx);

    % Iterate Each Timestep
    for t = 0:dt:t_max
        % Diffusion
        [u,v] = diffusion(u,v,dx,dy,nu,dt);
    
        % Advection
        [u,v] = advection(u,v,dx,dy,dt);
        
        % Divergence
        [u,v] = diverge(u,v,dx,dy,dt);

        % Plot
        figure(i);

    end
end

contourf(x,y,wall,'LineColor','none');
hold on;
quiver(x,y,u,v);
hold off;
