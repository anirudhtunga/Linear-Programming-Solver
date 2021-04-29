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
        A(i,j)=-1;
    end
    A(i,k)=-1;
    k = k+1;
end

A =A(:,1:20);


d =[350;225;195;275;-185;-50;-50;-200;-185];

c =[45;13.9;29.9;31.9;9.9;42.5;17.8;31.0;35.0;12.3;47.5;19.9;24.0;32.5;12.4;41.3;12.5;31.2;29.8;11.0];
%c(21:29)=0;
S=[];
r=[];
lb=zeros(20,1);
ub=[];
%[x,fval] = linprog(c,S,r,A,d,lb);
options = optimoptions('linprog','Algorithm','interior-point');
[x,fval] = linprog(c,A,d,S,r,lb,ub,options)

