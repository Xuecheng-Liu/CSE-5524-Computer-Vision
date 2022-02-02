%% Problem 1
% load the imagee
im1 = im2double(imread('boxIm1.bmp'));
im2 = im2double(imread('boxIm2.bmp'));
im3 = im2double(imread('boxIm3.bmp'));
im4 = im2double(imread('boxIm4.bmp'));

Nval1 = similitudeMoment(im1);
Nval2 = similitudeMoment(im2);
Nval3 = similitudeMoment(im3);
Nval4 = similitudeMoment(im4);

%% Problem 2
% Load the data
clear; close all;
load eigdata.txt;
X = eigdata;
subplot(2,1,1);
plot(X(:,1),X(:,2),'b.');
axis('equal');
%% mean-subtract data
m = mean(X);
Y = X - ones(size(X,1),1)*m;
subplot(2,1,2);
plot(Y(:,1),Y(:,2),'r.');
axis('equal');
%% Problem 3
K = cov(Y);
[Q,S] = eig(K);
figure
hold on
plot(Y(:,1),Y(:,2),'y.');
plot([-3*sqrt(S(1,1))*Q(1,1),3*sqrt(S(1,1))*Q(1,1)],[-3*sqrt(S(1,1))*Q(2,1),3*sqrt(S(1,1))*Q(2,1)],'r');
plot([-3*sqrt(S(2,2))*Q(1,2),3*sqrt(S(2,2))*Q(1,2)],[-3*sqrt(S(2,2))*Q(2,2),3*sqrt(S(2,2))*Q(2,2)],'b');

hold off
axis equal

%% Problem 4
H = Y*Q;
plot(H(:,1),H(:,2),'r.');
axis equal;
%% Problem 5
Z = H(:,2);
histogram(Z);
%% helper functions
% normalize each value between 0 and 1
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
