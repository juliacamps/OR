%% Reset all
clc; close all; clear;

%% Move to working directory
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% Preparing vlfeat
cd('./vlfeat-0.9.16')
run('toolbox/vl_setup')

%% Move back to working directory
cd('./..')
addpath('./vlfeat-0.9.16');
addpath(genpath('./auxiliarMethods'));
addpath(genpath('./LabImages'));
vl_version
% Suppress warninigs
warning('off','MATLAB:singularMatrix')
warning('off','MATLAB:nearlySingularMatrix')

%% Settings
possibleImages = [1,2,3,4];
choosen = 4;
useSmallestScores = 1; % 1->True (will built H from the matches with smaller scores values) ; 0 -> False (with matches with higher score values)
 %% Images available
 switch(choosen)
    case 1
        % Reading image Llibre
        im1 = 'llibre1.jpg';
        im2 = 'llibre2.jpg';
    case 2
        % Reading image Moritz
        im1 = 'moritz1.jpg';
        im2 = 'moritz2.jpg';
    case 3
        % Reading image 1-2
        im1 = '1.jpg';
        im2 = '2.jpg';
    case 4
        % Reading image books
        im1 = 'books1.png';
        im2 = 'books2.png';
     otherwise
         % Reading image Llibre
        im1 = 'llibre1.jpg';
        im2 = 'llibre2.jpg';
end

%% Automatic matching
% I = vl_impattern('llibre1.jpg');
% I = single(rgb2gray(I));
% [f,d] = vl_sift(I);
% 
% % Show keypoints
% figure(1);
% show_keypoints(I,f);
% figure(2);
% show_keypoints(I,random_selection(f,50));
% Feature matching
I1 = rgb2gray(imread(im1));
I2 = rgb2gray(imread(im2));
Ia = single((I1));
Ib = single((I2));
[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);

% Compute the matching keypoints
% [matches, scores] = vl_ubcmatch(da, db);

% View the matches
% figure(3);
% show_matches(Ia, Ib,fa,fb,matches);
% figure(4);
% show_matches(Ia,Ib,fa,fb,random_selection(matches,50));

%% Matches with threshold
[matches, scores] = vl_ubcmatch(da, db, 2.0);
% figure(5);
% show_matches(Ia,Ib,fa,fb,matches);

%% TRY TO DETECT WHICH ARE THE BEST KEYPOINTS FROM THE MATCHES
% Using the 4 closest points
if useSmallestScores
    [B,sortIndexA] = sort(scores,'ascend');
    figure(1);
    title('Matches with lowest score value');
    show_matches(Ia,Ib,fa,fb,matches(:,sortIndexA(1:4)));
    smallMatches = matches(:,sortIndexA(1:4));
    Y1 = fa(1,smallMatches(1,:))';
    Y2 = fb(1,smallMatches(2,:))';
    X1 = fa(2,smallMatches(1,:))';
    X2 = fb(2,smallMatches(2,:))';
% Using the 4 most far away points
else
    [B,sortIndexD] = sort(scores,'descend');
    figure(1);
    title('Matches with highest score value');
    show_matches(Ia,Ib,fa,fb,matches(:,sortIndexD(1:4)));
    bigMatches = matches(:,sortIndexD(1:4));
    Y1 = fa(1,bigMatches(1,:))';
    Y2 = fb(1,bigMatches(2,:))';
    X1 = fa(2,bigMatches(1,:))';
    X2 = fb(2,bigMatches(2,:))';
end
%% Direct Linear Transformation matrix
H = DLT([X1 Y1],[X2 Y2]);

%% Projecting the image
I_T = zeros(size(I1,1),size(I1,2));
for i=1:size(I_T,1)
    for j=1:size(I_T,2)
        p = H\[i;j;1];
        x = round(p(1)/p(3));
        y = round(p(2)/p(3));
        if x>0 && y>0 && x <= size(I1,1) && y <= size(I1,2)
            I_T(i,j) = I1(x,y);
        end     
    end
end
I_T=mat2gray(I_T);
figure(3);
subplot(2,2,1);
title('Transformed Image')
imshow(I_T);
title('Transformed Image')
subplot(2,2,3);
title('Original Image')
imshow(I1);
title('Original Image')
subplot(2,2,4);
title('Target Image')
imshow(I2);
title('Target Image')
figure(4);
imshow(I_T);

%% Activate warnings
warning('on','MATLAB:nearlySingularMatrix')
warning('on','MATLAB:singularMatrix')
