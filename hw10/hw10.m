%% Problem 1
iml = imread('left.png');
imr = imread('right.png');


%% Problem 2 K = 1
X = readmatrix('train.txt');
Y = readmatrix('test.txt');
Idx = knnsearch(X(:,1:2),Y(:,1:2),'K',1,'Distance','euclidean');
predict = X(Idx,:);
[id,acc] = accuracy(predict(:,3),Y(:,3));
acc
Ywrong = Y(id,:);
hold on
plot(Ywrong(:,1),Ywrong(:,2),'ko');

% points in test.txt with predicted label
Z = [Y(:,1:2),predict(:,3)];
x1 = Z(:,1);
x2 = Z(:,2);
class = Z(:,3);

plot(x1(class == 1),x2(class == 1),'r.');
plot(x1(class == 2),x2(class == 2),'b.');
hold off;
%% Problem 2 K = 5
K = 16;
X = readmatrix('train.txt');
Y = readmatrix('test.txt');
Idx = knnsearch(X(:,1:2),Y(:,1:2),'K',K,'Distance','euclidean');
nb = [];
for i = 1:3000
    nb = [nb;X(Idx(i,:),:)];
end

label = zeros(3000,1);
for i = 1:3000
    label(i) = vote(nb(K*(i-1)+1:K*i,3),K);
end
[id,acc] = accuracy(label,Y(:,3));
acc
Z = [Y(:,1:2),label];
x1 = Z(:,1);
x2 = Z(:,2);
class = Z(:,3);

Ywrong = Y(id,:);
hold on
plot(Ywrong(:,1),Ywrong(:,2),'ko');
plot(x1(class == 1),x2(class == 1),'r.');
plot(x1(class == 2),x2(class == 2),'b.');
hold off

%%
f(-5)
function result = f(x)
    result = x^3+3*x^2-8*x+10;
end

%% helper functions
% return the label from the vote
function result = vote(A,K)
    num1 = 0;
    num2 = 0;
    result = 2;
    for i = 1:K
        if A(i) == 1
            num1 = num1 + 1;
        else
            num2 = num2 + 1;
        end
    end
    if num1 > num2
        result = 1;
    end
end




function [id,acc] = accuracy(A,B)
    num = 0;
    id = [];
    for i = 1: 3000
        if A(i) == B(i)
            num = num + 1;
        else
            id = [id;i];
        end
    end
    acc = num/3000;
    
end