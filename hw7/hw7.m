%% Problem 1
A = imread('touma.jpg');
[L, NumLabels] = superpixels(A, 1000,'Compactness',100);
figure
BW = boundarymask(L);
imshow(imoverlay(A,BW,'cyan'),'InitialMagnification',67)
outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for labelVal = 1:NumLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(A(redIdx));
    outputImage(greenIdx) = mean(A(greenIdx));
    outputImage(blueIdx) = mean(A(blueIdx));
end    

figure
imshow(outputImage,'InitialMagnification',67)

%% Problem 2
% load the image
template = im2double(imread('template.png'));
search = im2double(imread('search.png'));

% set up the score matrix
[r,c,l] = size(search);
scores = zeros(r,c,l);

% compute mean and standard deviation for each channel of template
meanT = computeMean(template);
stdT = computeStd(template);
%% compute the NCC score 
for i = 1:3
    for r = 24:277
        for c = 35:366
            
            P = search(r-23:r+23,c-34:c+34,:);
            T = template;
            meanP = computeMean(P);
            stdP = computeStd(P);
            val = 0;
            for x = 1:47
                for y = 1:69
                    val = val+ ((P(x,y,i)-meanP(i))*(T(x,y,i)-meanT(i))/(stdP(i)*stdT(i)));
                end
            end
            val = val/(47*69-1);
            scores(r,c,i) = val;
            
        end
    end
end
%% best match
scores = mean(scores,3);
k1 = max(max(scores));
[a,b] = find(scores ==k1);
imagesc(search(a-23:a+23,b-34:b+34,:));
%% plot the NCC scores
ls = reshape(scores,1,[]);
ls = sort(ls,'descend');
plot(ls,'-r');
xlabel('k');
ylabel('NCC');
%%
[a,b]= find(scores == ls(400));
imagesc(search(a-23:a+23,b-34:b+34,:));

%% helper function
% compute the mean of each channel in the image
function result = computeMean(image)
    meanR = mean(image(:,:,1),'all');
    meanG = mean(image(:,:,2),'all');
    meanB = mean(image(:,:,3),'all');
    result = [meanR,meanG,meanB];
end

function result = computeStd(image)
    stdR = std(image(:,:,1),0,'all');
    stdG = std(image(:,:,2),0,'all');
    stdB = std(image(:,:,3),0,'all');
    result = [stdR,stdG,stdB];
end
