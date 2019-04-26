clear all; clc; close all;
A = imread('Original images/Original_Image.jpg');
I0 = rgb2gray(A);

fa=20; fb=80;
ga=50; gb=230;
I = LinearEnhance(I0,fa,fb,ga,gb);
figure;
imshow(I);
print LinearEnhanced_GrayImage -dpng

se = strel('disk',20);
background = imopen(I,se);
I2 = I - background;
% figure;imshow(I2)
I3 = LinearEnhance(I2,fa,fb,ga,gb);
bw = imbinarize(I3,0.15);
bw = bwareaopen(bw,50);
imshow(bw);
print Completed_Binary -dpng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cc = bwconncomp(bw,8);
[~,idx] = size(cc.PixelIdxList);
worm = false(size(bw));
idmax = 0;
for l=1:idx
    [idm,~] = size(cc.PixelIdxList{l});
    if idm > idmax
        idmax = idm;
    end
    for i=1:idm
        j = cc.PixelIdxList{l}(i);
        worm(j) = true;
    end
    % wrom(cc.PixelIdxList{20}) = true;
    imshow(worm);
%     pause(1);
end

labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label);
print Colored_Segments -dpng

wormdata = regionprops(cc,'basic');
worm_areas = [wormdata.Area];
[min_area, idxmin] = min(worm_areas);
[max_area, idxmax] = max(worm_areas);

figure;histogram(worm_areas,100);
W = zeros(idmax,idx);w = 1;j = 0;
for i=1:idx
    [idm,~] = size(cc.PixelIdxList{i});
    if worm_areas(i) >= 300
        W(1:idm,w) = cc.PixelIdxList{i};
        w = w+1;
    else
        j = j+1;
        W = W(:,1:idx-j);
    end
end
worm = false(size(bw));figure;
for l=1:idx-j
    for i=1:idmax
        j = W(i,l);
        if j > 0
            worm(j) = true;
        end
    end
    % wrom(cc.PixelIdxList{20}) = true;
    imshow(worm);
%     pause(1);
end
print Reduced_Small_Areas -dpng

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dst_img = LinearEnhance(ori_img,fa,fb,ga,gb)
[height,width] = size(ori_img);  
dst_img = uint8(zeros(height,width));  
ori_img = double(ori_img);
m = min(min(ori_img));
k1 = ga/fa;   
k2 = (gb-ga)/(fb-fa);  
k3 = (255-gb)/(255-fb);  
for i=1:height  
    for j=1:width  
            mid_img = ori_img(i,j)-m;
            if mid_img <= fa  
                dst_img(i,j) = k1*mid_img;  
            elseif fa < mid_img && mid_img <= fb  
                dst_img(i,j) = k2*(mid_img-fa)+ ga;  
            else  
                dst_img(i,j) = k3*(mid_img-fb)+ gb;  
            end  
    end  
end  
dst_img = uint8(dst_img);
end