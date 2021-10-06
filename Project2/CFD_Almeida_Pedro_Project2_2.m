%% Header
clear; close all; clc;

%% Problem 2
alpha = 0.25;

% X limits
n = 100;
L = pi;
dx = pi/n;
x = 0:dx:L;
dt = 1e-2;

% Time
dt = 1e-2;
t_end = 50;
n_t = t_end/dt + 1;

%Plotting Interval
interval = 200;

%r constant for matrix creation
r = (dt * alpha) / (2 * dx^2);

%Construct Matrix for Solutions
mainDiag = (1 + 2*r) * ones(n-1,1);
offDiag = -r * ones(n-1,1);
A = spdiags([offDiag, mainDiag, offDiag], [-1, 0, 1], n-1, n-1);


%Theoretical Steady State
T_steady = sin(5.*x) / (25*alpha);

% Initial Conditions
T = zeros(n_t, n+1);
T(1,:) = x.*(pi - x);

for i = 1:n_t-1
    b = T(i, 2:end-1) * (1-2*r) + r*T(i, 3:end) + r*T(i,1:end-2) + dt*sin(5*x(2:end-1));
    T(i+1, 2:end-1) = pcg(A,transpose(b));
end

% Visualize
hold on;
plot(x,T(1,:))
for i = 1:n_t
    if mod(i,interval) == 0
        plot(x,T(i, :));
        legend('poop')
    end
end
plot(x,T(end,:),x,T_steady)
xlim([0 pi])
hold off;