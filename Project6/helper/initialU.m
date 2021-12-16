function out = initialU(u,Re,nu,rho,Lx)
    % Calculate intial u velocity from Reynolds Number
    u_initial = Re * nu / (rho * Lx);
   
   % Intialize u velocity along top
   u(end,:) = u_initial;

   out = u;
end