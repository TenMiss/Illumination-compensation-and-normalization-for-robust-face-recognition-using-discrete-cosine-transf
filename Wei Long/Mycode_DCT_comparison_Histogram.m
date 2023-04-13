clc;clear all;
close all;
[filename, pathname] = uigetfile({'*.*','All Files (*.*)'}, 'Open images');
if isequal([filename,pathname],[0,0])
    return
end
dir_struct = dir(pathname);
%%% (1)name, (2)date, (3)bytes and (4) isdir
[sorted_names,sorted_index]=sortrows({dir_struct.name}');
thumbs_file = fullfile(pathname,'Thumbs.db');
delete(thumbs_file)
a=[dir_struct.isdir];
a(1:2)=[];             %%% Delete the dot dir
sorted_names(1:2)=[]; 
[n,m]=size(sorted_names);
%%
for i=10:n
    select_file = fullfile(pathname,sorted_names{i})
    I = imread(select_file); %figure,imshow(I);
    [rr,cc,color] = size(I);
    % =====================HE in YUV =======================
    R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
    Y = 0.299*double(R)+ 0.587*double(G) + 0.114*double(B);
    U = -0.147*double(R)-0.289*double(G)+0.436*double(B);
    V = 0.615*double(R)-0.515*double(G)-0.1*double(B);
    %================================ histogram equalization
    Y2 = double(histeq(uint8(Y)));
    figure,imhist(uint8(Y2)); title('hist')
    R=Y2+1.14*V;
    G=Y2-0.39*U-0.58*V;
    B=Y2+2.03*U;
    Iyuv = cat(3,uint8(R),uint8(G),uint8(B));
    out_name =['D:\My recent work\Image enhancement\myCode\my DCT normalization\results\' 'Eq_' sorted_names{i}];
    imwrite(Iyuv, out_name);
    figure,imshow(Iyuv); title('Processed by histogram equalization')
    % ================================== adaptive histogram equalization
    Y2 = double(adapthisteq(uint8(Y)));
    figure,imhist(uint8(Y2)); title('hist')
    R=Y2+1.14*V;
    G=Y2-0.39*U-0.58*V;
    B=Y2+2.03*U;
    IyuvAdp = cat(3,uint8(R),uint8(G),uint8(B));
    figure,imshow(IyuvAdp); title('Processed by adaptive histogram equalization')
    out_name =['D:\My recent work\Image enhancement\myCode\my DCT normalization\results\' 'AdpEq_' sorted_names{i}];
    imwrite(IyuvAdp, out_name);
    %====================== DCT
    if color == 3
        R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
        Y = 0.299*double(R)+ 0.587*double(G) + 0.114*double(B);
        U = -0.147*double(R)-0.289*double(G)+0.436*double(B);
        V = 0.615*double(R)-0.515*double(G)-0.1*double(B);
        R3 = DCT_normalization(uint8(Y));
        %figure,imhist(uint8(R3));title('DCT')        
        R = (R3+1.14*V);
        G = (R3-0.39*U-0.58*V);
        B = (R3+2.03*U);
        img2 = cat(3,uint8(R),uint8(G),uint8(B));
        figure,imshow(img2); title('DCT without normalize8')
        img3 = cat(3,uint8(normalize8(R)),uint8(normalize8(G)),uint8(normalize8(B)));
        figure,imshow(img3); title('DCT with normalize8')
        out_name =['D:\My recent work\Image enhancement\myCode\my DCT normalization\results\' 'DCT_' sorted_names{i}];
        imwrite(img3, out_name);
    else
        numb = 50;
        coors = do_zigzag(I);
        % Transform to logarithm and frequency domains
        Y=log(double(I)+1);
        Y=normalize8(Y);
        means= mean(Y(:))+10; %we chose a mean near the true mean (the value +10 can be changed)
        Dc = dct2(Y); 
        c_11=log(means)*sqrt(rr*cc);
        Dc(1,1)=c_11;
        for j=2:numb+1
            ky = coors(1,j);
            kx = coors(2,j);
            Dc(ky,kx) = 0;
        end
        Y1=(idct2(Dc));
        minmax_DCT1 = [min(Y1(:)),max(Y1(:))]
        Y11 = normalize8(Y1);
        figure,imshow(uint8(Y11)); title('DCT with normalize8')
        out_name =['D:\My recent work\Image enhancement\myCode\my DCT normalization\results\' 'DCT_' sorted_names{i}];
        imwrite(img3, out_name);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %keyboard
   close all
end


