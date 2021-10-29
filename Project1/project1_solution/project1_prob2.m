clear
close all
clc

tmax = 10

L = pi;
N = 21;
dt = 1e-4;
alpha = 0.1;

x = linspace(0,L,N); % Rod discretization
T = sin(pi*x/L); % IC
T(1) = 0; T(end) = 0; % BC

dx = L/(N-1);
t = 0;
counter = 0;

figure; hold on; 

% Plot the initial condition
plot(x,T); xlim([0,L])

% Plot the analytical solution
plot(x, sin(pi*x/L)*exp(-alpha*pi^2*t/L^2),'ro')

% Time loop
while(t<tmax)
    
    t = t + dt;
    counter = counter + 1;
    
    %%
    
    % Vectorized! No looping
    %T(2:N-1) = T(2:N-1) + dt* ( alpha* ( T(3:N) - 2*T(2:N-1) + T(1:N-2) )/dx^2  ) ;

    % or Non-vectorized, using a for-loop
    for i = 2:N-1
        Tnew(i-1) = T(i) + dt* alpha*( T(i-1) -2*T(i) + T(i + 1))/dx^2;
    end
    T(2:N-1) = Tnew;
    
    %%
    
    % Peek plot every 1 seconds
    if(abs(mod(counter,1/dt))==0)
        plot(x,T); title(['N = ', num2str(N), ', t = ', num2str(t)]) % Numerical solution
        plot(x, sin(pi*x/L)*exp(-alpha*pi^2*t/L^2),'ro') % Exact analytical solution
        pause(0.5)
        xlabel('x'); ylabel('Temperature')
    end
    
end
    

%%


