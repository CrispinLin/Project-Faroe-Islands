function allin(s)
warning off all
for i=s:1:114
    i
    tic;
    calctest(i)
    toc;
end
return