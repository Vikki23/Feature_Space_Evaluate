%% Demo_PCA_GetOverallErrProb: Get error bound of the features with PCA
% If you use this demo, please cite these references: 
%  [1] C. Liu, L. He, Z. Li and J. Li, 
%     "Feature-Driven Active Learning for Hyperspectral Image Classification," 
%     in IEEE Transactions on Geoscience and Remote Sensing, 
%     vol. 56, no. 1, pp. 341-354, Jan. 2018.
%
%  [2] L. He, J. Li, A. Plaza and Y. Li,
%      "Discriminative Low-Rank Gabor Filtering for Spectral¨CSpatial 
%       Hyperspectral Image Classification",
%       IEEE Transactions on Geoscience and Remote Sensing, 
%       vol. 55, no. 3, pp. 1381-1395, March 2017.
%
% authors: Chenying Liu (sysuliuchy@163.com)
%          Jun Li (lijun48@mail.sysu.edu.cn)
%          Lin He (helin@scut.edu.cn)
%%

clear all
close all
clc

numOfPCA = 30;

load Indian_pines_corrected_pca
PriCom(:,numOfPCA+1:end) = [];
load Indian_pines_gt
no_class = max(indian_pines_gt(:));
trainall = [];
for i = 1:no_class
    ac_ind = find(indian_pines_gt(:)==i);
    ac_label = ones(size(ac_ind))*i;
    trainall = [trainall;[ac_ind,ac_label]];
    TotalSamNumAClass(i) = length(ac_ind);
end
    
%%
ClassNum = 0;
for i = 1:16
    if TotalSamNumAClass(i)>300
        ClassNum = ClassNum + 1;
        ind{ClassNum} = find(trainall(:,2)==i);
        samAClass{ClassNum} = PriCom(ind{ClassNum},:); 
    end
end

for ClassIdx1 = 1:ClassNum
    TempPriCom1 = samAClass{ClassIdx1};
    SamNum1 = size(TempPriCom1,1);
    for ClassIdx2 = 1:ClassNum
        if ClassIdx1==ClassIdx2
            TempBDValue(ClassIdx1, ClassIdx2) = 0;
            TempBDBound(ClassIdx1, ClassIdx2) = 0;
            ProbTwoClass(ClassIdx1,ClassIdx2) = 0;
        else
            TempPriCom2 = samAClass{ClassIdx2};
            SamNum2 = size(TempPriCom2,1);
            [TempBDBound(ClassIdx1, ClassIdx2), TempBDValue(ClassIdx1, ClassIdx2)] = ...
                BhattacharyyaDistance3(TempPriCom1,TempPriCom2);
            ProbTwoClass(ClassIdx1,ClassIdx2) = SamNum1*SamNum2;
        end
        ClassIdx1
        ClassIdx2
    end
end
ProbTwoClass = ProbTwoClass/sum(sum(ProbTwoClass));