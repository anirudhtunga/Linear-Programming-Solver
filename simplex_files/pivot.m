function [T,B] = pivot(T,index,B)
i = index(1);
j = index(2);
m = size(T,1);
B(i-1) = j;  %because there is an extra reduced cost row in the tableau
a = T(i,j);
T(i,:) = T(i,:)/a;
for l = 1:m
    if l~=i
        x = T(l,j);
        T(l,:) = T(l,:) - x*T(i,:);
    end
end

end



        