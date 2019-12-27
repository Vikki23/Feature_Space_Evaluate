function [BBound, BDistance] = BhattacharyyaDistance3(X1,X2)
% BHATTACHARYYA  Bhattacharyya distance between two Gaussian classes
%
% d = bhattacharyya(X1,X2) returns the Bhattacharyya distance between X1 and X2.
%
% Inputs: X1 and X2 are n x m matrices represent two sets which have n
%         samples and m variables.
%
% Output: d is the Bhattacharyya distance between these two sets of data.
%
% Copyright: Chenying Liu (sysuliuchy@163.com) 
% Modifications
%  16-Vovember-2016

mu1=mean(X1);
sigma1=cov(X1);
if rank(sigma1)<size(sigma1,1)
    sigma1 = sigma1 + eye(size(sigma1))*10^(-10);
end
mu2=mean(X2);
sigma2=cov(X2);
if rank(sigma2)<size(sigma2,1)
    sigma2 = sigma2 + eye(size(sigma1))*10^(-10);
end

p1 = size(X1,1) / (size(X1,1)+size(X2,1));

BDistance = 1/8*(mu2-mu1)*inv((sigma1+sigma2)/2)*(mu2-mu1)'+1/2*log(det((sigma1+sigma2)/2)/sqrt(det(sigma1)*det(sigma2)));

Perror = sqrt(p1*(1-p1))*exp(-BDistance);
BBound = Perror;

% %Check inputs and output
% error(nargchk(2,2,nargin));
% error(nargoutchk(0,1,nargout));
% 
% [n,m]=size(X1);
% % check dimension 
% % assert(isequal(size(X2),[n m]),'Dimension of X1 and X2 mismatch.');
% assert(size(X2,2)==m,'Dimension of X1 and X2 mismatch.');
% 
% mu1=mean(X1);
% C1=cov(X1);
% mu2=mean(X2);
% C2=cov(X2);
% C=(C1+C2)/2;
% dmu=(mu1-mu2)/chol(C);
% try
%     d=0.125*dmu*dmu'+0.5*log(det(C/chol(C1*C2)));
% catch
%     d=0.125*dmu*dmu'+0.5*log(abs(det(C/sqrtm(C1*C2))));
%     warning('MATLAB:divideByZero','Data are almost linear dependent. The results may not be accurate.');
% end
% % d=0.125*dmu*dmu'+0.25*log(det((C1+C2)/2)^2/(det(C1)*det(C2)));
