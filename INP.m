%model_17_inp

%problem initialization Ax = b. Same as before

A = zeros(9,29);
A(1,1:5) = 1;
A(1,21) =1;

A(2,6:10)=1;
A(2,22) =1;

A(3,11:15)=1;
A(3,23) =1;

A(4,15:20)=1;
A(4,24)=1;
k =25;

for i=5:9
    for j=i-4:5:i+11
        A(i,j)=1;
    end
    A(i,k)=-1;
    k = k+1;
end

b =[350;225;195;275;185;50;50;200;185];

c =[45;13.9;29.9;31.9;9.9;42.5;17.8;31.0;35.0;12.3;47.5;19.9;24.0;32.5;12.4;41.3;12.5;31.2;29.8;11.0];
c(21:29)=0;
%problem intialization done


[o_c,x] = inp_solve(A,b,c)



%inp_solve() is my interior point method solver. 
%Centered interior point - barrier method implemented.
%Separate Primal and Dual steps implemented
%Infeasible starting point implemented. Only condition x>0 and s>0.


function [o_c,x] = inp_solve(A,b,c)

m = size(A,1);
n = size(A,2);

 

 x = ones(n,1); %infeasible starting point x>0
 s = ones(n,1); %infeasible starting point s>0

 y = linsolve(A',(c-s));


%INP parameters intialization
alpha = 0.995;
beta = 0.1;
e = 1e-6;
check =1;
iter = 0;
it = 1;
% Start of INP method
while(check==1)

u = beta * (s'*x)/n;

v = -1 *(s./x);

d = diag(v);

mat = zeros(m+n); 


mat(1:n,:) = [d,A'];
mat(n+1:end,1:n) = A; % mat is the (n+m) x (n+m) matrix



r = (c-(A'*y)) - u * (1./x);
k= b - A*x;

coeff = [r;k];


sol = linsolve(mat,coeff); %the main linear equations solving 
                           %step in INP



d_x = sol(1:n);          %delta x
d_y = sol(n+1:end);      %delta y

d_s = (c-(A'*y)) - s - (A'*d_y); %delta s


l_x = find(d_x<0);
l_s = find(d_s<0);

r_x = -1*(x(l_x)./d_x(l_x));
theta_x = min(r_x);

r_s = -1*(s(l_s)./d_s(l_s));
phi_s = min(r_s);

theta = min([1,(alpha*theta_x)]);  %theta 

phi = min([1,(alpha*phi_s)]);      %phi



x = x + theta * d_x;   %next iteration
y = y + phi * d_y;
s = s + phi * d_s;

ch = x .* s;          %ch used for checking condition



iter = iter +1;      %number of iteraions



if ch(:) < e         % checking condition. 
	                 %e initialized as 1e-6.
	check = 0;
end

fprintf('Iteration %d',it);
fprintf("\n");
disp(x);
it=it+1;

end

disp("Optimal Solution Found");

x= round(x,4);      %solution


cost = c'*x;

o_c = cost;         %optimum cost

end



