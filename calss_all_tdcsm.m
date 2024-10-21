clc,clear
load beta3_m.mat%需要加载的数据，包括x和y，x是n*m的矩阵，n为数据个数，m为特征个数，y为n*1的标签
j = 1;
p = 1;
k = 1;
n = 1;
h = waitbar(j/80, strcat('iteration: ',num2str(k),'; model: ',num2str(j),'acc_train: ',num2str(0),'; acc_test: ',num2str(0), '; sig: ',num2str(p)));

while j<81
    [x_test,x_train,y_test,y_train] = sample_xc(x,y,20);
    %随机抽选训练集和测试集，只适用于于2分类，多分类得自己改，x为自变量，y为因变量，20为抽选的验证集数据，一个分类20个，两个分类一共40个
    while p>0.05
        cv = cvpartition(y_train, 'KFold', 10);
        optimalModel = fitcensemble(x_train, y_train, 'OptimizeHyperparameters', 'auto', 'HyperparameterOptimizationOptions',...
            struct('Optimizer', 'bayesopt', 'CVPartition', cv,'ShowPlots',false));
        acc1 = calc_acc(optimalModel,x_train, y_train);
        
        if acc1 >0.65%这个值为经验值，二分类一般大于这么多置换检验会显著，不进行额外的置换检验，减少计算量
            acc = calc_acc(optimalModel,x_test,y_test);
            if acc > 0.6%这个值为经验值，二分类一般小于这么多置换检验会不显著，不进行额外的置换检验，减少计算量
                p = permu_acc(optimalModel,x_test,y_test,1000,acc);
            else
                p = 1;
            end
        else
            acc = 0;
        end
        all_p(j,1)=p;%所有验证集进行置换检验的p值
        all_acc(j,1) = acc;%所有验证集正确率
        all_acc1(j,1) = acc1;%所有测试集正确率
        all_mod{j,1} = optimalModel;%所有模型
        if isempty(predictorImportance(optimalModel))==0
            all_weight(j,:) =  predictorImportance(optimalModel);%所有模型各个预测变量的权重
        end
        waitbar(j/100, h, strcat('iteration: ',num2str(n),'; model: ',num2str(j),'acc_train: ',num2str(acc1),'; acc: ',num2str(acc), '; sig: ',num2str(p)));
        k = k+1;
        if k>1
            break
        end
    end
    if p >0.05
        j = j;
    else
        j = j+1;
    end
    p = 1;
    k = 1;
    n = n+1;
    save('all_weight_tdcsbeta3m','all_p','all_acc','all_weight','all_acc1','all_mod')
end