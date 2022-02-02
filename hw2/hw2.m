%% Problem 1
clear;
clc;
sigma=2; % use different values
G = fspecial('gaussian', 2*ceil(3*sigma)+1, sigma);
faceIm=double(imread('harry.png'));
gIm = imfilter(faceIm, G, 'replicate');
imshow(gIm/255); % double images need range of 0-1
imwrite(uint8(gIm), 'gIm.bmp');

%% Problem 2
clc;
clear;
sigma = 3;

[Gx,Gy] = gaussDeriv2D(sigma);
[X,Y] = meshgrid(-ceil(3*sigma):ceil(3*sigma));
surf(X,Y,Gx);
xlabel('x'); 
ylabel('y');
title('Gx');
pause();

surf(X,Y,Gy);
xlabel('x');
ylabel('y');
title('Gy');




%% Problem 3
clear;
clc;
sigma = 3; 
[Gx,Gy] = gaussDeriv2D(sigma);
I = im2double(imread('touma.jpg'));
imshow(I);
pause;
gxIm = imfilter(I, Gx, 'replicate');
gyIm = imfilter(I ,Gy, 'replicate');
magIm = sqrt(gxIm.^2 + gyIm.^2);
imagesc(gxIm);
pause;
imagesc(gyIm);
pause;
imagesc(magIm);

%% Problem 4
T = 2;
tIm = magIm > T;
imagesc(tIm);

%% Problem 5
T = 0.002;
Fx = -fspecial('sobel')';
fxIm = imfilter(I,Fx);
Fy = -fspecial('sobel');
fyIm = imfilter(I,Fy);
magIm = sqrt(fxIm.^2 + fyIm.^2);
tIm = magIm > T;
imagesc(tIm);

%% Problem 6
grayI = rgb2gray(I);
edge(grayI,'canny');

function [Gx, Gy] = gaussDeriv2D(sigma)
    % this function samples 3 std from the Gaussian
    Gx = ones(2*ceil(3*sigma) + 1,2*ceil(3*sigma) + 1); % mask size
    Gy = ones(2*ceil(3*sigma) + 1,2*ceil(3*sigma) + 1); % mask size
    range = [-ceil(3*sigma): ceil(3*sigma)];
    for x = 1:2*ceil(3*sigma)+1
        for y = 1:2*ceil(3*sigma)+1
            Gx(x,y) = range(y)*exp(-(range(x)^2+range(y)^2)/(2*sigma^2))/(2*pi*sigma^4);
            Gy(x,y) = range(x)*exp(-(range(x)^2+range(y)^2)/(2*sigma^2))/(2*pi*sigma^4);
        end
    end
end