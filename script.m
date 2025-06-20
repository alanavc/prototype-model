clear all

timecourse_prefix='axolotl_timecourse';
num_levels=2
file_for_disc_data='axolotl_disc_data.mat';

%% discretize data
addpath('discretize_data')
discretize(timecourse_prefix,num_levels,file_for_disc_data)

%% create wiring diagrams
file_for_wiring_diagrams='axolotlWD0.mat';
addpath('create_WD')
generate_wiring_diagrams(file_for_disc_data,file_for_wiring_diagrams)

%% select wiring diagram
addpath('select_WD')
threshold=1/5
W=select_best_wiring_diagram(file_for_wiring_diagrams,threshold);

%% create model
file_for_model='axolotl_model0.mat';
addpath('create_Model')
generate_monotone_functions(file_for_disc_data,W,file_for_model)

%% simulate model
addpath('simulate_model')
% init_state = [];
init_state = [1 1 0 0 0 0 0 0 0 1];
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
