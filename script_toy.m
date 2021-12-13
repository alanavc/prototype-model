clear all

time_course_prefix='timecourse';
num_levels=[3,2,3,3,3];
file_for_disc_data='data0.mat';

%% discretize data
addpath('discretize_data')
discretize(time_course_prefix,num_levels,file_for_disc_data)

%% create wiring diagrams
file_for_wiring_diagrams='WD0.mat';
addpath('create_WD')
generate_wiring_diagrams(file_for_disc_data,file_for_wiring_diagrams)

%% select wiring diagram
addpath('select_WD')
W=select_best_wiring_diagram(file_for_wiring_diagrams);

%% create model
file_for_model='model0.mat';
addpath('create_Model')
generate_monotone_functions(file_for_disc_data,W,file_for_model)

%% simulate model
addpath('simulate_model')
init_state = [0 1 2 1 0];
num_simulations = 100;
num_steps = 6;
num_vars = 5;
% Propensity matrix
propensity_matrix = 0.8*ones(2,num_vars);
mean_trajectories = simulate(file_for_model,propensity_matrix,init_state,num_steps,num_simulations);
disp(mean_trajectories);

f=figure
subplot(1,2,2)
for i=1:5
    %subplot(2,5,i)
    plot(0:num_steps,mean_trajectories(:,i),'LineWidth',2)
    hold on
    ylim([-.2 2.2])
    
end
 hold off
 
 subplot(1,2,1)
 M=csvread([ '../codes/timecourse1.txt']);
 n=size(M,1);
    plot(0:n-1,M,'LineWidth',2)
    ylim([-.2 2.2])
    xlim([0 num_steps])

    print (f, 'toy_sim_octave.pdf');