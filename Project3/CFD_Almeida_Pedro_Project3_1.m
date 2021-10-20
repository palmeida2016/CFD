%% Header
clear; close all; clc;

%% Problem 1
% Analytical solution

dt = 1e-4;
t = 0:dt:2;
L = 1;
u = 1;
n = 101 + 2;
dx = L/(n-2);

x = linspace(0,L,n-2);

%Initial Conditions
phi = zeros(length(t), n);
phi(1,2:end-1) = exp(-(x-0.5).^2 ./ 0.01);
phi(1, 1) = phi(1, end-1);
phi(1, end) = phi(1, 2);

%Make video
j=1;

%Calculate values
for i = 1:length(t)
    u = 2*sin(2*pi*(i*dt));
    if u >= 0
        phi(i+1, 2:end-1) = (u*(phi(i, 3:end) - phi(i, 2:end-1))/(dx))*dt + phi(i, 2:end-1);
    else
        phi(i+1, 2:end-1) = (u*(phi(i, 2:end-1) - phi(i, 1:end-2))/(dx))*dt + phi(i, 2:end-1);
    end
    phi(i+1, 1) = phi(i, end-1);
    phi(i+1, end) = phi(i, 2);

    if mod(i,500) == 0
        path = sprintf('%03d.png', j);
        j = j+1;
        name = sprintf('t=%2.2f',i*dt);
        plot(x, phi(1,2:end-1),x,phi(i,2:end-1));
        legend('Original', name);
        saveas(gcf, path)
        pause(0.1);
    end
end

