clear all; clc; close all;
A = imread('C:\Program Files\MATLAB\R2018a\bin\win64\New folder\First Mission\Original images\Original_Image.png');
I0 = rgb2gray(A);
[height,width] = size(I0);

figure(1)
imshow(A); title('Original_Image');
print Original_Image -dpng
figure(2)
imshow(I0); title('Gray_Image');
print Gray_Image -dpng

I1 = SimpleEnhance(I0);
figure(3)
imshow(I1); title('SimpleEnhanced_Image');
print SimpleEnhanced_GrayImage -dpng

fa=20; fb=80;
ga=50; gb=230;
I = LinearEnhance(I0,fa,fb,ga,gb);
figure(4)
imshow(I); title('LinearEnhanced_Image');
print LinearEnhanced_GrayImage -dpng

Index = [0,0];
for i=1:50:height
    for j=1:50:width
        if I(i,j) >= 30  % See in GetLowThreshold
            Index = [Index;i,j];
        end
    end
end
Index = Index(2:end,:);

[row,colum] = size(Index);
Image = zeros(height,width);
InnerContour = zeros(height,width);
for i=1:row
    a = Index(i,1); b= Index(i,2);
    Imagei = zeros(height,width);
    Imagei(a,b) = I(a,b);                 % fragment display matrix
    InnerContouri = zeros(height,width);  % innercountour matrix
    % while Judge(InnerContouri,Imagei) == 0
    for j=1:10000
        random = unidrnd(8);
        H = [ones(8,1).*a,ones(8,1).*b]+[-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1];
        c = a; d = b; a = H(random,1); b = H(random,2);
        if Imagei(a,b) == 0 && InnerContouri(a,b) == 0
            if I(a,b) >= 30
                Imagei(a,b) = I(a,b);
            else
                InnerContouri(a,b) = 1;
                Imagei(a,b) = I(a,b);
                a = c; b = d;
            end
        else
            a = c; b = d;
        end
    end
    Image = [Image;Imagei];
    InnerContour = [InnerContour;InnerContouri];
end
Image = Image(height+1:end,:);
InnerContour = InnerContour(height+1:end,:);

z = 0;
for i=1:row
    Imagei = Image((i-1)*height+1:i*height,:);
    InnerContouri = InnerContour((i-1)*height+1:i*height,:);
    for j=i+1:row
        Imagej = Image((j-1)*height+1:j*height,:);
        InnerContourj = InnerContour((j-1)*height+1:j*height,:);
        a = Index(i,1); b= Index(i,2);
        if Imagej(a,b) >= 30
            z = [z;j];
        end
    end
end
[x,~] = size(z);
if x > 1
    z = z(2:end,:);
    for i=1:x-1
        X = Image(1:(z(i)-1)*height,:);
        Y = Image(z(i)*height+1:end,:);
        Image = [X;Y];
        X = InnerContour(1:(z(i)-1)*height,:);
        Y = InnerContour(z(i)*height+1:end,:);
        InnerContour = [X;Y];
    end
end

% figure
% [x,y] = size(Image);
% for i=1:x/height
%     subplot(3,4,i);
%     Imagei = Image((i-1)*height+1:i*height,:);
%     Imagei = mat2gray(Imagei);
%     imshow(Imagei); title('ith worm');
% end
% print Worms -dpng
% 
% figure
% for i=1:x/height
%     subplot(3,4,i);
%     InnerContouri = InnerContour((i-1)*height+1:i*height,:);
%     InnerContouri = mat2gray(InnerContouri);
%     imshow(InnerContouri); title('Inner Contour of ith worm');
% end
% print Worms_InnerContour -dpng

[x,~] = size(Image);
for i=1:x/height
    figure
    Imagei = Image((i-1)*height+1:i*height,:);
    Imagei = mat2gray(Imagei);
    imshow(Imagei); title('ith worm');
    picname=[num2str(i) 'Image.fig'];
    saveas(gcf,picname)
end
% print Worms -dpng

for i=1:x/height
    figure
    InnerContouri = InnerContour((i-1)*height+1:i*height,:);
    InnerContouri = mat2gray(InnerContouri);
    imshow(InnerContouri); title('Inner Contour of ith worm');
    picname=[num2str(i) 'Contour.fig'];
    saveas(gcf,picname)
end
% print Worms_InnerContour -dpng


function dst_img=SimpleEnhance(ori_img)

fa = min(min(ori_img));
fb = max(max(ori_img));
[height,width] = size(ori_img);
dst_img=uint8(zeros(height,width));

for i=1:height  
    for j=1:width
        dst_img(i,j) = (ori_img(i,j)-fa)./(fb-fa).*fb; 
    end  
end

dst_img=uint8(dst_img);

end

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

% function judge=Judge(C,I)
% 
% judge = 0;
% 
% 
% end


% GetLowThreshold:(30)
% [height,width] = size(I);
% a = 0;
% for i=1:height
%     for j=1:width
%         a = [a,I(i,j)];
%     end
% end
% sort(a,'descend');
% plot(1:1440.*1920+1,a')

