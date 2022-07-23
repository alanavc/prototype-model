function generate_monotone_functions(file_for_disc_data,W,file_for_model)
%function to create a model from data and wiring diagram
%X_file: csv file containing the values of X
%FX_file: csv file containing the values of F(X)
%file_for_WD: Matlab file where wiring diagrams are (as a cell),
% index_of_WD: array that contains which local wiring diagram is chosen per variable

load(file_for_disc_data,'DISC_DATA')

num_timecourses=length(DISC_DATA);
X=[]; FX=[];
for i=1:num_timecourses
    %use deblank to remove ending spaces in file names
    time_course=DISC_DATA{i};
    X=[X; time_course(1:end-1,:)];
    FX=[FX; time_course(2:end,:)];
end
num_vars=size(X,2);

num_states=zeros(1,num_vars);
for i=1:size(X,2)
    num_states(i)=max([X(:,i);FX(:,i)])+1;
end

TRUTHTABLES={};
for n=1:num_vars
    I=find(W(n,:)~=0);
    %project to input variables
    localX=X(:,I);
    localW=W(n,I);
    localNumStates=num_states(I);
    %values for variable n
    knownValues=FX(:,n);
    [TTinputs,TToutputs]=create_monotone_local(localX,knownValues,localNumStates,num_states(n),localW);
    TRUTHTABLES{end+1}={TTinputs,TToutputs};
    %[TTinputs,TTlow,TThigh]=create_monotone_local(localX,knownValues,localNumStates,num_states(n),localW);
    %TRUTHTABLES{end+1}={TTinputs,TTlow,TThigh};
end

save('-v7', file_for_model, 'W','TRUTHTABLES')

display(['Model saved in file ' file_for_model])


end

%function to create truth table for one variable
function [TTinputs,TTlow,TThigh]=create_monotone_local(localX,V,localNumStates,numstates,localW)

localn=size(localX,2);

TTinputs=zeros(prod(localNumStates),localn);
TTlow=zeros(prod(localNumStates),1);
TThigh=TTlow;
for m=0:prod(localNumStates)-1
    %decimal (m) to multistate (D)
    D=dec2multi(m,localNumStates);
    %define initial f_max(D) and f_min(D)
    maxv=0; minv=numstates-1;
    %define set that will be used to define f_max(D) and f_min(D)
    Smax = []; Smin = [];
    for j=1:size(localX,1)
        if prod( localX(j,:).*localW <= D.*localW ), Smax=[Smax,V(j)]; end
        if prod( localX(j,:).*localW >= D.*localW ), Smin=[Smin,V(j)]; end
    end
    if ~isempty(Smax), maxv=max(Smax); end
    if ~isempty(Smin), minv=min(Smin); end
    TTinputs(m+1,:)=D;
    TThigh(m+1) = minv;
    TTlow(m+1) = maxv;
end



end

%%function to go from decimal representation to multistate representation
%function D=dec2multi(m,multistates)
%D=[]; d=m;
%for i=1:length(multistates)
%    pro=prod(multistates(1+i:end));
%    r=mod(d,pro); q=(d-r)/pro; d=d-q*pro; D=[D q];
%end
%end