%model_17.m



%problem initialization - A, b, and c, in standard form
%Ax =b
%problem should be minimization form

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


%lin_solve is my LP solver. It returns the optimum cost and the optimum x value.

[o_c,x] = lin_solve(A,b,c)


%In lin_solve, each part of the model is handeled by a function.


function [o_c,x] = lin_solve(A,b,c)
m = size(A,1);
n=size(A,2);

[T,B] = initialtab(A,b); %initialtab() adds the artificial variables and initializes the initial tableau.
                         % T is the tableau and B is an array whic has the indices of the basic variables.

[T,B,f] =ph_one(T,B);   %phase one of the two phase approach. It also checks for feasibility and returns f=1 
                        %when feasible

if f==1
[T,B] = red_remove(T,B,m,n); % checks and removes the redundant constraints if any. It reurns the tableau without
                             % the artificial variables

[T,B] = phtwoinitialize(c,T,B); %initializes the reduced costs of the tableau for the phase 2.

[T,B,u] = ph_two(T,B); %phase two of the 2-phase approach. It checks for unboundedness
                       %If unbounded, it displays a message and returns u=1.
if u==1
    o_c=[];x=[];return;
end
[o_c,x] = disp_sol(T,B); % finally displays the optimum cost and the optimum x.
end
end








function [T,B] = initialtab(A,b) %adds the artificial variables and initializes the initial tableau.
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



function [T,B,f]= ph_one(T,B)
o =0;
while o==0
    o=chkopt(T);
    if (o==0)
        index = findpivot(T,B);
        [T,B] = pivot(T,index,B);
        
    else 
        if(T(1,end)<1e-6)  %similar to T(1,end)==0, but only till 10^-6.
            disp("LP is Feasible"); %check for feasibility, cost=0 at the end of phase 1.
            f=1;
        else
            disp("LP is not Feasible");
            f=0;
        end
        
        
    end
end
end
    


 function [T,B] = red_remove(T,B,m,n) % checks for redundant constraints and removes them.

k = ismember(B,art);                  % if artificial variables in basis, then redundant constraints exist.
if k==0
    disp("No redundant Constraints");
    disp("A has full row rank");
else
    disp("Redundant Constraints found");
    
    l = find(k==1);                 % removing redundant constraints
    for dum=1:length(l)
        p = ismember(B,art);
        i = find(p==1,1);
        
        if T(i+1,1:n)==0           %if all elememts of (B^-1 * A) in the row corresponding to artificial variable 
            T(i+1,:)=[];           %in the basis =0, then eliminate the row
            B(i)=[];
        else
            Y=T(i+1,:);
            j = find(Y~=0,1);      %else, pivot at the first non-zero element, to drive the artificial variable out.
            index = [i+1,j];
            [T,B] = pivot(T,index,B);
        end
    end
    disp("Redundant Constraints Removed"); %The redundant constraints are removed.
    disp(T);disp(B);
end

T(:,n+1:end-1)=[];              %removing the artificial variables.
end



function [T,B] = phtwoinitialize(c,T,B) %phase 2 initialization - reduced costs
T(1,1:end-1) = -1*c';
T(1,end) = 0;
for j = B
    i =find(j==B(:));
    x = T(1,j)/T(i+1,j);
    T(1,:) = T(1,:)-x*T(i+1,:);
end
end

    

function [T,B,u] = ph_two(T,B) % phase 2
o = 0;
while o==0
    o=chkopt(T);               %chkopt() checks if the tableau is optimal and returns 1 when optimal.
    if o==0
        [index,u] = findpivot_ptwo(T,B); %findpivot_ptwo() returns the index of the pivot element
        if u==1                          %It also checks if the problem is unbounded, if unbounded, 
            disp("Unbounded Problem");   %it returns u=1.
            return;
        end
        [T,B] = pivot(T,index,B);
    else
        disp("Optimal Solution found.") %when tableau is optimal
        
    end
end
end



function [o_c,x]= disp_sol(T,B) % displays the solution
o_c = T(1,end);
n = size(T,2)-1;
x = zeros(n,1);
for k = B
    i = find(k==B(:));
    x(k) = T(i+1,end);
end
disp("Optimal Cost:");  %optimal cost
disp(o_c);
disp("solution:");      %optimal x value
disp(x);
end




function [T,B] = pivot(T,index,B) %does the pivot operation on the tableau.
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




%Finding pivots index using bland's rule. B is the xi's in the basis.
function [index] = findpivot(T,B) %finds the pivot element based on Bland's rule. 
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
end
    


    
function [index,u] = findpivot_ptwo(T,B) %finds the pivot element based on Bland's rule.
	                                     %also checks for unboundedness.
A = T(1,1:end-1);
j = find(A>0,1);

W=T(2:end,j);
if W<=0                      %checking for unboundedness. expression evaluates the whole vector.
    u =1;index=[1,1];return; % u, to check if unbounded.
end

R = T(2:end,end)./T(2:end,j);
R(R<=0) = inf;
k = find(R==min(R(:)));
if length(k)>1
    i = find(B==min(B(k)));

else
    i=k;
end
u =0;
index = [i+1,j];
end
    

     

function o = chkopt(T) %checks if the tableau is optimal or not. 
c = T(1,1:end-1);     
if all(c(:)<=0)
    o =1;              %returns 1 if optimal
else
    o =0;              %returns 0 if not optimal
end
end






