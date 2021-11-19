function out = ghost(vec, Nx, Ny, i)
    if ~exist('i', 'var')
        vec(2:Nx+1, [1, Ny+2]) = vec(2:Nx+1, [Ny+1, 2]);
        vec([1, Nx+2], 2:Ny+1) = vec([Nx+1, 2], 2:Ny+1);
    else
        vec(2:Nx+1, [1, Ny+2], i) = vec(2:Nx+1, [Ny+1, 2], i);
        vec([1, Nx+2], 2:Ny+1, i) = vec([Nx+1, 2], 2:Ny+1, i);
    end
    out = vec;
end