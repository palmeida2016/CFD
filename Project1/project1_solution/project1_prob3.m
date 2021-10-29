clear
close all
clc

tmax = 2

L = 1;
N = 101;
dt = 1e-4;
alpha = 0.1;

x = linspace(0,L,N); % Rod discretization
T = zeros(size(x)); % IC
T(1) = sin(2*pi*0); T(end) = 0; % BC

dx = L/(N-1);
t = 0;
counter = 0;

figure; hold on;
plot(x,T); xlim([0,L])

% Time loop
while(t<tmax)
    
    t = t + dt;
    counter = counter + 1;
    
    % Time dependent boundary condition on the left end
    T(1) = sin(2*pi*t);
    
    % Vectorized! No looping
    %T(2:N-1) = T(2:N-1) + dt* ( alpha* ( T(3:N) - 2*T(2:N-1) + T(1:N-2) )/dx^2 ) ;
    
    % Or, use a for loop:
    for i = 2:N-1
        Tnew(i-1) = T(i) + dt* ( alpha* ( T(i+1) - 2*T(i) + T(i-1) )/dx^2 ) ;
    end
    T(2:N-1) = Tnew;
    
    % Peek plot every 1 seconds
    if(abs(mod(counter,0.01/dt))==0)
        plot(x,T); title(['N = ', num2str(N), ', t = ', num2str(t)])
        pause(0.1)
        ylim([-1,1]); xlabel('x'); ylabel('Temperature')
    end
    
end
    

%%


