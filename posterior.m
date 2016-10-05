function f = posterior(Y,data,init,coeff,npt)
   
cc = Y(1:end-1);   %parameters in [-1 1] space

sshpc = surrogate(cc,coeff,npt);

obs = data(:,1);
G = sshpc';
%
nreal = length(data);
%
%  likelihood
%
likl = 0 ;
for ll = 1:nreal
nvarnce =Y(end);
coef = 1/sqrt(2*pi*nvarnce);
dif  = obs(ll) - G(ll);
fatt = exp(-dif^2/(2*nvarnce));
likl = likl + log(coef * fatt);
end
% 
%
% Prior
pr = zeros(length(Y),1);
% pr(1) = 1/2;
% pr(2) = 1/2;
% pr(3) = 1/Y(3);

for i=1:size(Y,2)    
     if i < size(Y,2)    
            if  Y(i) < -1 || Y(i) > 1
             pr(i) = 0;
            else
             pr(i) = 1/2;           
            end
    else
        if  Y(i) < 0
            pr(i) = 0;
        else
            pr(i) = 1/Y(i);  % Jeffery prior
        end    
    end
end


%
f = log( prod(pr)  ) + likl;
%------------------------------------------  

