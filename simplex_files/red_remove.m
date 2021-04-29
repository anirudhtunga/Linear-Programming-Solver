function [T,B] = red_remove(T,B,m,n)
%if write functions for removing red. constraints
art = n+1:m+n;
k = ismember(B,art);
if k==0
    disp("No redundant Constraints");
else
    disp("Redundant Constraints found");
    
    l = find(k==1);
    for dum=1:length(l)
        p = ismember(B,art);
        i = find(p==1,1);
        
        if T(i+1,1:n)==0
            T(i+1,:)=[];
            B(i)=[];
        else
            Y=T(i+1,:);
            j = find(Y~=0,1);
            index = [i+1,j];
            [T,B] = pivot(T,index,B);
        end
    end
    disp("Redundant Constraints Removed");
    disp(T);disp(B);
end

T(:,n+1:end-1)=[];
end