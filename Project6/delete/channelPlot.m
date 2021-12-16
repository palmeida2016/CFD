function channelPlot(x,y,u,v,chi,t,Lx,Ly,padding)

    Nx = size(u,1) - 2*padding;
    Ny = size(u,2) - 2*padding;

    innerXstart = padding + 1;
    innerXend   = padding + Nx;
    innerYstart = padding + 1;
    innerYend   = padding + Ny;
    
    % Remove unecessary padding
    u = u(innerXstart:innerXend,innerYstart:innerYend);
    v = v(innerXstart:innerXend,innerYstart:innerYend);
    chi = chi(innerXstart:innerXend,innerYstart:innerYend);
    
    % Plot walls
    clf;
    contourf(x,y,chi);

    % No autoscale to see
    hold on;
    quiver(x,y,u,v);%,'autoscale','off');
    hold off;
    
    % Plot Control
    xlabel('X'); ylabel('Y');
    title(['T = ', num2str(t,'%1.2f')])
    axis([0, Lx, 0, Ly])
    pause(0.1)
end

