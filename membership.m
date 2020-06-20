function pi = membership(A,k)

    maxn = max(max(A));
    t = threshold(A,k);
    
    fh = max((t-k),(maxn-t));
    z = double((abs(maxn-A)/fh).^2);
    pi = exp(-z);
    