%% Header
clear; close all; clc;

%% Problem 1
% Analytical solution

dt = 1e-4;
t = 0:dt:2;
L = 1;
u = -1;
n = 101 + 4;
dx = L/(n-2);

x = linspace(0,L,n-4);

%Initial Conditions
phi = zeros(length(t), n);
phi(1,3:end-2) = exp(-(x-0.5).^2 ./ 0.01);
phi(1, 1:2) = phi(1, end-3:end-2);
phi(1, end-1:end) = phi(1, 3:4);

%Make video
j=1;

%Calculate values
for i = 1:length(t)
    u = 2*sin(2*pi*(i*dt));
    if u >= 0
        phi(i+1, 3:end-2) = (u*(-3*phi(i, 3:end-2) + 4*phi(i, 4:end-1) - phi(i, 5:end))/(2*dx))*dt + phi(i, 3:end-2);
%         phi(i+1, 3:end-2) = (u*(3*phi(i, 3:end-2) - 4*phi(i, 2:end-3) + phi(i, 1:end-4))/(2*dx))*dt + phi(i, 3:end-2);
    else
%         phi(i+1, 3:end-2) = (u*(-3*phi(i, 3:end-2) + 4*phi(i, 4:end-1) - phi(i, 5:end))/(2*dx))*dt + phi(i, 3:end-2);
        phi(i+1, 3:end-2) = (u*(3*phi(i, 3:end-2) - 4*phi(i, 2:end-3) + phi(i, 1:end-4))/(2*dx))*dt + phi(i, 3:end-2);
    end
phi(i+1, 1:2) = phi(i+1, end-3:end-2);
phi(i+1, end-1:end) = phi(i+1, 3:4);

    if mod(i,500) == 0
        path = sprintf('%03d.png', j);
        j = j+1;
        name = sprintf('t=%2.2f',i*dt);
        plot(x, phi(1,3:end-2),x,phi(i,3:end-2));
        legend('Original', name);
%         saveas(gcf, path)
        pause(0.02);
    end
end

