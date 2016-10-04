
close all; clear all;

% load('processed_data_20days.mat');
load data_test.mat
%%%%%%%%%%%%%%%%%%% PC projection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
npt = L1_index_gen([6 6],0);
[nodes,w] = gen_full_quad([7 7],'GL');
dirNISP=nisp_gen_xw(npt,nodes,w);
model = ssh_hycom(:,:,1);
coeff = dirNISP*model';

% for k = 1:size(coeff,2)
% sshpc(k) = pce_eval([0.5,0.5],coeff(:,k),npt);
% end
                   
init = [0.5,0.5,0.1];

D = 3; % 2 random input parameters plus the variance parameter in the likelihood function
iters = 500; % Number of MCMC iterations
beta = 0.2;    % Parameters for MCMC algorithm, need to be tuned for a well mix chain. 
sig0 = 0.1;  % initial proposal distribution variance

SIGMA = sig0 * eye(D)./D;
chain = zeros(D, iters);
arate = 0; 
state = init;

Lp_state = posterior(state,ssh_obs,init,coeff,npt);
% MCMC part
for ss = 1:iters
    %
    learnt=150;
    if ss < learnt
        mu = state;
        r = mvnrnd(mu,SIGMA,1);
        prop = r;
    else
        %Adaptive MCMC
        if mod(mod(ss,learnt),5)
            eps=0.000000001;
            mu = state;
            ecm = cov(chain(:,1:ss-1)');
            SIGMA = beta * ecm + eps*eye(D);
            r = mvnrnd(mu,SIGMA,1);     
            prop = r;
        else
            mu = state;
            r = mvnrnd(mu,SIGMA,1);                
            prop = r;
        end
    end 
    %
    Lp_prop = posterior(prop,ssh_obs,init,coeff,npt);
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


figure(1)

for i=1:size(chain,1)-1
subplot(1,3,i)
plot(chain(i,:),'k'); 
hold;
plot([0 size(chain,2)],[ct(i) ct(i)],'r')
ylabel(['C',num2str(i-1)])
xlabel('Iteration')
end
% 
% subplot(2,3,6)
% plot(chain(end,:),'k'); hold on;
% xlabel('Iteration')
% ylabel('\sigma^2')
% export_fig('polynomial_test', '-pdf', '-r300', '-transparent');
