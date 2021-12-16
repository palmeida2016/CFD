clear; close all; clc;

% Path for Helper Functions
addpath('helper/')

% Constants
dt = 1e-2;
tmax = 10;
nu = 1e-2;
rho = 1.0;

Nx = 51;
Ny = 51;

Lx = 2*pi;
Ly = 2*pi;

dx = Lx/(Nx-1);
dy = Lx/(Ny-1);

% Wall Constraints
centerline = pi;
wallWidth = 0.5;
wallSeparation = 2;

%% Create a 2D mesh
[x,y] = meshgrid(linspace(0,Lx,Nx),linspace(0,Ly,Ny));
x = x';
y = y';

% Ghosts for each side
padding = 1;

% Create empty array for velocity vectors
u = zeros(Nx+2*padding,Ny+2*padding);
v = zeros(Nx+2*padding,Ny+2*padding);
chi = zeros(Nx+2*padding,Ny+2*padding);

% Define new indices for easier access
innerXstart = padding + 1;
innerXend   = padding + Nx;
innerYstart = padding + 1;
innerYend   = padding + Ny;

% Populate the inner nodes with the true values
u(innerXstart:innerXend,innerYstart:innerYend) = ones(Nx,Ny);
v(innerXstart:innerXend,innerYstart:innerYend) = zeros(Nx,Ny);

% Chi array
chi = walls(chi,padding,y,centerline,wallWidth, wallSeparation);

% Ghost
u = ghost(u,padding);
v = ghost(v,padding);

% Allocate memory for pressure
P = zeros(size(u));
dPdx = zeros(size(u));
dPdy = zeros(size(u));

% Video writer
vidFile = VideoWriter('q2b.mp4','MPEG-4');
open(vidFile);

vidFile2 = VideoWriter('q2d.mp4','MPEG-4');
open(vidFile2);

% Error
errorTimeVec = [];
errorVec = [];


%% Time loop
for t = 0:dt:tmax
    % Penalty
    [u,v] = penalty(u,v,chi,dt);
    
    % Diffusion
    [u,v] = diffusion(u,v,dx,dy,nu,dt,padding);
    
    % Advection
    [u,v] = advection(u,v,dx,dy,dt,padding);
    
    % Pressure
    divU = divergence(u,v,dx,dy,padding);
    rhs = rho/dt * divU;
    
    % Poisson
    P = poisson(P,rhs,dx,dy,padding);
    
    % Divergence Free
    dPdx(innerXstart:innerXend, innerYstart:innerYend) = ddx(P,dx,Nx,Ny);
    dPdy(innerXstart:innerXend, innerYstart:innerYend) = ddy(P,dy,Nx,Ny);
    
    dPdx = ghost(dPdx,padding);
    dPdy = ghost(dPdy,padding);

    u = u - dt * dPdx/rho;
    v = v - dt * dPdy/rho;
    
    % Plot
    if (mod(t/dt,10)==0)
        channelPlot(x,y,u,v,chi,t,Lx,Ly,padding);
        
        frame = getframe(gcf);
        writeVideo(vidFile,frame);
        
        % Plot Vorticity
        w = ddx(v,dx,Nx,Ny) - ddy(u,dy,Nx,Ny);
        vorticityPlot(x,y,w,chi,t,Lx,Ly,padding);
        
        frame = getframe(gcf);
        writeVideo(vidFile2,frame);
        
    end
end

% As expected, the vorticity on the underside of the top wall is
% negative and positive on the topside of the bottom wall. The
% inflow velocity in the Poiseulle flow creates counterclockwise
% rotation on the bottom and clockwise rotation at the top.

% Vertical Cut
plot(u(10,2:end-1),linspace(0,Ly,Ny));

% As expected, the fluid velocity distribution resembles a parabola with
% the greatest velocity at the center of the two walls, which is precisely
% the case for Poiseulle flows.

close(vidFile);
close(vidFile2);

rmpath('helper/')