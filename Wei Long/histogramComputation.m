function Img_His = histogramComputation(Img)
% Computing histogram
% Wu Shiqian on 15 Dec 2011
[row,col,h]=size(Img);
if h > 1
    Img = rgb2gray(Img);
end
Img_His = zeros(1,256);
Img = double(Img(:))+1;
Imax = max(Img);
Imin = min(Img);
for j = Imin:Imax
    num = find(Img == j);
    Img_His(j) = length(num);
end
