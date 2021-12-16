clear; close all; clc;

% Path for Helper Functions
addpath('helper/')

% Constants
dt = 1e-2;
tmax = 10;
nu = 1e-1;
rho = 1.0;

Nx = 31;
Ny = 31;

Lx = 2*pi;
Ly = 2*pi;

dx = Lx/(Nx-1);
dy = Lx/(Ny-1);

%% Create a 2D mesh
[x,y] = meshgrid(linspace(0,Lx,Nx),linspace(0,Ly,Ny));
x = x';
y = y';

% Ghosts for each side
padding = 1;

% Create empty array for velocity vectors
u = zeros(Nx+2*padding,Ny+2*padding);
v = zeros(Nx+2*padding,Ny+2*padding);

% Define new indices for easier access
innerXstart = padding + 1;
innerXend   = padding + Nx;
innerYstart = padding + 1;
innerYend   = padding + Ny;

% Populate the inner nodes with the true values
u(innerXstart:innerXend,innerYstart:innerYend) = cos(x).*sin(y);
v(innerXstart:innerXend,innerYstart:innerYend) = -sin(x).*cos(y);

% Ghost
u = ghost(u,padding);
v = ghost(v,padding);

% Allocate memory for pressure
P = zeros(size(u));
dPdx = zeros(size(u));
dPdy = zeros(size(u));

% Video writer
vidFile = VideoWriter('q1c.mp4','MPEG-4');
open(vidFile);

% Error
errorTimeVec = [];
errorVec = [];

%% Time loop
for t = 0:dt:tmax
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
        [errorTime, error] = quiverPlot(x,y,u,v,t,Lx,Ly,nu,padding);
        errorTimeVec(end+1) = errorTime;
        errorVec(end+1) = error;
        
        % Dump out a frame to video file
        frame = getframe(gcf);
        writeVideo(vidFile,frame);
    end
    
    
end

close(vidFile);

%% d)
plot(errorTimeVec, errorVec);
xlabel('Time'); ylabel('Error')

rmpath('helper/')