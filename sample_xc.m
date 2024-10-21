function [x_test,x_train,y_test,y_train] = sample_xc(x,y,time)
if length(find(y==1))>length(find(y==2))
    y_1 = find(y==1);
    y_2 = find(y==2);
else
    y_1 = find(y==2);
    y_2 = find(y==1);
end
y_1loc = randperm(numel(y_1));
y_1loc = y_1loc(1:size(y_2,1));
y_1train = y(y_1(y_1loc,:),:);
x_1train = x(y_1(y_1loc,:),:);
y1_ex = randi([1, size(y_1train,1)], 1, time);
y_1test = y_1train(y1_ex,:);
x_1test = x_1train(y1_ex,:);
y_1train(y1_ex,:) = [];
x_1train(y1_ex,:) = [];
y_2loc = randperm(numel(y_2));
y_2loc = y_2loc(1:size(y_2,1));
y_2train = y(y_2(y_2loc,:),:);
x_2train = x(y_2(y_2loc,:),:);
y2_ex = randi([1, size(y_2train,1)], 1, time);
y_2test = y_2train(y2_ex,:);
x_2test = x_2train(y2_ex,:);
y_2train(y2_ex,:) = [];
x_2train(y2_ex,:) = [];
x_test = [x_1test;x_2test];
y_test = [y_1test;y_2test];
x_train = [x_1train;x_2train];
y_train = [y_1train;y_2train];
end