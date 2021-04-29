function [o_c,x] = lin_solve(A,b,c)
m = size(A,1);
n=size(A,2);
[T,B] = initialtab(A,b);
[T,B] =ph_one(T,B);
[T,B] = red_remove(T,B,m,n);
[T,B] = phtwoinitialize(c,T,B);
[T,B,u] = ph_two(T,B);
if u==1
    o_c=[];x=[];return;
end
[o_c,x] = disp_sol(T,B);
end