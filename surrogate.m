function value=surrogate(xi,coef,npt)

ndim = size(npt,2);

basis='legendre'; % default

% Make basis into a cell array
if ~iscell(basis)		% Not an array, make cell array of length ndim
	basis_str = basis;
	basis = cell(1,ndim);
	for d=1:ndim; basis{d} = basis_str; end
end

A = Psi_full_pceIndex(xi,npt,basis);
value=A*coef;