%% Problem 1
% load images
for i = 1:22
    filename = sprintf('aerobic-%03d.bmp',i);
    Im(:,:,i) = im2double(imread(filename));
    Imf(:,:,i) = medfilt2(Im(:,:,i)); % median filter the image
end

% get size of each image
[r,c]=size(Imf(:,:,1));
result = zeros(r,c,21);
T = grayththresh(Imf(:,:,1));

% iterate over 22 images to do background abs substruction
for i = 2:22
    for x = 1:r
        for y = 1:c
            if abs(Imf(x,y,i-1) - Imf(x,y,i)) >= T
                result(x,y,i-1) = 1;
            end
        end
         
    end
end

for i = 1:21
    imshow(result(:,:,i));
    pause();
end
%% Problem 2
MEI = zeros(r,c);
for i = 1:21
    for x = 1:r
        for y = 1:c
            if result(x,y,i) == 1
                MEI(x,y) = 1;
            end
        end
    end
end
imagesc(MEI);

MHI = zeros(r,c);
for i = 1:21
    for x = 1:r
        for y = 1:c
            if result(x,y,i) ~=0
                MHI(x,y) = i;
            else
                MHI(x,y) = MHI(x,y)-1;
            end
        end
    end
end
imagesc(MHI);
%% compute 7 similitude for each image
MEIN = norm(MEI);
Nval1 = similitudeMoment(MEIN);
disp(Nval1);

MHIN = norm(MHI);
Nvals2 = similitudeMoment(MHIN);
disp(Nvals2);
%% Problem 3

% create the image
im1 = zeros(101,101);
im2 = zeros(101,101);

for i = 40:61
    for j = 6:27
        im1(i,j) = 1;
        im2(i+1,j+1) = 1;
    end
end
imagesc(im1);
pause();
imagesc(im2);

%%

fx = edge(im2,'sobel','horizontal')/8;
fy = edge(im2,'sobel','vertical')/8;
ft = im2 - im1;


u = fx./sqrt(fx.^2+fy.^2);
v = fy./sqrt(fx.^2+fy.^2);
mag = -ft./sqrt(fx.^2+fy.^2);
imagesc(im1);
hold on
quiver(v,u);
axis equal;
%% helper function from hw4
function result = norm(A)
    minVal = min(min(A));
    maxVal = max(max(A));
    result = (A - minVal)./(maxVal - minVal);
end

function Nvals = similitudeMoment(boxIm)
    boxIm = norm(boxIm);
    Nvals = zeros(1,7);
    
    % compute xbar and y bar
    xbar = 0;
    ybar = 0;
    [x,y] = size(boxIm);
    for r = 1:x
        for c = 1:y
            xbar = xbar + boxIm(r,c)*c;
            ybar = ybar + boxIm(r,c)*r;
        end
    end
    
    
    m00 = sum(sum(boxIm));
    xbar = xbar/m00;
    ybar = ybar/m00;
    
    
    for r = 1:x
       for c = 1:y
           Nvals(1) = Nvals(1) + ((c-xbar)^0*(r-ybar)^2*boxIm(r,c)/(m00^2));
           Nvals(2) = Nvals(2) + ((c-xbar)^0*(r-ybar)^3*boxIm(r,c)/(m00^2.5));
           Nvals(3) = Nvals(3) + ((c-xbar)^1*(r-ybar)^1*boxIm(r,c)/(m00^2));
           Nvals(4) = Nvals(4) + ((c-xbar)^1*(r-ybar)^2*boxIm(r,c)/(m00^2.5));
           Nvals(5) = Nvals(5) + ((c-xbar)^2*(r-ybar)^0*boxIm(r,c)/(m00^2));
           Nvals(6) = Nvals(6) + ((c-xbar)^2*(r-ybar)^1*boxIm(r,c)/(m00^2.5));
           Nvals(7) = Nvals(7) + ((c-xbar)^3*(r-ybar)^0*boxIm(r,c)/(m00^2.5));
            
       end
    end

end