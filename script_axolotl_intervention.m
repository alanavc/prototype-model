clear all

timecourse_prefix='axolotl_intervention_timecourse';
num_levels=3
file_for_disc_data='axolotl_intervention_disc_data.mat';

%discretize data
addpath('discretize_data')
discretize(timecourse_prefix,num_levels,file_for_disc_data)
%%
%create wiring diagrams
file_for_wiring_diagrams='axolotlWDIntervention.mat';
addpath('create_WD')
generate_wiring_diagrams(file_for_disc_data,file_for_wiring_diagrams)

%% select wiring diagram
addpath('select_WD')
threshold =3/4;
W=select_best_wiring_diagram(file_for_wiring_diagrams,threshold);

%% Plot wiring diagram
% [n,m]=size(W);
% A=W';
% P=zeros(n,m);
% for i=1:n
%     q=find(A(i,:)~=0);
%     if(isempty(q))
%         P(i,i)=1;
%     else
%         P(i,q)=1/length(q);
%     end
% end
% mc = dtmc(P);
% figure;
% graphplot(mc);

%% create model
file_for_model='axolotl_model_intervention.mat';
addpath('create_Model')
generate_monotone_functions(file_for_disc_data,W,file_for_model)

%% simulate model using SDDS
addpath('simulate_model')
% init_state = [];
init_state = [2	2 0	2 0	1 2	0 0	2];
% Number of simulations
num_simulations = 100;
% Number of iterations
num_steps = 6;
% Number of variables
n = 10;
% Propensity matrix
propensity_matrix = 0.9*ones(2,n);
mean_trajectories = simulate(file_for_model,propensity_matrix,init_state,num_steps,num_simulations);
plot(mean_trajectories)


%% Plot average trajectories 1-5
means = load('axolotl_intervention_timecourse.txt');
% TIME=[0 12 24 48 72 120 168];
TIME=0:6;
% for i=1:10
%     plot(TIME,means(:,i));hold on;
% end
% hold off;

% Number of iterations
nsteps = 6;
figure;
% ----Plot name----
tiledlayout(5,2, 'TileSpacing', 'compact')
% figure('Data', 'Model')
% subplot(2,2,1)
nexttile
plot(TIME,means(:,1),'b.-');%hold on;
legend('AREG');
% set(gca,'XTick',TIME)  
% set(gca,'XTickLabel',{'0','12','24','48','72','120','168'})
title('Data')

% subplot(2,2,2)
nexttile
hx1_mean1_u = plot(0:nsteps,mean_trajectories(:,1),'b.-');hold on
% hx1_std1 = plot(0:nsteps,mean_x1+std_x1,'b--',0:nsteps,mean_x1-std_x1,'b--');
% hold on 
legend('AREG');
title('Simulations')

% subplot(2,2,3)
nexttile
plot(TIME,means(:,2),'co-');%hold on;
legend('PHLDA2')

% subplot(2,2,4)
nexttile
hx2_mean1_u = plot(0:nsteps,mean_trajectories(:,2),'co-');hold on
% hx2_std1 = plot(0:nsteps,mean_x2+std_x2,'magenta--',...
%                 0:nsteps,mean_x2-std_x2,'magenta--');
legend('PHLDA2')

nexttile
plot(TIME,means(:,3),'green*-');%hold on;
legend('FGF9')
ylabel('Gene Expression')

nexttile
hx3_mean1_u = plot(0:nsteps,mean_trajectories(:,3),'green*-');
% hold on
% hx3_std1 = plot(0:nsteps,mean_x3+std_x3,'green--',...
%                 0:nsteps,mean_x3-std_x3,'green--'); 
legend('FGF9')
ylabel('Average Expression')

nexttile
plot(TIME,means(:,4),'red.-');%hold on;
legend('BMP2')

nexttile
hx4_mean1_u = plot(0:nsteps,mean_trajectories(:,4),'red.-');hold on
% hx1_std1 = plot(0:nsteps,mean_x1+std_x1,'b--',0:nsteps,mean_x1-std_x1,'b--');
% hold on 
legend('BMP2')

nexttile
plot(TIME,means(:,5),'ko-');%hold on;
legend('NRADD')
xlabel('Time Points')
% ylabel('Gene Expression')

nexttile
hx5_mean1_u = plot(0:nsteps,mean_trajectories(:,5),'ko-');
legend('NRADD')

xlabel('Time Steps')
% ylabel('Average Expression')


%% Plot average trajectories 6-10
means = load('axolotl_intervention_timecourse.txt');
% TIME=[0 12 24 48 72 120 168];
TIME=0:6;

% Number of iterations
nsteps = 6;
figure;
% ----Plot name----
tiledlayout(5,2, 'TileSpacing', 'compact')
% figure('Data', 'Model')
% subplot(2,2,1)
nexttile
plot(TIME,means(:,6),'b.-');%hold on;
legend('HAPLN3');
% set(gca,'XTick',TIME)  
% set(gca,'XTickLabel',{'0','12','24','48','72','120','168'})
title('Data')

% subplot(2,2,2)
nexttile
hx1_mean1_u = plot(0:nsteps,mean_trajectories(:,6),'b.-');hold on
% hx1_std1 = plot(0:nsteps,mean_x1+std_x1,'b--',0:nsteps,mean_x1-std_x1,'b--');
% hold on 
% legend('AREG');
legend('HAPLN3');
title('Simulations')

% subplot(2,2,3)
nexttile
plot(TIME,means(:,7),'co-');%hold on;
legend('SP7')

% subplot(2,2,4)
nexttile
hx2_mean1_u = plot(0:nsteps,mean_trajectories(:,7),'co-');hold on
% hx2_std1 = plot(0:nsteps,mean_x2+std_x2,'magenta--',...
%                 0:nsteps,mean_x2-std_x2,'magenta--');
% legend('PHLDA2')
legend('SP7')

nexttile
plot(TIME,means(:,8),'green*-');%hold on;
legend('Wnt5-a')
ylabel('Gene Expression')

nexttile
hx3_mean1_u = plot(0:nsteps,mean_trajectories(:,8),'green*-');
% hold on
% hx3_std1 = plot(0:nsteps,mean_x3+std_x3,'green--',...
%                 0:nsteps,mean_x3-std_x3,'green--'); 
% legend('FGF9')
legend('Wnt5-a')
ylabel('Average Expression')

nexttile
plot(TIME,means(:,9),'red.-');%hold on;
legend('Inhbb')

nexttile
hx4_mean1_u = plot(0:nsteps,mean_trajectories(:,9),'red.-');hold on
% hx1_std1 = plot(0:nsteps,mean_x1+std_x1,'b--',0:nsteps,mean_x1-std_x1,'b--');
% hold on 
legend('Inhbb')

nexttile
plot(TIME,means(:,10),'ko-');%hold on;
legend('DUSP6')
xlabel('Time Points')
% ylabel('Gene Expression')

nexttile
hx5_mean1_u = plot(0:nsteps,mean_trajectories(:,10),'ko-');
legend('DUSP6')

xlabel('Time Steps')
% ylabel('Average Expression')

