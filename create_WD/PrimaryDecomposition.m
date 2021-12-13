function [compactP,P]=PrimaryDecomposition(SIGNS)
    %% function to find primary decomposition
    %SIGNS mxn matrix with entries in {-1,0,1}
    %m=num of signs, n=num vars
    num_vars=size(SIGNS,2);
    if ~isProper(SIGNS), P={}; compactP=zeros(0,num_vars); return; end
    
    SIGNS=findMinimal(SIGNS,@(s1,s2)isDivisor(s1,s2));
    if sum(abs(SIGNS))==0, P={}; compactP=zeros(0,num_vars); return; end
    
    P={}; %primary dec
    D={SIGNS}; %remaining ideals
    while length(D)>0
        %disp('D,P=');disp(D); disp(P)
        clear('DI');
        DI{length(D)}={};
        for i=1:length(D)
            DI{i}=factorIdeal(D{i});
        end
        D=[DI{:}];
        %disp('factored'); disp(D);
        for i=length(D):-1:1
            if ~isProper(D{i})
                D(i)=[]; continue;
            end
            if isPrimary(D{i})
                P{end+1}=D{i}; D(i)=[]; 
            end
        end 
    end
    P=findMinimal_cell(P,@(A,B)isSubset(A,B));
    compactP=zeros(length(P),num_vars);
    for i=1:length(P)
        compactP(i,:)=sum(P{i},1);
    end
end

function yn=isSubset(A,B)
    yn=prod(ismember(A,B,'rows'));
end

function yn=isDivisor(s1,s2)
    if sum(abs(s1))==0; yn=1; return; end
    yn=(isequal(s1.*s2,abs(s1)) && isempty(find(s1.*s2==-1,1)));
end

function B = setEqualtoZero(B,z)
    for i=size(B,1):-1:1
        s=B(i,:);
        if isDivisor(z,s), B(i,:)=[]; continue; end
        if isDivisor(-z,s), B(i,:)=s.*(z==0); end
    end
    B=[B;z];
end

function minG=findMinimal(G,ord)
    minG=[];
    for i=1:size(G,1)
        s=G(i,:); skip_s=0;
        for j=1:size(minG,1)
            if ord(minG(j,:),s), skip_s=1; continue; end
        end
        if skip_s==1, continue; end
        for j=size(minG,1):-1:1
            if ord(s,minG(j,:)), minG(j,:)=[]; end
        end
        minG(end+1,:)=s;
    end
end

function minG=findMinimal_cell(G,ord)
    minG={};
    for i=1:length(G)
        s=G{i}; skip_s=0;
        for j=1:length(minG)
            if ord(minG{j},s), skip_s=1; continue; end
        end
        if skip_s==1, continue; end
        for j=length(minG):-1:1
            if ord(s,minG{j}), minG(j)=[]; end
        end
        minG{end+1}=s;
    end
end

function redG=simplifyGens(G)
    redG=unique(findMinimal(G,@(s1,s2)isDivisor(s1,s2)),'rows');
end

function yn=isLinear(s)
    yn=(sum(abs(s))==1);
end

function yn=isPrimary(G)
    for i=1:size(G,1)
        if ~isLinear(G(i,:)), yn=0; return; end
    end
    yn=1;
end

function F=getFactors(s)
    F=[]; n=length(s);
    for i=1:n
        if s(i)~=0, si=zeros(1,n); si(i)=s(i); F(end+1,:)=si; end
    end
end

function yn=isProper(G)
    if sum(abs(G))==0, yn=0; return; end
    for i=1:size(G,1)
        si=G(i,:);
        if ~isLinear(si), continue; end
        for j=i+1:size(G,1)
            sj=G(j,:);
            if isLinear(sj) && isequal(si,-sj)
                yn=0; return;
            end
        end
    end
    yn=1;
end

function FacG=factorIdeal(G)
    nonlin=[];
    for i=1:size(G,1)
        if ~isLinear(G(i,:))
            nonlin=G(i,:); continue;
        end
    end
    if isempty(nonlin)
        FacG={G}; return;
    end
    allfactors=getFactors(nonlin);
    m=size(allfactors,1);
    FacG{m}=[];
    for i=1:m
        FacG{i}=simplifyGens(setEqualtoZero(G,allfactors(i,:)));
    end
end


    
    

        

            
            
    
    