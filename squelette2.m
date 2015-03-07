%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Squelette de programme pour tp de reco de formes 	%%%%%
%%%%%   Clément Chatelain          janvier 2013		%%%%%
%%%%%   Département ASI - INSA de Rouen 		%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

clear all;

%%%%%%%%%%%%%%%%%%%% Apprentissage %%%%%%%%%%%%%%%%%%%%%%%%%

im = imread('app.tif'); % Lecture du fichier image d'apprentissage.
coordImages = extractionImages(im); 
nbImageBaseApp = length(coordImages);
sprintf('APPRENTISSAGE détection images OK : %d images detectées\n', nbImageBaseApp);

densites = zeros(nbImageBaseApp, 36);

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
    temp = extraitDensite(imageChiffreCroppee, 6, 6)
    densites(iImage, :) = temp';
    
    % Astuce : la classe de l'image courante est donnée par : iClasse = fix((iImage-1)/20)
    sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20))

end

% On enregistre la matrice pour l'étape suivante.
save('densites.mat', 'densites');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Décision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
load('densites.mat'); % On charge la matrice densites
imTest = imread('test.tif'); % Lecture du fichier image test
coordImagesTest = extractionImages(imTest);
length(coordImagesTest);
nbImageBaseTest = length(coordImagesTest);

retour = zeros(nbImageBaseTest, 1);

for (iImage=1 : nbImageBaseTest)
    largeur = coordImagesTest(iImage, 2) - coordImagesTest(iImage, 1) - 2;
    hauteur = coordImagesTest(iImage, 4) - coordImagesTest(iImage, 3) - 2;
    
    % Extraction image
    imageChiffre = subimage(imTest, largeur, hauteur, coordImagesTest(iImage, 1), coordImagesTest(iImage, 3));
    
    % crop
    imageChiffreCroppee = crop(imageChiffre);    
   
    % PRISE DE DECISION
    % On commence par extraite la densité de l'imagette actuelle, comme dans l'étape précédente.    
    densite = extraitDensite(imageChiffreCroppee, 6, 6);
    
    % On applique la fonction kppv qui retourne la classe la plus représentée parmi les k plus proches voisins.
    classe = kppv(densite, densites, 1);
    retour(iImage) = classe;
end

% On représente le vecteur résultat sous forme d'une matrice 10 * 10, comme l'image de test.
res = reshape(retour, 10, 10)';

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

%%%%%%%%% Matrice de confusion %%%%%%%%%%%

confusion = zeros(10,10);

for i=1:10
    for j=1:10
        confusion(i,j) = length(find(res(i,:) == j-1))*10; % i considéré comme j
    end
end

confusion

%%%%%%%%%  %%%%%%%%%

