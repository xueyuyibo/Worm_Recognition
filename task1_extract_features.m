clear all;clc;close all;
total_image = 4;
for threshold=0.1:0.01:0.2 %0.15
    for image_num=1:total_image
        load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_image.mat']);        
        for worm_num=1:total_worms
            fprintf(['threshold_percent=',num2str((threshold-0.1)/0.1),'\n']);
            fprintf(['image_num=',num2str(image_num),'\n']);
            fprintf(['worm_num=',num2str(worm_num),'\n']);
            
            load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
            clear i k;
            connected_area = bwconncomp(worm_full,8);
            cor_area = get_coordinate(connected_area.PixelIdxList{1});
            [area,~] = size(connected_area.PixelIdxList{1});
            clear connected_area;
            color_hist = [0,0,0];
            for pixel_num=1:area
                pixel_color = A(cor_area(pixel_num,1),cor_area(pixel_num,2),:);
                pixel_color = [pixel_color(:,:,1),pixel_color(:,:,2),pixel_color(:,:,3)];
                color_hist = [color_hist;pixel_color];
            end
            color_hist = color_hist(2:end,:);
            color = mean(color_hist);
            clear color_hist;
            pixel_num = count_within_all_points(line_points_full);
            boundary_num = get_boundarypoints_num(worm_full);

            if pixel_num>1
                point_inline = point_in_all_points(line_points_full);
                num_group = (pixel_num-mod(pixel_num,5))/5;
                color_group_hist1 = [0 0 0];
                for i=1:num_group:(num_group*5)
                    color_group = [0 0 0];
                    for j=1:area
                        for k=0:num_group-1
                            if i+k > pixel_num
                                break;
                            end
                            if norm(point_inline(i+k,:)-cor_area(j,:)) < 8
                                pixel_color = A(cor_area(j,1),cor_area(j,2),:);
                                pixel_color = [pixel_color(:,:,1),pixel_color(:,:,2),pixel_color(:,:,3)];
        %                         SHOW(cor_area(j,1),cor_area(j,2),:) = A(cor_area(j,1),cor_area(j,2),:);  %%
        %                         SHOW(point_inline(i+k,1),point_inline(i+k,2),1) = 2^8-1;  %%
                                color_group = [color_group;pixel_color];
                            end
                        end
                    end
                    color_group = color_group(2:end,:);
                    color_group = mean(color_group);
                    color_group_hist1 = [color_group_hist1,color_group];
                end
                color_group_hist1 = color_group_hist1(:,4:end);
                color_group_hist2 = [];
                i = 4;
                while i>=0
                    color_group_hist2 = [color_group_hist2,color_group_hist1(:,3*i+1:3*i+3)];
                    i = i-1;
                end
            end
            
            feature = [color,area,pixel_num];
    %         feature1 = [color,area,pixel_num,color_group_hist1];
    %         feature2 = [color,area,pixel_num,color_group_hist2];
            if pixel_num>1
                feature1 = [area,pixel_num,color_group_hist1];
                feature2 = [area,pixel_num,color_group_hist2];
            else
                feature1 = [area,pixel_num,color,color,color,color,color];
                feature2 = feature1;
            end
            clear point_inline num_group color_group pixel_color i color area pixel_num boundary_num color_group_hist1 color_group_hist2;
            clear idx idxmax idxmin points_unused_full;
            clear cor_area j k;
            save (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_area = get_coordinate(vector)
% get cor from vector
global I;
[r,~] = size(I);
x = mod(vector,r)+(mod(vector,1440)==0)*r;
y = (vector-x)/r+1;
cor_area = [x,y];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pixel_num = count_within_all_points(cor_points)
[num,~] = size(cor_points);
pixel_num = 0;
for i=1:num-1
    pixel_num = pixel_num+count_within_two_points(cor_points(i,:),cor_points(i+1,:));
end
pixel_num = pixel_num-num+2; % reduce the repeated points
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pixel_num = count_within_two_points(p1,p2)
m = 0; % two points are not the same point
if p2(1) == p1(1) 
    if p2(2) ~= p1(2)
        cor_line = [p1(1)*ones(1,abs(p2(2)-p1(2)+(p2(2)-p1(2))/abs(p2(2)-p1(2))));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)];
    else
        m = 1; % two points are the same point
    end
else
    k = (p2(2)-p1(2))/(p2(1)-p1(1)); % calculate the slope
    if k ~= 0
        if abs(k)<=1
            cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);round(p1(2):k*(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(2))]; % cor of points in the line
        else
            k = 1/k; % in this case, the line will loss some points if this case is not divided
            cor_line = [round(p1(1):k*(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(1));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)]; % cor of points in the line
        end
    else
        cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);p1(2)*ones(1,abs(p2(1)-p1(1)+(p2(1)-p1(1))/abs(p2(1)-p1(1))))];
    end
end
if m == 0
    [~,pixel_num] = size(cor_line);
else
    pixel_num = 0;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function point_inline = point_in_all_points(cor_points)
[num,~] = size(cor_points);
if num==1
    point_inline = cor_points;
else
    point_inline = [0 0];
    for i=1:num-1
        if i==1
            point_inline = [point_inline;point_in_two_points(cor_points(i,:),cor_points(i+1,:))];
        else
            point_inline = point_inline(1:end-1,:);
            point_inline = [point_inline;point_in_two_points(cor_points(i,:),cor_points(i+1,:))];
        end
    end
    point_inline = point_inline(2:end,:);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function point_inline = point_in_two_points(p1,p2)
m = 0; % two points are not the same point
if p2(1) == p1(1) 
    if p2(2) ~= p1(2)
        cor_line = [p1(1)*ones(1,abs(p2(2)-p1(2)+(p2(2)-p1(2))/abs(p2(2)-p1(2))));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)];
    else
        m = 1; % two points are the same point
    end
else
    k = (p2(2)-p1(2))/(p2(1)-p1(1)); % calculate the slope
    if k ~= 0
        if abs(k)<=1
            cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);round(p1(2):k*(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(2))]; % cor of points in the line
        else
            k = 1/k; % in this case, the line will loss some points if this case is not divided
            cor_line = [round(p1(1):k*(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(1));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)]; % cor of points in the line
        end
    else
        cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);p1(2)*ones(1,abs(p2(1)-p1(1)+(p2(1)-p1(1))/abs(p2(1)-p1(1))))];
    end
end
if m == 0
    point_inline = cor_line';
else
    point_inline = [];
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function boundary_num = get_boundarypoints_num(worm)
B = bwboundaries(worm); % get a (p*1)cell array of boundary points
[numbcell,~] = size(B);
boundary = [0 0];
for i=1:numbcell
    [numbarray,~] = size(B{i});
    if numbarray>20 % if the number of boundary points are larger than 20, which means it's a big inner area
        boundary = [boundary;B{i}]; % link different boundaries together
    end
end
boundary = boundary(2:end,:);
[boundary_num,~] = size(boundary);
end
