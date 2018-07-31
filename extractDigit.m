function n=extractDigit(num)

n=0;
while num~=0
    num=floor(num/10);
    n=n+1;
end