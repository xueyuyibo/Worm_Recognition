clear all;clc;close all;
A = imread('Original images/Original_Image.jpg');
I = rgb2gray(A);
I = LinearEnhance(I,20,80,50,230);

se = strel('disk',20);  %build disk-shape circle whose r is 20
background = imopen(I,se);
I2 = I - background;
I3 = LinearEnhance(I2,20,80,50,230);
bw = imbinarize(I3,0.15);
bw = bwareaopen(bw,50);

cc = bwconncomp(bw,8);
[~,idx] = size(cc.PixelIdxList);

wormdata = regionprops(cc,'basic');
worm_areas = [wormdata.Area];
[min_area, idxmin] = min(worm_areas);
[max_area, idxmax] = max(worm_areas);
W = zeros(max_area,idx);w = 1;j = 0; %change the expression method
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
idxw = idx-j;

worm = false(size(bw));
for l=1:idxw
    for i=1:max_area
        w = W(i,l);
        if w > 0
            worm(w) = true;
        end
    end
    figure (1);imshow(worm);hold on;
    figure (2);imshow(worm);hold on;
    figure (3);imshow(worm);hold on;
    figure (4);imshow(worm);hold on;
    figure (5);imshow(worm);hold on;
%     pause(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
worm = false(size(bw));
for l=1:idxw %line54-65 has to be rewrite without for loop
    for i=1:max_area
        w = W(i,l);
        if w > 0
            worm(w) = true;
        end
    end
%     imshow(worm);
    for j=1:max_area
        if W(max_area-j+1,l) ~= 0
            break;
        end
    end
    vector_area = W(1:max_area-j+1,l);
    cor_area = get_coordinate(worm,vector_area);
    hold on;
%     plot(cor_area(:,1),cor_area(:,2),'+b');
    cor_boundary = get_boundary(worm,cor_area);
    figure (2);hold on;plot(cor_boundary(:,1),cor_boundary(:,2),'xc');
    points_edge = points_edge_select(cor_boundary);
    figure (3);hold on;plot(points_edge(:,1),points_edge(:,2),'*r');
    cor_ends = ends_select(points_edge);
    figure (4);hold on;plot(cor_ends(:,1),cor_ends(:,2),'ob');
    points = points_select(worm,cor_boundary);
    figure (5);hold on;plot(points(:,1),points(:,2),'sc');
    [line_points,pointed_unused,cor_ends_unused] = linked_line(points,cor_ends);
%     plot(line_points(:,1),line_points(:,2),'md');
    figure (1);show_line(line_points,'r');
%     [num,~] = size(pointed_unused);
%     if (num == 1) && (pointed_unused(1,:) == [0 0])
%     else
%         [line_points,pointed_unused,cor_ends_unused] = linked_line(pointed_unused,cor_ends_unused);
%         figure (1);show_line(line_points,'g');
%         [num,~] = size(pointed_unused);
%         if (num == 1) && (pointed_unused(1,:) == [0 0])
%         else
%             [line_points,pointed_unused,cor_ends_unused] = linked_line(pointed_unused,cor_ends_unused);
%             figure (1);show_line(line_points,'b');
%             [num,~] = size(pointed_unused);
%             if (num == 1) && (pointed_unused(1,:) == [0 0])
%             else
%                 [line_points,pointed_unused,cor_ends_unused] = linked_line(pointed_unused,cor_ends_unused);
%                 figure (1);show_line(line_points,'c');
%                 [num,~] = size(pointed_unused);
%                 if (num == 1) && (pointed_unused(1,:) == [0 0])
%                 else
%                     [line_points,pointed_unused,cor_ends_unused] = linked_line(pointed_unused,cor_ends_unused);
%                     figure (1);show_line(line_points,'m');
%                 end
%             end
%         end
%     end
end
figure (1);print Clusters_With_One_Line -dpng;hold off;
figure (2);print Clusters_Boundary -dpng;hold off;
figure (3);print Clusters_Edge_Sample -dpng;hold off;
figure (4);print Clusters_Corner_Points -dpng;hold off;
figure (5);print Clusters_Inner_Sample_Points -dpng;hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show_line(line_points,color)
[num,~] = size(line_points);
hold on;
for i=1:num-1
    plot([line_points(i,1),line_points(i+1,1)],[line_points(i,2),line_points(i+1,2)],color,'LineWidth',5);
end
hold off;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [line_points,points_unused,cor_ends_unused] = linked_line(points,cor_ends)
line_points = cor_ends(1,:);
[npoints,~] = size(points);
points2 = points;
cor_ends2 = cor_ends;
cor_ends2(1,:) = [-1000 -1000];
points_unused = zeros(1,2);
cor_ends_unused = zeros(1,2);
for i=1:npoints
    dis = 60;
    n = 0;
    for j=1:npoints
        if dis > norm(line_points(i,:)-points2(j,:))
            dis = norm(line_points(i,:)-points2(j,:));
            n = j;
        end
    end
    if n == 0
        break;
    else
        line_points = [line_points;points(n,:)];
    end
    points2(n,:) = [-1000 -1000];
end
[a,~] = size(points);
flag = 0;
for i=1:a
    if points2(i,1) > 0
        points_unused = [points_unused;points2(i,:)];
        flag = 1;
    end
end
if flag == 1
    points_unused = points_unused(2:end,:);
end
[num,~] = size(cor_ends);
[a,~] = size(line_points);
dis = 60;
n = 0;
for i=1:num
    if dis > norm(line_points(a,:)-cor_ends(i,:))
        dis = norm(line_points(a,:)-cor_ends(i,:));
        n = i;
    end
end
if n > 0
    line_points = [line_points;cor_ends(n,:)];
    cor_ends2(n,:) = [-1000 -1000];
end
flag = 0;
for i=1:num
    if cor_ends2(i,1) > 0
        cor_ends_unused = [cor_ends_unused;cor_ends2(i,:)];
        flag = 1;
    end
end
if flag == 1
    cor_ends_unused = cor_ends_unused(2:end,:);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_area = get_coordinate(img,vector_area)
[row,~] = size(vector_area); 
cor_area = zeros(row,2);
[r,~] = size(img);
for i=1:row
    y = mod(vector_area(i),r);
    x = (vector_area(i)-y)/r+1;
    cor_area(i,:) = [x,y];
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_boundary = get_boundary(img,cor_area)
worm = false(size(img));
[row,~] = size(cor_area);
for i=1:row
    a = cor_area(i,1);
    b = cor_area(i,2);
    worm(a,b) = true;%should be removed
end
B = bwboundaries(worm,'holes');%see in doc
for k = 1:length(B)
    if k == 1
        cor_boundary = B{k};
    else
        boundary = B{k};
        cor_boundary = [cor_boundary;boundary];
    end
end
% [num,~] = size(cor_boundary);
% boundary = cor_boundary;
% boundary = [boundary;boundary(1:3,:)];
% for i=1:num-3
%     cor_boundary(i,:) = mean(boundary(i:i+3,:));
% end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points_edge = points_edge_select(cor_boundary)
[num,~] = size(cor_boundary);
r = (num-mod(num,25))/25;
points_edge = zeros(r,2);
j = 1;
for i=1:r
    points_edge(i,:) = cor_boundary(j,:);
    j = j+25;%X(1:25:end)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = points_select(img,cor_boundary)
[num,~] = size(cor_boundary);
r = (num-mod(num,25))/25;
points_edge = points_edge_select(cor_boundary);
points_edge2 = points_edge;
points = zeros(1,2);
for j=1:r
    if points_edge2(j,1) > 0
        n = 0;
        dis = num/4;
        for k=1:r
            if k ~= j
                if dis > norm(points_edge(j,:)-points_edge2(k,:))
                    dis = norm(points_edge(j,:)-points_edge2(k,:));
                    n = k;
                end
            end
        end
        if n > 0
%             judge = judge_neighbor(img,(points_edge(j,:)+points_edge(n,:))./2);
%             if judge == 1
                points = [points;(points_edge(j,:)+points_edge(n,:))./2];
                points_edge2(j,:) = [-1000 -1000];
                points_edge2(n,:) = [-1000 -1000];
%             end
        end
    end
end
points = points(2:end,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function judge = judge_neighbor(img,cor_point)
judge = 0;
a = cor_point(1,1);
b = cor_point(1,2);
% for i=max(a-1,1):a+1
%     for j=max(b-1,1):b+1
%         if img(i,j) == true
%             judge = 1;
%         end
%     end
% end
if img(a,b) == true
    judge = 1;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_ends = ends_select(points_edge)
[num,~] = size(points_edge);
% r = (num-mod(num,20))/20;
cor_ends = zeros(1,2);
j = 1;
for i=1:num-1
    if j > 1
        if (norm(points_edge(j+1,:)-points_edge(j-1,:)))^2 < (norm(points_edge(j,:)-points_edge(j-1,:)))^2+(norm(points_edge(j,:)-points_edge(j+1,:)))^2
            cor_ends = [cor_ends;points_edge(j,:)];
        end
    else
        if (norm(points_edge(1,:)-points_edge(num-1,:)))^2 < (norm(points_edge(num,:)-points_edge(num-1,:)))^2+(norm(points_edge(num,:)-points_edge(1,:)))^2
            cor_ends = [cor_ends;points_edge(j,:)];
        end
    end
    j = j+1;
end
if (norm(points_edge(num,:)-points_edge(2,:)))^2 < (norm(points_edge(1,:)-points_edge(2,:)))^2+(norm(points_edge(1,:)-points_edge(num,:)))^2
    cor_ends = [cor_ends;points_edge(1,:)];
end
cor_ends = cor_ends(2:end,:);
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