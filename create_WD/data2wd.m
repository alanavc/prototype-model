function W=data2wd(INPUT,OUTPUT)
    if ~isnumeric(INPUT) || ~isnumeric(OUTPUT)
        error('data is not in matrix form');
    end
    if ~ismatrix(INPUT) || ~ismatrix(OUTPUT)
        error('data is not in matrix form');
    end    
    if ~isequal(size(OUTPUT),size(INPUT))
        error('dimensions of input and output do not match');
    end
    if sum(sum(isinf(INPUT)))>0 || sum(sum(isinf(OUTPUT)))>0
        error('data has INF values');
    end
    if sum(sum(isnan(INPUT)))>0 || sum(sum(isnan(OUTPUT)))>0
        error('data has NAN values');
    end    
    if sum(sum(~isreal(INPUT)))>0 || sum(sum(~isreal(OUTPUT)))>0
        error('data has nonreal values');
    end    
    
    num_vars=size(INPUT,2);
    W{num_vars}=[]; warned=zeros(1,num_vars);
    for i=1:num_vars
        [W{i},warned(i)]=data2wd_local(INPUT,OUTPUT(:,i),0);
%        if warned(i)==1
%            warning(['Variable ' num2str(i) ' had inconsistent data which was ignored']);        
%        end
    end
    if sum(warned)>0
        warning(['Variable(s) had inconsistent data which was ignored: '  num2str(find(warned==1))]);    
    end
    


end




function [W,warned]=data2wd_local(INPUT,OUTPUT,warn)
    
    if ~isnumeric(INPUT) || ~isnumeric(OUTPUT)
        error('data is not in matrix form');
    end
    if ~ismatrix(INPUT) || ~ismatrix(OUTPUT)
        error('Data is not in matrix form');
    end    
    if size(OUTPUT,1)~=size(INPUT,1)
        error('Dimensions of input and output do not match');
    end
    if sum(sum(isinf(INPUT)))>0 || sum(isinf(OUTPUT))>0
        error('Data has INF values');
    end
    if sum(sum(isnan(INPUT)))>0 || sum(isnan(OUTPUT))>0
        error('Data has NAN values');
    end    
    if sum(sum(~isreal(INPUT)))>0 || sum(~isreal(OUTPUT))>0
        error('Data has nonreal values');
    end    
    if ~exist('warn'), warn=1; end
        
    num_pts=length(OUTPUT);
    SIGNS=zeros(0,size(INPUT,2));
    warned=0;
    for i=1:num_pts
        for j=i+1:num_pts
            if OUTPUT(i)~=OUTPUT(j)
                if isequal(INPUT(i,:),INPUT(j,:))
                    if warn==1, warning('Inconsistent data found and will be ignored.'); end
                    warned=1;
                    continue;
                end
                SIGNS(end+1,:)=sign(INPUT(i,:)-INPUT(j,:)).*sign(OUTPUT(i)-OUTPUT(j));
            end
        end
    end       
    W=PrimaryDecomposition(SIGNS);
    if length(W)==0,
        W=zeros(1,size(W,2));
    end
end

