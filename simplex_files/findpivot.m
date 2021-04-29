function [index] = findpivot(T,B) 
A = T(1,1:end-1);
j = find(A>0,1);

R = T(2:end,end)./T(2:end,j);
R(R<=0) = inf;
k = find(R==min(R(:)));
if length(k)>1
    i = find(B==min(B(k)));

else
    i=k;
end

index = [i+1,j];
    
%Finding pivots index using bland's rule. B is the xi's in the basis.
% add u, to check if unbounded.

    
 