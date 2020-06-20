function Y = density_index(A,T)

[x,y] = size(A);
c1 = 0;
for i = 1:x
    for j =1:y
        if(A(i,j) >=T+1 && A(i,j) <=255)
            c1 = c1+1; %no. of bright pixels
        end;
    end;
end;
Y = c1/(x*y);