function [T,B] = initialtab(A,b)
m = size(A,1);
n=size(A,2);
i = eye(m); %artificial variables
A = [A,i];
c_b = ones(m,1);
c = [zeros(n,1);c_b];

top = (c_b)'*A - c';
f = [top;A];
cost = (c_b)'*b;
r =[cost;b];
T =[f,r];
B = n+1 : n+m;
end
