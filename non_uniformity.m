function V = non_uniformity(A,m,k)

t = threshold(A,k);
%Assuming m to be odd
%Our mask is a m*m matrix with all elements 1 
%moving mean on a m*m window can be calculated as follow
[x,y] = size(A);
mean = zeros(x,y);
variance = zeros(x,y);
B = padarray(A,[(m-1)/2,(m-1)/2]);
for i = 1+(m-1)/2 : x+(m-1)/2
    for j = 1+(m-1)/2 : y+(m-1)/2
        for k = i-(m-1)/2:i+(m-1)/2
            for l = j-(m-1)/2:j+(m-1)/2
                mean(i-(m-1)/2,j-(m-1)/2) = mean(i-(m-1)/2,j-(m-1)/2)+B(k,l);
            end;
        end;
    end;
end;
mean = mean/(m*m);
padmean = padarray(mean,[(m-1)/2,(m-1)/2]);
%Now moving variance is calculated as follow
for i = 1+(m-1)/2 : x+(m-1)/2
    for j = 1+(m-1)/2 : y+(m-1)/2
        for k = i-(m-1)/2:i+(m-1)/2
            for l = j-(m-1)/2:j+(m-1)/2
                variance(i-(m-1)/2,j-(m-1)/2) = variance(i-(m-1)/2,j-(m-1)/2) + power((B(k,l)-padmean(k,l)),2);
            end;
        end;
    end;
end;
variance = variance/(m*m);
var = variance;
for i = 1:x
    for j = 1:y
        w = (power(variance(i,j),2));
        if(w <= t)
            var(i,j) = (w/t);
        else
            var(i,j) = 1;
        end;
    end;
end;
V = var;
