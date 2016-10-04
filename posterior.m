function f = posterior(Y,data,xn,init)
   
cc = Y(1:end-1,1);   %parameters in [-1 1] space
%
%
%   evaluate the polynomial using the current coeff 
%   at the xcoordinates of the observations

% Evaluating the forward model (PC surrogate)
if length(cc) == 1
    G = cc(1) + 0*xn;
elseif length(cc) == 2
    G = cc(1) + cc(2)*xn;
elseif length(cc) == 3
    G = cc(1) + cc(2)*xn + cc(3)*xn.^2;
elseif length(cc) == 4
    G = cc(1) + cc(2)*xn + cc(3)*xn.^2 + cc(4)*xn.^3;
elseif length(cc) == 5
    G = cc(1) + cc(2)*xn + cc(3)*xn.^2 + cc(4)*xn.^3 + cc(5)*xn.^4;
end
%
nreal = length(data);
%
%  likelihood
%
likl = 0 ;
for ll = 1:nreal
%
nvarnce =Y(end,1);
%
coef = 1/sqrt(2*pi*nvarnce);
dif  = data(ll) - G(ll);
fatt = exp(-dif^2/(2*nvarnce));
likl = likl + log(coef * fatt);
end
% 
%
% Prior
pr = zeros(length(Y),1);
for i=1:size(Y,1)         
     if i < size(Y,1)    
            if  Y(i,1) < -100 || Y(i,1) > 100
             pr(i) = 0;
            else
             pr(i) = 1/200;           
            end
    else
        if  Y(i,1) < 0
            pr(i) = 0;
        else
            pr(i) = 1/Y(i,1);  % Jeffery prior
        end    
    end
end

%
f = log( prod(pr)  ) + likl;
%------------------------------------------  

