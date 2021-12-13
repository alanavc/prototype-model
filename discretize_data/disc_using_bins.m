function disc_data = disc_using_bins(data,thr_data)
% disc_using_bins: this function discretizes data using thresholds thr_data
% outputs the actual thresholds 
% thr_data: thresholds used for binning the data
% data: data matrix

[traj_size,num_vars] = size(data);
disc_data = zeros(size(data));

for i = 1 : num_vars
    for j = 1: traj_size
        for k=1:length(thr_data{i})
            disc_data(j,i) = length(thr_data{i});
            if data(j,i)<thr_data{i}(k)
                disc_data(j,i)=k-1; break;
            end
            
        end
        
    end

end
