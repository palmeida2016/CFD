function out = d(vec, d_var, Nx, Ny, i)
    if ~exist('i', 'var')
        out = (-vec(1:Nx, 2:Ny+1) + vec(3:Nx+2, 2:Ny+1))/(2*d_var);
    else
        out = (-vec(1:Nx, 2:Ny+1, i) + vec(3:Nx+2, 2:Ny+1, i))/(2*d_var);
    end
end