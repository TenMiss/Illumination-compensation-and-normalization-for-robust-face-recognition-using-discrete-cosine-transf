clc;
clear all;
PsnNum = 10;
 
load YaleBImgSet1; 
TrImg = CroppedSetImg;   % The images in subset 1 are used for the training set.
clear CroppedSetImg;
load YaleBImgSet5;
TsImg = CroppedSetImg;   
clear CroppedSetImg;
TrImgNum = size(TrImg,3);
TrImgsPerClass = TrImgNum / PsnNum;
TsImgNum = size(TsImg,3);
TsImgsPerClass = TsImgNum / PsnNum;
NR = size(TrImg,1);
NC = size(TrImg,2);

ParaNum = 1;
ClipLimitTmp = 0;
NumTilesTmp = 0;
ClipIntvl = 0.04;
TileIntvl = 4;
for i = 1:ParaNum
    ClipLimit(i) = ClipLimitTmp + ClipIntvl; 
    ClipLimitTmp = ClipLimit(i);
    NumTiles(i,:) = [NumTilesTmp + TileIntvl NumTilesTmp + TileIntvl];
    NumTilesTmp = NumTiles(i,1);
end
ClipLimit = 1;
NumTiles = [8 8];
for pp = 1:ParaNum
pp

for m = 1:TrImgNum
  CorrImg = adapthisteq(TrImg(:,:,m),'NumTiles',NumTiles(pp,:),'ClipLimit',ClipLimit(1));
  TrCorrImgV(:,m) = double(reshape(CorrImg,NR*NC,1)); 
   TrCorrImgV(:,m) = (TrCorrImgV(:,m) - mean(TrCorrImgV(:,m)))/std(TrCorrImgV(:,m));
    %TrDCTLogFV(:,m) = dctcotrun(TrLogImg,1,53);   % DCT for dimensionality reduction
end
%  [P,U,Mn] = eigenpic(TrCorrImgV,0.9,20,0);    % For PCA        
%  TrDCTLogFV = P;
 TrDCTLogFV = TrCorrImgV;     % For correlation 


for m = 1:TsImgNum
    CorrImg = adapthisteq(TsImg(:,:,m),'NumTiles',NumTiles(pp,:),'ClipLimit',ClipLimit(1));
    imshow(CorrImg);    
    TsCorrImgV(:,m) = double(reshape(CorrImg,NR*NC,1));
    TsCorrImgV(:,m) = (TsCorrImgV(:,m) - mean(TsCorrImgV(:,m)))/std(TsCorrImgV(:,m));
    %MsTsImgs(:,m) = TsCorrImgV(:,m) - Mn;
    %TsDCTLogFV(:,m) = dctcotrun(TsLogImg,1,53);  % DCT for dimensionality reduction
end
%  TsPCA = U' * MsTsImgs;    % For PCA
%  TsDCTLogFV = TsPCA;
TsDCTLogFV = TsCorrImgV;   % For correlation

% Nearest Neighbor
NNErrNum = 0;
for i = 1:TsImgNum
    for j = 1:TrImgNum
        dist(j) = norm(TsDCTLogFV(:,i) - TrDCTLogFV(:,j));
        %dist(j) = 1 - TsDCTLogFV(:,i)' * TrDCTLogFV(:,j) / (norm(TsDCTLogFV(:,i)) * norm(TrDCTLogFV(:,j)));  % cosine similarity
    end
    [MinDist,MinInd] = min(dist);
    if fix((i - 1) / TsImgsPerClass) + 1 ~= fix((MinInd - 1) / TrImgsPerClass) + 1
        NNErrNum = NNErrNum + 1;
        NNErrInd(NNErrNum) = i;
    end
end
% for i = 1:NNErrNum
%     figure;
%     imshow(reshape(TsCorrImgV(:,i),NR,NC),[]);
% end
ErrNum(pp) = NNErrNum;

end

%save 'Subset3ErrNum_NumTiles' ErrNum ClipLimit NumTiles;

disp('done!');
    
