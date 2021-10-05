%% Header
clear; close all; clc;

%% Problem 2
alpha = 0.25;

% X limits
n = 100;
L = pi;
dx = pi/n;
x = 0:dx:L;

% Time
dt = 1e-2;
t_end = 50;
n_t = t_end/dt + 1;

%Theoretical Steady State
T_steady = sin(5.*x) / (25*alpha);

% Initial Conditions
T = zeros(n_t, n+1);
T(1,:) = x.*(pi - x);



% Visualize
plot(x,T(1,:),x,T_steady)
xlim([0 pi])