
close all; clear all;
load( ['data' num2str(NN)] )

xdd = linspace(0,1,30);
ctt = [10 -2 7.5 -3.3 -3.2];
%yp = ctt(1) + ctt(2)*xdd + ctt(3)*xdd.^2 + ctt(4)*xdd.^3 + ctt(5)*xdd.^4;
%xp = xdd
data = yp;

                  
init = [9; 0.5; -0.5; 0.5; -0.5; var(data(:))];

D = numel(init);
iters = 5000; % Number of MCMC iterations
beta = 0.05;    % Parameters for MCMC algorith. 
sig0 = 0.15;  

SIGMA = sig0 * eye(D)./D;
chain = zeros(D, iters);
arate = 0; 
state = init;

Lp_state = posterior(state,data,xp,init);
% MCMC part
for ss = 1:iters
    %
    learnt=150;
    if ss < learnt
        mu = state;
        r = mvnrnd(mu,SIGMA,1);
        prop = r';
    else % Adaptive MCMC
        if mod(mod(ss,learnt),5)
            eps=0.000000001;
            mu = state;
            ecm = cov(chain(:,1:ss-1)');
            SIGMA = beta * ecm + eps*eye(D);
            r = mvnrnd(mu,SIGMA,1);     
            prop = r';
        else
            mu = state;
            r = mvnrnd(mu,SIGMA,1);                
            prop = r';
        end
    end 
    %
    Lp_prop = posterior(prop,data,xp,init);
    %
    if log(rand) < (Lp_prop - Lp_state)
        % Accept
        arate = arate + 1;
        state = prop;
        Lp_state = Lp_prop;
    end    
    chain(:, ss) = state(:);
    %
    num2str([ss arate/ss ])    
    diag(ss) = arate/ss;
    %    
end
arate = arate/iters;
%
ct = [10 -2 7.5 -3.3 -3.2];
%
% for i=1:size(chain,1)-1
% figure(i)
% plot(chain(i,:),'k'); 
% hold;
% plot([0 size(chain,2)],[ct(i) ct(i)],'r')
% end

%   plot variance
plot(chain(1,:),'k'); hold;
figure(8)
plot(chain(end,:),'k'); hold;
plot([0 size(chain,2)],[0.1^2 0.1^2],'r')

%   compare with data
cc2 = mean(chain(1:end-1,5000:end),2);

ct 
cc2'
norm(ct-cc2')
xn3 = linspace(0,1,200);
%
if  length(cc2) == 1
    ypred = cc2(1) + 0*xn3;
elseif length(cc2) == 2
    ypred = cc2(1) + cc2(2)*xn3;
elseif length(cc2) == 3
    ypred = cc2(1) + cc2(2)*xn3 + cc2(3)*xn3.^2;
elseif length(cc2) == 4
    ypred = cc2(1) + cc2(2)*xn3 + cc2(3)*xn3.^2 + cc2(4)*xn3.^3;
elseif length(cc2) == 5
    ypred = cc2(1) + cc2(2)*xn3 + cc2(3)*xn3.^2 + cc2(4)*xn3.^3 + cc2(5)*xn3.^4;
end

figure(10)
plot(xp,yp,'ob')
hold
plot(xn3,ypred,'-k')
yy = ct(1) + ct(2)*xn3 + ct(3)*xn3.^2 + ct(4)*xn3.^3 + ct(5)*xn3.^4;
plot(xn3,yy,'--r')

L = legend('Perturbed','Predicted','Exact','Location','SouthWest');
set(L,  'FontSize',12)

save(['chain_ord' num2str(length(cc2)-1) '_N' num2str(NN) ],... 
    'chain','diag','beta','sig0','init') 

 




