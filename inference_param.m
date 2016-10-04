
close all; clear all;
NN = 30
load( ['data' num2str(NN)] )

xdd = linspace(0,1,30);
%ctt = [10 -2 7.5 -3.3 -3.2];
%yp = ctt(1) + ctt(2)*xdd + ctt(3)*xdd.^2 + ctt(4)*xdd.^3 + ctt(5)*xdd.^4;
%xp = xdd
data = yp;

                  
init = [9; 0.5; -0.5; 0.5; -0.5; var(data(:))];

D = numel(init);
iters = 50000; % Number of MCMC iterations
beta = 0.2;    % Parameters for MCMC algorith. 
sig0 = 0.1;  

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
    else
        %Adaptive MCMC
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
figure(1)

for i=1:size(chain,1)-1
subplot(2,3,i)
plot(chain(i,:),'k'); 
hold;
plot([0 size(chain,2)],[ct(i) ct(i)],'r')
ylabel(['C',num2str(i-1)])
xlabel('Iteration')
end

subplot(2,3,6)
plot(chain(end,:),'k'); hold on;
xlabel('Iteration')
ylabel('\sigma^2')

% plot([0 size(chain,2)],[0.1^2 0.1^2],'r')
export_fig('polynomial_test', '-pdf', '-r300', '-transparent');
