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

%% Settings
possibleImages = [1,2,3,4,5];
choosen = 4;
automaticInput = 1; % 1->True, 0->False
%% Images available
 switch(choosen)
    case 1
        % Reading image Llibre
        I_1 = (imread('llibre1.jpg'));
        I_2 = (imread('llibre2.jpg'));
        % Hard coded previous input points LLIBRE
        if automaticInput
            Y1 = [187;188;572;563];
            X1 = [116;177;152;257];
            Y2 = [129;132;563;561];
            X2 = [132;193;133;193];
        end
    case 2
        % Reading image Moritz
        I_1 = (imread('moritz1.jpg'));
        I_2 = (imread('moritz2.jpg'));
        % Hard coded previous input points MORITZ
        if automaticInput
            Y1 = [135;309;226;418];
            X1 = [52;130;298;210];
            Y2 = [254;326;269;388];
            X2 = [112;137;312;194];
        end
    case 3
        % Reading image 1-2
        I_1 = (imread('1.jpg'));
        I_2 = (imread('2.jpg'));
        % Hard coded previous input points 1-2
        if automaticInput
            Y1 = [134;310;224;781];
            X1 = [157;229;478;299];
            Y2 = [140;385;277;862];
            X2 = [110;209;476;301];
        end
    case 4
        % Reading image books
        I_1 = (imread('books1.png'));
        I_2 = (imread('books2.png'));
        % Hard coded previous input points BOOKS
        if automaticInput
            Y1 = [211;985;418;1066];
            X1 = [350;428;998;845];
            Y2 = [10;829;148;829];
            X2 = [356;431;1001;851];
        end
    case 5
        % Reading image Llibre
        I_1 = rgb2gray(imread('llibre1.jpg'));
        I_2 = rgb2gray(imread('llibre2.jpg'));
        % Shifting
        X1 = [266;226;357;398];
        Y1 = [159;299;162;299];
        X2 = [366;326;457;498];
        Y2 = [159;299;162;299];
    otherwise
        % Reading image Llibre
        I_1 = rgb2gray(imread('llibre1.jpg'));
        I_2 = rgb2gray(imread('llibre2.jpg'));
        % Identity
        X1 = [266;226;357;398];
        Y1 = [159;299;162;299];
        X2 = [266;226;357;398];
        Y2 = [159;299;162;299];
end
%% Manual keypoints entry
if ~automaticInput
    % Manual correspondence points matching
    figure(1);
    imshow(I_1);
    [Y1,X1] = ginput(4);
    
    figure(2);
    imshow(I_2);
    [Y2,X2] = ginput(4);
end

%% Direct Linear Transformation matrix
H = DLT([X1 Y1],[X2 Y2]);

%% Projecting the image
I_T = zeros(size(I_1,1),size(I_1,2),3);
I_T1 = I_1;
for i=1:size(I_T,1)
    for j=1:size(I_T,2)
        I_T1(i,j)=0;
        p = H\[i;j;1];
        x = round(p(1)/p(3));
        y = round(p(2)/p(3));
        if x>0 && y>0 && x <= size(I_1,1) && y <= size(I_1,2)
            I_T(i,j,1) = I_1(x,y,1);
            I_T(i,j,2) = I_1(x,y,2);
            I_T(i,j,3) = I_1(x,y,3);
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
imshow(I_1);
title('Original Image')
subplot(2,2,4);
title('Target Image')
imshow(I_2);
title('Target Image')
figure(4);
imshow(I_T);











