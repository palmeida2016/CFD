function out = d2(vec, d_var, Nx, Ny, i)
    if ~exist('i', 'var')
        out = (vec(1:Nx, 2:Ny+1) - 2*vec(2:Nx+1, 2:Ny+1) + vec(3:Nx+2, 2:Ny+1))/(d_var^2);
    else
        out = (vec(1:Nx, 2:Ny+1,i) - 2*vec(2:Nx+1, 2:Ny+1,i) + vec(3:Nx+2, 2:Ny+1,i))/(d_var^2);
    end
end