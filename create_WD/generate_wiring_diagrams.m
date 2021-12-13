function generate_wiring_diagrams(file_for_disc_data,output_file_for_WD)
%function to compute wiring diagrams consistent with time courses
%time_course_prefix: prefix of csv files file containing the time courses
%output_file_for_WD: Matlab file where wiring diagrams will be saved (as a cell),
% WD{i} will contain all local wiring diagrams for variable i (one per line)

load(file_for_disc_data,'DISC_DATA')

num_timecourses=length(DISC_DATA);
X=[]; FX=[];
for i=1:num_timecourses
    %use deblank to remove ending spaces in file names
    time_course=DISC_DATA{i};
    X=[X; time_course(1:end-1,:)];
    FX=[FX; time_course(2:end,:)];
end
allWD=data2wd(X,FX);
% ALL_FILES=ls([time_course_prefix '*']);
% % ALL_FILES=ls([time_course_prefix]);
% num_files=size(ALL_FILES,1);
% X=[]; FX=[];
% for i=1:num_files
%     %use deblank to remove ending spaces in file names
%     time_course=csvread( deblank(ALL_FILES(i,:)) ); 
%     %time_course=readmatrix( deblank(ALL_FILES(i,:)) ); 
%     X=[X; time_course(1:end-1,:)];
%     FX=[FX; time_course(2:end,:)];
% end
% allWD=data2wd(X,FX);

%for i=1:size(X,2)
%    csvwrite(['wd' num2str(i) '.txt'],allWD{i});
%end

% save('-mat7-binary', output_file_for_WD, 'allWD')
save('-v7', output_file_for_WD, 'allWD')
display(['Wiring diagrams saved in file ' output_file_for_WD])
