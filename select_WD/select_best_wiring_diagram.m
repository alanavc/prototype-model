%function index_of_WD=select_best_wiring_diagram(file_for_wiring_diagrams)
function [W,index_of_WD]=select_best_wiring_diagram(file_for_wiring_diagrams,threshold)
  
load(file_for_wiring_diagrams,'allWD')

%% Find best adjacency matrix
n=size(allWD,2);
A = zeros(n,n);
AA = zeros(n,n);%Matrix with frequencies
for i=1:n
    for j=1:n
        freq1=length(find(allWD{1,i}(:,j)==1));
        freq2=length(find(allWD{1,i}(:,j)==-1));
        [rowNum,~]=size(allWD{1,i});
        if (freq1 > freq2 && freq1/rowNum>threshold)
            A(i,j)=1;
            AA(i,j)=freq1/rowNum;
        elseif (freq2 > freq1 && freq2/rowNum>threshold)
            A(i,j)=-1;
            AA(i,j)=freq2/rowNum;
%         elseif (i==j && freq1+freq2==0)
% %             A(i,j)=1;
%             AA(i,j)=1;
        end
    end
end
%disp(A)
%disp(AA)
%% Find distances
%distances=2*n*ones(n,n);%upper bound for distances
distances = cell(1,n);
indexes = zeros(1,n);
min_values = zeros(1,n);
for i=1:n
    m=size(allWD{1,i},1);
    distances{1,i}=2*n*ones(1,m);
    for j=1:m
        %distances(i,j) = pdist([A(i,:);allWD{1,i}(j,:)]);
        distances{1,i}(1,j) = norm( A(i,:)-allWD{1,i}(j,:) );
    end
    [M,I] = min(distances{1,i});
    indexes(1,i) = I;
    min_values(1,i) = M;
end
% [M,I] = min(distances,[],2);
% index_of_WD=I';
index_of_WD=indexes;

% Generate Best Wiring Diagram
W=zeros(n);
for i=1:n
    W(i,:)=allWD{i}(index_of_WD(i),:);
end