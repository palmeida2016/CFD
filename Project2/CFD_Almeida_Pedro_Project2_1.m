%% Header
clear; close all; clc;

%% Problem 1
% Analytical solution

% dy/dt = -5y
% dy/y = -5dt
% ln(y)= -5t + C1
% y = e^(-5t + C1)

% Using intial conditions, C1 = 0
% y = e^(-5t)

dt = 0.1;
t = 0:dt:2;

% Analytical
y_analytical = exp(-5*t);

% Euler
y_euler = zeros(1,length(t)); %Allocate Space
y_euler(1) = 1;

dydt = @(y) -5*y; %Find derivative

for i = 2:length(t)
    y_euler(i) = y_euler(i-1) + dt*dydt(y_euler(i-1));
end

% Range Kutta
y_RK = zeros(1,length(t)); %Allocate Space
y_RK(1) = 1;

dydt = @(y) -5*y; %Find derivative

for i = 2:length(t)
    k1 = dt*dydt(y_RK(i-1));
    k2 = dt*dydt(y_RK(i-1) + k1/2);

    y_RK(i) = y_RK(i-1) + k2;
end

plot(t,y_analytical,t,y_euler,t,y_RK);
legend('Analytical','Euler','Range Kutta')
xlabel('t')
ylabel('y')