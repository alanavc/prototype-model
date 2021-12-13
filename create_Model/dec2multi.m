function D=dec2multi(m,multistates)
%function to go from decimal representation to multistate representation

D=[]; d=m;
for i=1:length(multistates)
    pro=prod(multistates(1+i:end));
    r=mod(d,pro); q=(d-r)/pro; d=d-q*pro; D=[D q];
end