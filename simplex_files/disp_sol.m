function [o_c,x]= disp_sol(T,B)
o_c = T(1,end);
n = size(T,2)-1;
x = zeros(n,1);
for k = B
    i = find(k==B(:));
    x(k) = T(i+1,end);
end
disp("Optimal Cost:");
disp(o_c);
disp("solution:");
disp(x);

 