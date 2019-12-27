%% Demo_PCA_FisherRatio_2classes: Get Fisher ratio between two classes
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

% within each class the class size of which is bigger than 300, 
% calculate FR using 300 samples
nsamples = 300;
nclassleft = 0;
for i = 1:no_class
    if TotalSamNumAClass(i)>nsamples
        nclassleft = nclassleft + 1;
        ind = find(trainall(:,2)==i);
        selectIndPerClass = randperm(TotalSamNumAClass(i),nsamples);
        indleft(:,nclassleft) = trainall(ind(selectIndPerClass),1);
        samAClass(:,:,nclassleft) = PriCom(indleft(:,nclassleft),:);
    end
end

for i = 1:nclassleft
    for j = i+1:nclassleft
        TestData.X = [samAClass(:,:,i)' samAClass(:,:,j)'];
        TestData.y = [ones(1,nsamples) ones(1,nsamples)+1];
        
        model = fld(TestData);
        
        FiRatio(i,j) = model.separab;
    end
end