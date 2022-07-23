function discretize(time_course_prefix,num_levels,file_for_disc_data,thr_data)
  
ALL_FILES=dir([time_course_prefix '*']);
num_files=length(ALL_FILES);
data_combined=[];

for i=1:num_files
    time_course=csvread(ALL_FILES(i).name); 
    data_combined=[data_combined; time_course];
end

if ~exist('thr_data'), thr_data=get_thresholds(data_combined,num_levels); end
%disp(thr_data)

DISC_DATA=cell(num_files,1);
for i=1:num_files
    time_course=csvread(ALL_FILES(i).name); 
    DISC_DATA{i,1}=disc_using_bins(time_course,thr_data);
end

save('-v7', file_for_disc_data, 'DISC_DATA')
display(['Discretized data saved in file ' file_for_disc_data])