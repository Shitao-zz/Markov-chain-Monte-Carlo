clear;
clc;

load ssh_h2a_60.mat
load aviso_ssh_dwh.mat

%mask = ~isnan(ssh_aviso(:,:,1));
%%%% mask is tricky, need to clean both in obs and models %%%%%%
mask = ~isnan(ssh_h2a_detrend(:,:,1,1));

%%% loop seems a bad choice but makes thing clear %%%% 

for i = 1:20
   temp_data = ssh_aviso(:,:,i);
   ssh_obs(:,i) = temp_data(mask);
end

for j = 1:20
    for i = 1:49
        temp_data = ssh_h2a_detrend(:,:,i,j);
        ssh_hycom(:,i,j) = temp_data(mask);
    end
end

save processed_data_20days.mat ssh_obs ssh_hycom La Lo

