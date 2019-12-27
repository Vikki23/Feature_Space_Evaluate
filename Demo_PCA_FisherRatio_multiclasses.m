%% Demo_PCA_FisherRatio_multiclasses: Get Fisher ratio among all the classes
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
samAllClass = [];
labels = [];
for i = 1:no_class
    if TotalSamNumAClass(i)>nsamples
        nclassleft = nclassleft + 1;
        ind{nclassleft} = find(trainall(:,2)==i);
        selectIndPerClass = randperm(TotalSamNumAClass(i),nsamples);
        indleft(:,nclassleft) = trainall(ind{nclassleft}(selectIndPerClass),1);
        samAllClass = [samAllClass;PriCom(indleft(:,nclassleft),:)];
        labels = [labels;zeros(nsamples,1)+nclassleft]; 
    end
end

FDL_r = fLDA_FisherRatio_NClasses(samAllClass,labels,nclassleft);