%% Problem 1
modelCovMatrix = [47.917 0 -146.636 -141.572 -123.269;
0 408.250 68.487 69.828 53.479;
-146.636 68.487 2654.285 2621.672 2440.381;
-141.572 69.828 2621.672 2597.818 2435.368;
-123.269 53.479 2440.381 2435.368 2404.923];

target = im2double(imread('target.jpg'));
%%
% construct the candandidate covariance matrix
[r,c,co] = size(target);
mu = zeros(5,1);
% compute the mean
for y = 1:r
    for x = 1:c
        fk = [x,y,target(y,x,1),target(y,x,2),target(y,x,3)]';
        mu = mu + fk;
    end
end
mu = mu/(r*c);
%%
M = zeros(r,c,5); % each entry in M is fk-mu
for y = 1:r
    for x = 1:c
        fk = [x,y,target(y,x,1),target(y,x,2),target(y,x,3)]';
        M(y,x,:) = fk-mu;
    end
end

candidate = zeros(171,297,5,5);
for i = 1:171
    for j = 1:297
        C2 = zeros(5,5);
        for x = i:i+69
            for y = j:j+23
                C2 = C2+ reshape(M(x,y,:),[5,1])*reshape(M(x,y,:),[1,5]);
            end
        end
        C2 = C2/(70*24);
        candidate(i,j,:,:) = C2;
    end
end

ros = zeros(171,297);
for i = 1:171
    for j = 1:297
        C2 = reshape(candidate(i,j,:,:),[5,5]);
        ros(i,j) = rol(modelCovMatrix,C2);
    end
end
min = min(min(ros));
[x,y] = find(ros == min);
%%
imagesc(target(120:120+23,131:131+69,:));
%% helper functions
% compute the rol value for each box
% C1 is the model; C2 is the candidate
function result = rol(C1,C2)
    result = 0;
    lambda = eig(C1,C2);
    for i = 1:size(lambda)
        result = result + (log(lambda(i)))^2;
    end
        result = sqrt(result);
end

function [X] = circularNeighbors(img, x, y, radius)
    K = (floor(y+radius)-ceil(y-radius))*(floor(y+radius)-ceil(x-radius));
    for i = 1:K
        for r = ceil(y-radius):floor(y+radius)
            for c = ceil(x-radius):floor(y+radius)
                X(i,:) = [c,r,img(c,r,1),img(c,r,2),img(c,r,3)];
            end
        end
    end
end

function [w]=meanshiftWeights(X, q_model, p_test, bins)
    

end