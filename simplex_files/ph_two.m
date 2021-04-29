function [T,B,u] = ph_two(T,B)
o = 0;
while o==0
    o=chkopt(T);
    if o==0;
        [index,u] = findpivot_ptwo(T,B);
        if u==1
            disp("Unbounded Problem");
            return;
        end
        [T,B] = pivot(T,index,B);
    else
        disp("Optimal Solution")
        %disp(T);
    end
end
end