function thr_data = get_thresholds(data,num_levels)
%get_thresholds: this function determines the number of levels required and 
% outputs the actual thresholds 
% data: data matrix
% num_levels: number of levels chosen

[~,num_vars] = size(data);
if length(num_levels)==1
    num_levels=num_levels*ones(1,num_vars);
end

max_data = zeros(1,num_vars);
min_data = zeros(1,num_vars);
thr_data = cell(num_vars,1);
range = zeros(1,num_vars);
for i = 1 : num_vars
    max_data(i) = max(data(:,i));
    min_data(i) = min(data(:,i));
    % maximum range
    range(i) = max_data(i)-min_data(i);
    temp=min_data(i):(range(i)/num_levels(i)):max_data(i);
    thr_data{i,1} = temp(2:end-1);
    
    if max_data(i)==min_data(i)
        thr_data{i,1}=0.5;
    end
end

end
