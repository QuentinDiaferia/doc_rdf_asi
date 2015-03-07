% Fonction permettant l'extraction de la densite de pixel d'une image.
% - img : image à traiter ;
% - n et m : nombre de zones par ligne et par colonne.

function [ densites ] = extraitDensite(img, n, m)
	% On crée un vecteur qui contiendra les densités de chaque zone.
    densites = zeros(n*m, 1);
    
    % On crée une seconde image dont les dimensions sont corrigées afin de correspondre au nombre de zones demandées.
    [lignes1, colonnes1] = size(img);
    pasLignes = ceil(lignes1/n);
    pasColonnes = ceil(colonnes1/m);
    
    % On remplit cette image de blanc.
    imgCor = ones(pasLignes*n, pasColonnes*m);
    imgCor = 255*imgCor;
    
    % On copie les valeurs de l'image initiale dans la nouvelle.
    for i=1:lignes1
        for j=1:colonnes1
            imgCor(i,j) = img(i, j);
        end
    end
    
    % Initialisation des compteurs pour le calcul de la densité.
    i = 1;
    j = 1;
    iDen = 1;
    
    for i=1:pasLignes:pasLignes*n
        for j=1:pasColonnes:pasColonnes*m
        
			% On extrait la zone de l'image à traiter.
            img2 = subimage(imgCor, pasColonnes-1, pasLignes-1, j, i);
         
			% Calcul de la densité.
            densites(iDen) = sum(sum(img2)) / (pasColonnes*pasLignes*255);
            iDen = iDen+1;
        end
    end
end

