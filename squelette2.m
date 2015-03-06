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
im = imread('app.tif'); % lecture fichier image d'apprentissage
coordImages = extractionImages(im); 
nbImageBaseApp = length(coordImages);
sprintf('APPRENTISSAGE détection images OK : %d images detectées\n', nbImageBaseApp);

%preparation perceptron
bias = -1;
coeff = 0.7;
rand('state',sum(100*clock));
weights = -1*2.*rand(200,1);

densites=zeros(nbImageBaseApp, 36);

for (iImage=1 : nbImageBaseApp)
    iImage;
    % localisation et extraction des imagettes
    largeur = coordImages(iImage, 2) - coordImages(iImage, 1) - 2;
    hauteur = coordImages(iImage, 4) - coordImages(iImage, 3) - 2;
    x0 = coordImages(iImage, 1);
    y0 = coordImages(iImage, 3);
    imageChiffre = subimage(im, largeur, hauteur, x0, y0);
  
    % crop (supprimer les bords blancs)
    imageChiffreCroppee = crop(imageChiffre);    
    %imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres    
    
    %%%%%% ICI c'est à vous de Jouer ! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = extraitDensite(imageChiffreCroppee, 6, 6)
    densites(iImage, :) = temp';
    
    % Astuce : la classe de l'image courante est donnée par : iClasse = fix((iImage-1)/20)
    sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20))

end

iterations = 1000

for i = 1:iterations
     out = zeros(4,1);
     for j = 1:200
         
         y = bias * weights(1,1);
         
         y = norm(densites(j)) * weights(j,1);
         
          out(j) = 1/(1+exp(-y));
          delta = desired_out(j)-out(j);
          weights(1,1) = weights(1,1)+coeff*bias*delta;
          
          weights(2,1) = weights(2,1)+coeff*input(j,1)*delta;
          weights(3,1) = weights(3,1)+coeff*input(j,2)*delta;
     end
end

save('densites.mat', 'densites');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Décision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
load('densites.mat');
imTest = imread('test.tif'); % lecture fichier image test
coordImagesTest = extractionImages(imTest);
length(coordImagesTest);
nbImageBaseTest = length(coordImagesTest);

retour = zeros(nbImageBaseTest, 1);

for (iImage=1 : nbImageBaseTest)
    largeur = coordImagesTest(iImage, 2) - coordImagesTest(iImage, 1) - 2;
    hauteur = coordImagesTest(iImage, 4) - coordImagesTest(iImage, 3) - 2;
    
    % extraction image
    imageChiffre = subimage(imTest, largeur, hauteur, coordImagesTest(iImage, 1), coordImagesTest(iImage, 3));
    
    % crop
    imageChiffreCroppee = crop(imageChiffre);    
    %imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres
   
    %%%%%% ICI c'est à vous de Jouer !!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % appliquer le modèle sauvegardé sur les chiffres de l'image de test ...
    
    densite = extraitDensite(imageChiffreCroppee, 6, 6);
    
    classe = kppv(densite, densites, 1);
    retour(iImage) = classe;
end

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

