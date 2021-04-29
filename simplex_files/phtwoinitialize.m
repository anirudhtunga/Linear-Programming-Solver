function [T,B] = phtwoinitialize(c,T,B)
T(1,1:end-1) = -1*c';
T(1,end) = 0;
for j = B
    i =find(j==B(:));
    x = T(1,j)/T(i+1,j);
    T(1,:) = T(1,:)-x*T(i+1,:);
end
end

    
