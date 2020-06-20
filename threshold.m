function thresh = threshold(A,k)

N = max(max(A));
%choosing value for q;
Y =density_index(A,170);
if(Y>0 && Y < 0.01)
    q = 0.1;
elseif(Y>0.01 && Y<0.1)
    q = 0.5;
elseif(Y>0.1 && Y<0.2)
    q = 0.7;
else
    q = .9;
end;

nk = 0;
nt = 0;
maxm = 0.0;
t1 = 0;
[x,y] = size(A);

for t = k+1 : N
    m1 = zeros(1,t-k+1);
    m2 = zeros(1,N-t);

    for i = 1:x
        for j = 1:y
            if(A(i,j) <= k-1)  %k: boundary between mammogram and tissues
                nk = nk+1;
            end;
            if(A(i,j) >= k && A(i,j) <= t)
                nt = nt+1;
                m1(1,A(i,j)-k+1) = m1(1,A(i,j)-k+1)+1;  
            end;
            if(A(i,j) > t && A(i,j) <= N)
                m2(1,A(i,j)-t) = m2(1,A(i,j)-t)+1;  
            end;
        end;
    end;

    pk = nk/(x*y);
    pt = nt/(x*y);

    m1 = (m1/((pt-pk)*x*y)).^q;
    m2 = (m2/((1-pt)*x*y)).^q;

    s1 = 0;s2 = 0;
    for i = 1:max(N-t,t-k+1)
        if(i <= t-k+1)
            s1 = s1 + m1(1,i);
        end;
        if(i <= N-t)
            s2 = s2+m2(1,i);
        end;
    end;

    snt_a = (1/(1-q))*(1-1/s1);
    snt_b = (1/(1-q))*(1-1/s2);

    if((snt_a+snt_b) > maxm)
        maxm = (snt_a+snt_b);
        t1 = t;
    end;
end;
%t1
thresh = t1;






