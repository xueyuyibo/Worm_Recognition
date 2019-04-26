clear all;clc;close all;
total_image = 4;
for image_num=1:total_image
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    if total_worms == 0
        break;
    end
    for worm_num=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
        connected_area = bwconncomp(worm_full,8);
        cor_area = get_coordinate(connected_area.PixelIdxList{1});
        [area,~] = size(connected_area.PixelIdxList{1});
        color_hist = [0,0,0];
        for pixel_num=1:area
            pixel_color = A(cor_area(pixel_num,1),cor_area(pixel_num,2),:);
            pixel_color = [pixel_color(:,:,1),pixel_color(:,:,2),pixel_color(:,:,3)];
            color_hist = [color_hist;pixel_color];
        end
        color_hist = color_hist(2:end,:);
        color = mean(color_hist);
        pixel_num = count_within_all_points(line_points_full);
        boundary_num = get_boundarypoints_num(worm_full);
        color_represent = [0,0,0];
        color_distribution = [0,0,0];
        line = [0,0];
        for i=1:num_points-1
            line = form_vertical_line(line_points_full(i,:),line_points_full(i+1,:),worm_full);
            [num,~] = size(line);
            color_line = [0,0,0];
            for j=1:num
                c_mid = [A(line(j,1),line(j,2),1),A(line(j,1),line(j,2),2),A(line(j,1),line(j,2),3)];
                color_line = [color_line;c_mid];
            end
            color_line = color_line(2:end,:);
            color_represent = mean(color_line);
        end
        color_represent = color_represent(2:end,:);
        [num,~] = size(color_represent);
        num_group = (num-mod(num,10))/10;
        for i=1:num_group:num
            color_distribution = [color_distribution,mean(color_represent(i:i+num_group-1),:)];
        end
        color_distribution = color_distribution(4:end);
%         feature = [color,area,pixel_num];
        feature = [color,area,pixel_num,boundary_num,color_distribution];
        clear color_hist pixel_color pixel_num cor_area color pixel_num boundary_num area color_distr;
        save (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
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
        if abs(k)>=1
            cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);fix(p1(2):k*(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(2))]; % cor of points in the line
        else
            k = 1/k; % in this case, the line will loss some points if this case is not divided
            cor_line = [fix(p1(1):k*(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(1));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)]; % cor of points in the line
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function line = form_vertical_line(p1,p2,worm_full)
if p2(1) == p1(1) 
    cor_line = [p1(1)*ones(1,abs(p2(2)-p1(2)+(p2(2)-p1(2))/abs(p2(2)-p1(2))));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)];
    [~,num] = size(cor_line);
    for i=1:num
        mid_point_in_line = [cor_line(1,i),cor_line(2,i)];
        line = [(mid_point_in_line(1)-20):(mid_point_in_line(1)+20);mid_point_in_line(2)*ones(1,41)];
    end
else
    k = (p2(2)-p1(2))/(p2(1)-p1(1)); % calculate the slope
    if k ~= 0
        if abs(k)>=1
            cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);fix(p1(2):k*(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(2))]; % cor of points in the line
            [~,num] = size(cor_line);
            for i=1:num
                mid_point_in_line = [cor_line(1,i),cor_line(2,i)];
                line = [(mid_point_in_line(1)-20):(mid_point_in_line(1)+20);round((mid_point_in_line(2)+20/k):(-1/k):(mid_point_in_line(2)-20/k))];
            end
        else
            k = 1/k; % in this case, the line will loss some points if this case is not divided
            cor_line = [fix(p1(1):k*(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(1));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)]; % cor of points in the line
            [~,num] = size(cor_line);
            k = 1/k;
            for i=1:num
                mid_point_in_line = [cor_line(1,i),cor_line(2,i)];
                line = [(mid_point_in_line(1)-20):(mid_point_in_line(1)+20);round((mid_point_in_line(2)+20/k):(-1/k):(mid_point_in_line(2)-20/k))];
            end
        end
    else
        cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);p1(2)*ones(1,abs(p2(1)-p1(1)+(p2(1)-p1(1))/abs(p2(1)-p1(1))))];
        [~,num] = size(cor_line);
        for i=1:num
            mid_point_in_line = [cor_line(1,i),cor_line(2,i)];
            line = [(mid_point_in_line(1))*ones(1,41);(mid_point_in_line(2)-20):(mid_point_in_line(2)+20)];
        end
    end
end
[~,num] = size(line);
i = 1;
while i <= num
    if line(1,i)>1440||line(2,i)>1920
        if i==1
            line = line(:,2:end);
        elseif i==num
            line = line(:,1:num-1);
        else
            line = [line(:,1:i-1),line(:,i+1:end)];
        end
        [~,num] = size(line);
    elseif worm_full(line(1,i),line(2,i))==0
        if i==1
            line = line(:,2:end);
        elseif i==num
            line = line(:,1:num-1);
        else
            line = [line(:,1:i-1),line(:,i+1:end)];
        end
        [~,num] = size(line);
    end
    i = i+1;
end
line = line';
end