function [ densites ] = extraitDensite(img, n, m)
    densites = zeros(n*m, 1);
    [lignes1, colonnes1] = size(img);
    pasLignes = ceil(lignes1/n);
    pasColonnes = ceil(colonnes1/m);
    
    imgCor = ones(pasLignes*n, pasColonnes*m);
    imgCor = 255*imgCor;
    
    for i=1:lignes1
        for j=1:colonnes1
            imgCor(i,j) = img(i, j);
        end
    end
    i = 1;
    j = 1;
    
    iDen = 1;
    for i=1:pasLignes:pasLignes*n
        for j=1:pasColonnes:pasColonnes*m
            img2 = subimage(imgCor, pasColonnes-1, pasLignes-1, j, i);
            densites(iDen) = sum(sum(img2)) / (pasColonnes*pasLignes*255);
            iDen = iDen+1;
        end
    end
end

