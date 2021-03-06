% Cette fonction applique la méthode des k plus proches voisins afin de déterminer la classe d'un caractère.
% - densitePoint : densité du point en traitement
% - matDensites : matrice contenant les densités des classes
% - k : nombre de plus proches voisins à considérer.

function [ classe ] = kppv( densitePoint, matDensites, k )
    
    distance = zeros(200,1);
    for i=1:200
        tmp = 0;
        for j=1:25
            tmp = tmp + abs(densitePoint(j) - matDensites(i,j));
        end
        distance(i) = tmp;
    end
    
    plusProches = zeros(k, 1);

    for i=1:k
       indice = find(distance == min(distance));
       plusProches(i) = floor(indice / 20);
       distance(indice, :) = max(distance);
    end
    
    sort(plusProches);
    
    classe = 0;
    for i=0:9
        if(nnz(plusProches == i) >  classe)
             classe = i;
        end;
    end
    
end

