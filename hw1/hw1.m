%% Problem 1
grayIm = imread('buckeyes_gray.bmp');
imagesc(grayIm);
axis('image');
%colormap('gray');
imwrite(grayIm,'buckeyes_gray.jpg');
pause;

rgbIm = imread('buckeyes_rgb.bmp');
imagesc(rgbIm);
axis('image');
imwrite(rgbIm,'buckeyes_rgb.jpg');

%% Problem 2
grayIm2 = rgb2gray(rgbIm);
imagesc(grayIm2);
axis('image')
if (isequal(grayIm,grayIm2))
    fprintf("same matrix value as in previous grayscaled image by converting\n");
else
    fprintf("not same matrix value as in previous grayscaled image by converting\n");
end

%% Problem 3
zBlock = zeros(10,10);
oBlock = ones(10,10)*255;
pattern = [zBlock oBlock; oBlock zBlock];
checkerIm = repmat(pattern,5,5);
imwrite(uint8(checkerIm),'checkerIm.bmp');
Im = imread('checkerIm.bmp');
imagesc(Im);
colormap('gray');