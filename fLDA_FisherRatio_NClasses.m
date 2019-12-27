function [varargout] = fLDA_FisherRatio_NClasses(varargin)
% LDA (Fisher)Linear Discriminant Analysis
% calculate the criterion ！！ FisherRatio(N classes in total)
%
% Synopsis:
%  [varargout] = fLDA_FisherRatio_NClasses(varargin)
%
% Description:
%  This function computes the fisher ratio based
%  on the(Fisher)Linear Discriminant Analysis.
%
% Inputs:
%  img             ！！ Dataset.
%                      [num_data x dim] 
%  label           ！！ Labels.
%                      [num_data x 1] 
%  nclass          ！！ Number of classes.
%                      [1 x 1] 
%
% Outputs:
%  FLD_Results     ！！ Fisher Linear Discrimination Analysis Results
%                      .Sb [dim x dim] Between-class scatter matrix.
%                      .Sw [dim x dim] Within-class scatter matrix.
%                      .W [dim x 1] Projection matrix.
%                      .FiRatio [1x1] Measure of fisher ratio.
%
%  Copyright: Chenying Liu (sysuliuchy@163.com) 
%
% Modifications
%  16-Vovember-2016

% inputs
%-------------------------------
img = varargin{1};
dim = size(img,2);

label = varargin{2};

nclass = varargin{3};

% sort the samples and compute means by class
%-------------------------------
for i = 1:nclass
    ind{i} = find(label == i);
    u(i,:) = mean(img(ind{i},:));
end

% compute the mean of all samples
%-------------------------------
U = mean(img);

% compute Sb and Sw
%-------------------------------
Sb = zeros(dim);
Sw = zeros(dim);
for i = 1:nclass
    Sb = Sb + size(ind{i},1)*(u(i,:)-U)'*(u(i,:)-U);
    Swc = ((ones(size(ind{i},1),1)*u(i,:)-img(ind{i},:))'*(ones(size(ind{i},1),1)*u(i,:)-img(ind{i},:)));
%     Swc = [];
%     for j = 1:size(ind{i},1)
%        Swc =  (u(i,:)-img(ind{i}(j),:))'*(u(i,:)-img(ind{i}(j),:));
%     end
    Sw = Sw + Swc;
end

% compute W
%-------------------------------
rb = rank(Sb);
rw = rank(Sw);
r = min(rb,rw);
if r == nclass
    r = r-1;
end

[W,D] = eig(inv(Sw)*Sb);
W = W(:,1:r);
% compute Fisher Ratio
%-------------------------------
FiRatio = det(W'*Sb*W)/det(W'*Sw*W);
% FiRatio = abs(FiRatio);

% outputs
%-------------------------------
FLD_Results.Sw = Sw;
FLD_Results.Sb = Sb;
FLD_Results.W = W;
FLD_Results.FiRatio = FiRatio;

varargout(1) = {FLD_Results};
