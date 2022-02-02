%% Problem 1

%load the image
toumaRGB = im2double(imread("touma.jpg"));
toumaGray = rgb2gray(toumaRGB);

% resize the image from 319 * 567 to 313*567 // (8*39+1)(8*70+1)
touma = toumaGray(1:313,1:561);
imshow(touma);  %original image
pause();
% define the 1-d gaussion mask
a = 0.4;
w = [0.25-0.5*a,0.25,a,0.25,.25-0.5*a];

b1 = blur(touma,w);
b11 = subSample(b1);
imshow(b11); % 1st blur and sample
pause();

b2 = blur(b11,w);
b22 = subSample(b2);
imshow(b22); % 2nd blur and sample
pause();

b3 = blur(b22,w);
b33 = subSample(b3); % 3rd blur and sample
imshow(b33);

%% get the error pyramid
b33copy = b33;
ip3 = interpolate(b33);
imshow(ip3);
pause();
e33 = b22 - ip3;
imshow(e33);
pause();

ip2 = interpolate(b22);
imshow(ip2);
pause();

e22 = b11 - ip2;
imshow(e22);
pause();

ip1 = interpolate(b11);
imshow(ip1);
pause();
e11 = touma - ip1;
imshow(e11);
%% recover the image using b33copy,e11,e22,e33
imshow(b33);
pause();
i1 = interpolate(b33copy);
imshow(i1);
pause();

imshow(i1+e33);
pause();
i2 = interpolate(i1+e33);
imshow(i2);
pause();

imshow(i2+e22);
pause();
i3 = interpolate(i2+e22);
imshow(i3);
pause();

origin = i3+e11;
imshow(origin);

%% Problem 2

%load the object image and background image
object = im2double(imread('walk.bmp'));
background = im2double(imread('bg000.bmp'));

[r,c] = size(object);
result = zeros(r,c);

T = 0.5216; % change this value for experiment
for i = 1:r
    for j = 1:c
        if abs(background(i,j)-object(i,j)) > T
            result(i,j) = 1;
        end
    end
end
imshow(result);

%% Problem 3

% load all the images
for i = 1:30
    filename = sprintf('bg%03d.bmp',i-1);
    Im(:,:,i) = im2double(imread(filename));
end
% load the object image
object = im2double(imread('walk.bmp'));
% calculate the mean and std of 30 background images
[r,c] = size(Im(:,:,1));
mu = mean(Im,3);
sigma = std(Im,0,3);

% extract the image
T = 40;
result = zeros(r,c);
for i = 1:r
    for j = 1:c
        if ((object(i,j) - mu(i,j))/sigma(i,j))^2 > T^2
            result(i,j) = 1;
        end
    end
end
imshow(result);

%% Problem 4
d_bsIm = bwmorph(result, 'dilate');
imshow(d_bsIm);

%% Problem 5
[L, num] = bwlabel(d_bsIm, 8);
% counting and find the largest region index
max = 1;
for i = 1:12
    if sum(L(:) == i) > sum(L(:)== max)
        max = i;
    end
end
[r,c] = size(L);
for i = 1:r
    for j = 1:c
        if L(i,j)~= max
            L(i,j) = 0;
        end
    end
end
imshow(L);
%%
function bluredIm = blur(image,w)
    bluredIm = image;
    [r,c] = size(image);
    % blur the rows
    for i = 1:r
        for j = 3:c-2
            bluredIm(i,j) = dot(image(i,j-2:j+2),w);
        end
    end
    % blur the columns
    for i = 3:r-2
        for j = 1:c
            bluredIm(i,j) = dot(image(i-2:i+2,j),w);
        end
    end
end

function subIm = subSample(image)
    [r,c] = size(image);
    subIm = ones(ceil(r/2),ceil(c/2));
    for i = 1:r/2+1
        for j = 1:c/2+1
            subIm(i,j) = image(2*i-1,2*j-1);
        end
    end
end

function result = interpolate(image)
    [r,c] = size(image);
    result = ones(2*r-1,2*c-1);
    for i = 1:r
        for j = 1: c
            result(2*i-1,2*j-1) = image(i,j);
        end
    end
end

