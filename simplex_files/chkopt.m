function o = chkopt(T)
c = T(1,1:end-1);
if all(c(:)<=0)
    o =1;
else
    o =0;
end
end