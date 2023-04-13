function Y = DCT_normalization(X,numb, normalize)
% The function applies the DCT-based algorithm to normalize an image.
% INPUTS:
% X            - a grey-scale image of arbitrary size
% numb         - a scalar value determining the number of DCT
%                coefficients to set to zero, default "numb=50"
% normalize    - a parameter controlling the post-processing
%                         procedure:
%                         0 - no normalization
%                         1 - perform basic normalization (truncation 
%                            of histograms ends and normalization to the 
%                            8-bit interval) - default 
%
% OUTPUTS:
% Y            - a grey-scale image processed with the DCT-based
%               normalization technique
%                         
% Institute for Infocomm Research
% Wu shiqian
% Parameter checking
Y=[];%dummy
if nargin == 1
    numb = 50;
    normalize = 1;
elseif nargin == 2
    if isempty(numb)
        numb = 50;
    end
    normalize = 1;
elseif nargin == 3
    if isempty(numb)
        numb = 50;
    end
    
    if ~(normalize==1 || normalize==0)
        disp('Error: The third parameter can only be 0 or 1.');
        return;
     end
elseif nargin > 3
    disp('Eror: Wrong number of input parameters.')
    return;
end
%% Init. operations
X = normalize8(X);
[a,b]=size(X);
M=a;
N=b;
coors = zigzag(X);
%% Transform to logarithm and frequency domains
X=log(X+1);
X=normalize8(X);
means= mean(X(:))+10; %chose a mean near the true mean (the value +10 can be changed)
Dc = dct2(X); 

%% apply the normalization
c_11=log(means)*sqrt(M*N);
Dc(1,1)=c_11;
for i=2:numb+1
    ky = coors(1,i);
    kx = coors(2,i);
    Dc(ky,kx) = 0;
end
Y=(idct2(Dc));


%% Do some post-processing (or not)
if normalize ~=0
    Y=normalize8(histtruncate(normalize8(Y),0.2,0.2));
end
