function f = posterior(Y,data,init,coeff,npt)
   
cc = Y(1:end-1);   %parameters in [-1 1] space

for k = 1:size(coeff,2)
sshpc(k) = pce_eval(cc,coeff(:,k),npt);
end

obs = data(:,1);
G = sshpc';
%
nreal = length(data);
%
%  likelihood
%
likl = 0 ;
for ll = 1:nreal
%
nvarnce =Y(end);
%
coef = 1/sqrt(2*pi*nvarnce);
dif  = obs(ll) - G(ll);
fatt = exp(-dif^2/(2*nvarnce));
likl = likl + log(coef * fatt);
end
% 
%
% Prior
pr = zeros(length(Y),1);
pr(1) = 1/2;
pr(2) = 1/2;
pr(3) = 1/Y(3);


%
f = log( prod(pr)  ) + likl;
%------------------------------------------  

