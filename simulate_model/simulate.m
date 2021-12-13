function mean_trajectories = simulate(file_for_model,propensity_matrix,init_state,num_steps,num_simulations)
    
% Calculate size of truth tables
load(file_for_model)
n=size(TRUTHTABLES,2);
tt_max=0;
tt_sizes=zeros(1,n);
for i=1:n
    k=size(TRUTHTABLES{1,i}{1,2},1);
    tt_sizes(i)=k;
    if k>tt_max
        tt_max=k;
    end
end
% Create truth table
F = -1*ones(tt_max,n);
for i=1:n
    F(1:tt_sizes(1,i),i)=TRUTHTABLES{1,i}{1,2};
end
% disp(F)
% Find nv and max indegree
nv=zeros(1,n);
for i=1:n
    nv(i)=size(TRUTHTABLES{1,i}{1,1},2);
end
max_indegree=max(nv);

% Find varF and max levels
varF=-1*ones(max_indegree,n);
max_levels = -1*ones(max_indegree,n);
for i=1:n
    varF(1:nv(i),i)=find(W(i,:)~=0);
    max_levels(1:nv(i),i) = max(TRUTHTABLES{1,i}{1,1});
end
%number of states per variable
p=max(max(max_levels))+1;

indexes=cell(n,1);
constant_nodes = find(nv==0);
for i=1:n
    indexes{i,1}=zeros(tt_sizes(i),1);
    if ~ismember(i,constant_nodes)
        for j=1:tt_sizes(i)
            x=TRUTHTABLES{1,i}{1,1}(j,:);
            %disp(x)
            indexes{i,1}(j) = multistate2dec(x,p,nv(i));
            %disp(multistate2dec(x,p,nv(i)))
        end
    end
end

% Embed system so that each node has same number of states
FF=-1*ones(p^max_indegree,n);

for i=1:n
    if ismember(i,constant_nodes)
        FF(1:p,i)=0;
    else
        for j=1:p^nv(i)
            x=dec2multistate(j-1,p,nv(i));
            for k=1:nv(i)
                if x(k)>max_levels(k,i)
                    x(k)=max_levels(k,i);
                    %disp(x)
                end
            end
            r=multistate2dec(x,p,nv(i));
            s = find(indexes{i,1}==r);
            %disp(s)
            FF(j,i)=F(s,i);
        end
    end
end

% SDDS simulations from given initialization
if isempty(init_state)
    InitialState = dec2multistate(0-1,p,n);
else
    InitialState = init_state;
end
% % Propensity matrix
c = propensity_matrix;
% % c = 0.5*ones(2,n);

% % Number of iterations
nsteps = num_steps;

trajectories = zeros(nsteps+1,n,num_simulations);
for i = 1 : num_simulations
    [~, traj_binary] = SDDSRun(InitialState,FF,varF,nv,p,c,nsteps);
%     disp(traj_binary);
    trajectories(:,:,i)=traj_binary;
end
mean_trajectories = mean(trajectories,3);

end