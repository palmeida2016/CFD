clear
close all
clc

tmax = 50

L = pi;
N = 101;
dt = 1e-4;
alpha = 0.25;

x = linspace(0,L,N); % Rod discretization
T = x.*(pi-x); % IC
T(1) = 0; T(end) = 0; % BC

dx = L/(N-1);
t = 0;
counter = 0;

Texact = 1/(25*alpha)*sin(5*x);

figure; hold on; 
plot(x, Texact, 'ro');% analytical answer
legend('Analytic','AutoUpdate','off')
plot(x,T); xlim([0,L])

% Time loop
while(t<tmax)
    
    t = t + dt;
    counter = counter + 1;
    
    % Vectorized! No looping
    % We must only update the 'inner' nodes, since the boundary nodes 
    % are specified through the boundary conditions
    %T(2:N-1) = T(2:N-1) + dt* ( alpha* ( T(3:N) - 2*T(2:N-1) + T(1:N-2) )/dx^2 + sin(5*x(2:N-1)) ) ;
    
    % Alternatively, write the following loop
    % Slightly slower, but simpler to understand
    for innerIndex = 2:N-1
        T(innerIndex) = T(innerIndex) + dt* ( alpha* ( T(innerIndex+1) - 2*T(innerIndex) + T(innerIndex-1) )/dx^2 + sin(5*x(innerIndex)) ) ;
    end
    
    
    % Plot every 1 seconds
    if(abs(mod(counter,1/dt))==0)
        plot(x,T); title(['N = ', num2str(N), ', t = ', num2str(t)])
        pause(0.1)
        xlabel('x'); ylabel('Temperature')
    end
    
end

% Compute the error in the numerical solution
err_solution = sum((Texact - T).^2)
% You can change the N in this code, and compute the different errors to
% make the plot

%% 

% (b) If you set dt=1e-2 in this code, your solution will be unstable, because
% it violates the stability criterion we derived in class

% The same issue shows up in part (d)
