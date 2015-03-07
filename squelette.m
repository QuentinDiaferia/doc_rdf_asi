%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Squelette de programme pour tp de reco de formes 	%%%%%
%%%%%   Clément Chatelain          janvier 2013		%%%%%
%%%%%   Département ASI - INSA de Rouen 		%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% rapport : moins de 10 pages
% pas les figures du sujet
% nos données, nos valeurs, nos problèmes
% insister sur notre grain de sel et nos analyses
% ANALYSE DES RESULTATS

clear all;

%%%%%%%%%%%%%%%%%%%% Apprentissage %%%%%%%%%%%%%%%%%%%%%%%%%
im = imread('app.tif'); % Lecture du fichier image d'apprentissage.
coordImages = extractionImages(im); 
nbImageBaseApp = length(coordImages);
sprintf('APPRENTISSAGE détection images OK : %d images detectées\n', nbImageBaseApp);

densites = zeros(nbImageBaseApp, 25);

for (iImage=1 : nbImageBaseApp)
    iImage;
    % Localisation et extraction des imagettes.
    largeur = coordImages(iImage, 2) - coordImages(iImage, 1) - 2;
    hauteur = coordImages(iImage, 4) - coordImages(iImage, 3) - 2;
    x0 = coordImages(iImage, 1);
    y0 = coordImages(iImage, 3);
    imageChiffre = subimage(im, largeur, hauteur, x0, y0);
  
    % crop (supprimer les bords blancs)
    imageChiffreCroppee = crop(imageChiffre);    
    % imagesc(imageChiffreCroppee);  
    
    % APPRENTISSAGE
    % Calcul des densités
    densites(iImage, :) = extraitDensite(imageChiffreCroppee, 5, 5);
    
    % Astuce : la classe de l'image courante est donnée par : iClasse = fix((iImage-1)/20)
    sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20))
    

    %%%%%%%%%%%%%%%%%%%%%%
end

% On calcule, pour chaque classe, la moyenne des dix densités calculées ci-dessus.
moyenne = zeros(10,25);
for i=1:10
    moyenne(i,:) = mean(densites( ((i-1)*20+1):20*i ,:));
end

% On enregistre les densites et leur moyenne pour reutilisation.
save('moyenne.mat', 'moyenne');
save('densites.mat', 'densites');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Decision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% On récupère les deux variables moyenne et densites.
load('moyenne.mat');
load('densites.mat');
imTest = imread('test.tif'); % Lecture du fichier image test
coordImagesTest = extractionImages(imTest);
nbImageBaseTest = length(coordImagesTest);

% La matrice retour stockera toutes les classes déterminées.
retour = zeros(nbImageBaseTest, 1);

for (iImage=1 : nbImageBaseTest)
    largeur = coordImagesTest(iImage, 2) - coordImagesTest(iImage, 1) - 2;
    hauteur = coordImagesTest(iImage, 4) - coordImagesTest(iImage, 3) - 2;
    
    % Extraction image
    imageChiffre = subimage(imTest, largeur, hauteur, coordImagesTest(iImage, 1), coordImagesTest(iImage, 3));
    
    % crop
    imageChiffreCroppee = crop(imageChiffre);    
    % imagesc(imageChiffreCroppee);
    
    % PRISE DE DECISION
    
    % On extrait les densités des zones de l'imagette.
    densite = extraitDensite(imageChiffreCroppee, 5, 5);
    
    % Le but est de calculer la distance entre la densité qui vient d'être calculée et les densités moyennes des classes, afin de trouver la plus proche.
    distance = zeros(10,25);
    for i=1:10
        num = exp(-10*(abs(densite - moyenne(i) )));
        denom = 0;
        for j=1:10
            denom = denom + exp(-10 * abs( densite - moyenne(j) ));
        end
        distance(i,:) = num./denom;
    end
    
    normes = zeros(10,1);
    for i=1:10
        normes(i) = sqrt(sum(distance(i,:).^2)); % Calcul de la norme à la main, sinon matlab plante
    end
    
    retour(iImage) = find(normes == min(normes)) - 1;
    %%%%%%%%%%%%%%%%%%%%%%
end

res = reshape(retour, 10, 10);

%%%%%%%%% Calcul des performances %%%%%%%%
reussite = 0;
for i=1:10
    for j=1:10
       if  res(i,j) == i-1
           reussite = reussite + 1;
       end
    end
end

reussite
