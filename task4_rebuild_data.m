clear all;clc;close all;
global I_ref A count1 count2;
count1 = 0;
count2 = 0;
A = imread('Original_images/new/batchA1/pi1.tif');
[size_a,size_b,~] = size(A);
I_ref = rgb2gray(A);
for a=1:size_a
    for b=1:size_b
        I_ref(a,b) = 0;
    end
end
clear size_a size_b;

name_list = [];
total_image = 6; % 7
for color_num=1:1 % 3
    for image_num=1:total_image
        if exist(['output/color_',num2str(color_num),'/image_',num2str(image_num)],'dir')==1
            rmdir(['output/color_',num2str(color_num),'/image_',num2str(image_num)],'s');
        end
        name = generate_pictures(image_num,color_num);
        if image_num>1
            name_max = max(name_list(:,5));
            [num_name,~] = size(name);
            for i=1:num_name
                name(i,5) = name(i,5)+name_max;
            end
        end
        name_list = [name_list;name];
    end
    [num,~] = size(name_list);
    idx = [];
    for i=1:num
        if name_list(i,1)==0 && name_list(i,2)==0 && name_list(i,3)==0 && name_list(i,4)==0
            idx = [idx;i];
        end
    end
    name_list(idx,:) = [];
    save name_list.mat name_list;
end

color_distr = [1 1 0;1 0 1;0 0 0;0 1 1;0 0 1;0 1 0;1 0 0;0.5 0.5 0.5;0.5 0.5 0;0.5 0 0.5;0.5 0 0;0 0.5 0.5;0 0.5 0;0 0 0.5;0.25 0.25 0.25;0.25 0.25 0;0.25 0 0.25;0.25 0 0;0 0.25 0.25;0 0.25 0;0 0 0.25;0.1 0 0.5;0.5 0 0.1];
[num,~] = size(name_list);
for assigned_name=1:max(name_list(:,5))
    res1 = [];
    res2 = [];
    res3 = [];
    for i=1:num
        if name_list(i,5)==assigned_name
            load (['output/color_',num2str(name_list(i,1)),'/image_',num2str(name_list(i,2)),'/threshold_',num2str(name_list(i,3)),'/data_',num2str(name_list(i,4)),'.mat'],'feature');
            res1 = [res1;[feature(name_list(i,1)),name_list(i,3)]];
            res2 = [res2;[feature(4),name_list(i,3)]];
            res3 = [res3;[feature(5),name_list(i,3)]];
        end
    end
    figure(1);hold on;
    plot(res1(:,2),res1(:,1),'Color',color_distr(assigned_name,:),'LineWidth',2);
    figure(2);hold on;
    plot(res2(:,2),res2(:,1),'Color',color_distr(assigned_name,:),'LineWidth',2);
    figure(3);hold on;
    plot(res3(:,2),res3(:,1),'Color',color_distr(assigned_name,:),'LineWidth',2);
end


function name_list = generate_pictures(image_num,color_num)
    global I_ref;
    worm_pic{3} = [];
    worm_pic{4}{1} = [];
    name_list = [];
    for threshold=0.1:0.01:0.2 %0.15
%         fprintf(['image_num=',num2str(image_num),'\n']);
%         fprintf(['color_num=',num2str(color_num),'\n']);
%         fprintf(['threshold_percent=',num2str((threshold-0.1)/0.1),'\n']);
        extract_worm(image_num,color_num,threshold);
        [worm_pic,judge,name] = judge_interrupt(image_num,color_num,threshold,worm_pic);
        if judge == 0
%             imshow(I_ref);
            rmdir(['output/color_',num2str(color_num),'/image_',num2str(image_num)],'s');
            name_list = generate_pictures(image_num,color_num);
            break;
        end
        name_list = [name_list;name];
    end
end

function [res,judge,name] = judge_interrupt(image_num,color_num,threshold,worm_pic)
    judge = 1;
    global I_ref count1 count2;
    width = 4;
    name = [];
    load (['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/data_image.mat'],'total_worms');
    if total_worms == 0
        res = worm_pic;
        name = [0,0,0,0,0]; 
    end
    [name_max,~] = size(worm_pic{1});
    i = 1;
    while(i<=name_max)
        dist = 1000;
        for j=1:total_worms
            load (['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/data_',num2str(j),'.mat'],'edge_sample_full');
            location = mean(edge_sample_full);
            if norm(location-worm_pic{2}(i,:)) < dist
                dist = norm(location-worm_pic{2}(i,:));
            end
        end
        if dist >= 50
            res = worm_pic;
            name = [0,0,0,0,0];
            whole_line_area = connect_line(worm_pic{5}{i},width);
            [size_mid,~] = size(whole_line_area);
            idex = [];
            for mid=1:size_mid
                if I_ref(whole_line_area(mid,1),whole_line_area(mid,2))==0
                    idex = [idex,mid];
                end
            end
            whole_line_area(idex,:) = [];
            [size_line,~] = size(whole_line_area);
            if size_line==0
                whole_line_area = connect_line(worm_pic{5}{i},width);
                [size_mid,~] = size(whole_line_area);
                for mid=1:size_mid
                    I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) = I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) + 4;
                end
            else
                whole_line_area = points_simplize(whole_line_area,3);whole_line_area = points_simplize(whole_line_area,3);
                [whole_line_area,~] = form_line(whole_line_area,25);
                whole_line_area = connect_line(whole_line_area,width);
                [size_mid,~] = size(whole_line_area);
                for mid=1:size_mid
                    I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) = I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) + 4;
                end
            end
            if max(max(I_ref(whole_line_area(:,1),whole_line_area(:,2))))>=44
                worm_pic{1}(i) = [];
                worm_pic{2}(i,:) = [];
                worm_pic{3}(i,:) = [];
                worm_pic{4}(i) = [];
                worm_pic{5}(i) = [];
                name_max = name_max-1;
                i = i-1;
            else
                judge = 0;
            end
%             return;
        end
        i = i+1;
    end
    for i=1:total_worms
        fprintf(['image=',num2str(image_num)]);
        fprintf(['   color=',num2str(color_num)]);
        fprintf(['   threshold=',num2str(threshold)]);
        fprintf(['   i=',num2str(i),'\n']);
        load (['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/data_',num2str(i),'.mat'],'feature','edge_sample_full','cor_area','line_points_full');
        location1 = mean(edge_sample_full);
        [num,~] = size(worm_pic{1});
        dist = 1000;
        for j=1:num
            if norm(location1-worm_pic{2}(j,:)) < dist
                n = j;
                dist = norm(location1-worm_pic{2}(j,:));
            end
        end
        if dist < 50 % to be rectified
            if worm_pic{3}(n,2)-feature(4)>=350 || worm_pic{3}(n,3)-feature(5)>=20 % to be rectified
                judge = 0;
                whole_line_area = connect_line(worm_pic{5}{n},width);
                [size_mid,~] = size(whole_line_area);
                idex = [];
                for mid=1:size_mid
                    if I_ref(whole_line_area(mid,1),whole_line_area(mid,2))==0
                        idex = [idex,mid];
                    end
                end
                whole_line_area(idex,:) = [];
                [size_line,~] = size(whole_line_area);
                if size_line==0
                    whole_line_area = connect_line(worm_pic{5}{n},width);
                    [size_mid,~] = size(whole_line_area);
                    for mid=1:size_mid
                        I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) = I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) + 4;
                    end
                else
                    whole_line_area = points_simplize(whole_line_area,3);whole_line_area = points_simplize(whole_line_area,3);
                    [whole_line_area,~] = form_line(whole_line_area,25);
                    whole_line_area = connect_line(whole_line_area,width);
                    [size_mid,~] = size(whole_line_area);
                    for mid=1:size_mid
                        I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) = I_ref(whole_line_area(mid,1),whole_line_area(mid,2)) + 4;
                    end
                end
                if i == 1
                    res = worm_pic;
                end
                name = [0,0,0,0,0];
            else
                if i == 1
                    res = worm_pic;
                end
                res{2}(n,:) = location1;
                res{3}(n,:) = [feature(color_num),feature(4),feature(5)];
                res{4}{n} = cor_area;
                res{5}{n} = line_points_full;
            end
            name = [name;[color_num,image_num,threshold,i,n]];
        else
            if i == 1
                res{1} = [worm_pic{1};num+1];
                res{2} = [worm_pic{2};location1];
                res{3} = [worm_pic{3};[feature(color_num),feature(4),feature(5)]];
            else
                res{1} = [res{1};name_max + 1];
                res{2} = [res{2};location1];
                res{3} = [res{3};[feature(color_num),feature(4),feature(5)]];
            end
            res{4}{name_max+1} = cor_area;
            res{5}{name_max+1} = line_points_full;
            name = [name;[color_num,image_num,threshold,i,name_max + 1]];
            name_max = name_max + 1;
        end
        clear feature edge_sample_full line_points_full cor_area;
    end
end

function extract_worm(image_num,color_num,threshold)
    global I cc wormdata I_ref;
    if ~exist(['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold)],'dir')==1
        mkdir(['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold)]);
    end
    folder_name = {'pi','fitc','cfp'};
    A = imread(['Original_images/new/batchA',num2str(image_num),'/',folder_name{color_num},num2str(image_num),'.tif']);
    I = rgb2gray(A);
    I_grey = I;
    I = LinearEnhance(I,20,80,50,230);

    % eliminate bright areas in background(see results in docx):
    se = strel('disk',20);  % build disk-shape circle whose r is 20
    background = imopen(I,se); % open images(erosion with element inside the bright areas, if element contains then preserve)
    clear se;
    I = I - background;
    clear background;
    I = LinearEnhance(I,20,80,50,230);
    I = I + I_ref;
    I = imbinarize(I,threshold);
    I = bwareaopen(I,500,4); % remove all connected areas that have fewer than 500 pixels, 4 is the connectivity

    cc = bwconncomp(I,8); % get a struct contains Connectivity&ImageSize&NumObjects&PixelIdxList of connected areas
    idx = cc.NumObjects; % number of connected areas
    wormdata = regionprops(cc,'basic'); % get Area&BoundingBox&Centroid of each area
%     [max_area,~] = max([wormdata.Area]);
%     [min_area,~] = min([wormdata.Area]);
    figure('units', 'pixels', 'innerposition', [0 0 800 1400]);
    sample_interval = 10;
    i = 1;
%     j = 1;
    for k=1:idx
%         fprintf(['threshold=',num2str(threshold),'   k=',num2str(k),'\n']);
        worm = localize_worm(k);       
        worm_full = full_worm(k);
        cor_boundary = get_boundary(worm);
        cor_boundary_full = get_boundary(worm_full);
        [boundary_num,~] = size(cor_boundary);
        edge_sample = edge_sample_select(cor_boundary,sample_interval);
        edge_sample_full = edge_sample_select(cor_boundary_full,sample_interval);
%         plot(edge_sample(:,2),edge_sample(:,1),'xm');

        mid_points = get_mid_points(worm,edge_sample);
        mid_points_full = get_mid_points(worm_full,edge_sample_full);
%         plot(mid_points(:,2),mid_points(:,1),'.k'); % link the original mid_points
        mid_points = points_simplize(mid_points,5);mid_points = points_simplize(mid_points,5);mid_points = points_simplize(mid_points,5);
        mid_points_full = points_simplize(mid_points_full,5);mid_points_full = points_simplize(mid_points_full,5);mid_points_full = points_simplize(mid_points_full,5);
%         plot(mid_points(:,2),mid_points(:,1),'ob');
        [mid_points_num,~] = size(mid_points);
        if mid_points_num~=0
            [line_points,points_unused] = form_line(mid_points,25);
            [line_points_full,~] = form_line(mid_points_full,25);
            [num_unused,~] = size(points_unused);
            [num_used,~] = size(line_points);
            brightness = mean(I_grey(cc.PixelIdxList{k}));
            clear mid_points_full mid_points_num;
            if num_unused/num_used < 0.8 && wormdata(k).Area/boundary_num>=2 && brightness>=15
                clear boundary_num;
                imshow(worm,'InitialMagnification','fit');title(i);
                hold on;
                plot(edge_sample(:,2),edge_sample(:,1),'xm');
                plot(mid_points(:,2),mid_points(:,1),'ob');
                plot(points_unused(:,2),points_unused(:,1),'*r');
                show_line(line_points);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                connected_area = bwconncomp(worm_full,8);
                cor_area = get_coordinate(connected_area.PixelIdxList{1});
                [area,~] = size(connected_area.PixelIdxList{1});
                clear connected_area;
                color_hist = [0,0,0];
                for pixel_num=1:area
    %                 fprintf(['pixel_num=',num2str(pixel_num),'\n']);
                    pixel_color = A(cor_area(pixel_num,1),cor_area(pixel_num,2),:);
                    pixel_color = [pixel_color(:,:,1),pixel_color(:,:,2),pixel_color(:,:,3)];
                    color_hist = [color_hist;pixel_color];
                end
                color_hist = color_hist(2:end,:);
                color = mean(color_hist);
                pixel_num = count_within_all_points(line_points_full);
                feature = [color,area,pixel_num];
                clear color area pixel_num pixel_color color_hist;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                save (['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/data_',num2str(i),'.mat']);
                saveas(gcf,['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/line_',num2str(i),'.png']);
                Bounding = get_boundingbox(k);
                a = Bounding(1,1);
                b = Bounding(1,2);
                c = Bounding(2,1);
                d = Bounding(2,2);
                [size_a,size_b,~] = size(A);
                worm_RGB = A(a:c,b:d,:);
                worm_blank = A;
                for m=1:size_a
                    for n=1:size_b
                        for l=1:3
                            worm_blank(m,n,l) = 0;
                        end
                    end
                end
                worm_full_RGB = worm_blank;
                for m=a:c
                    for n=b:d
                        for l=1:3
                            worm_full_RGB(m,n,l) = A(m,n,l);
                        end
                    end
                end
                worm_RGB = [worm_blank(1:(c-a+1+10),1:5,:),[worm_blank(1:5,1:(d-b+1),:);worm_RGB;worm_blank(1:5,1:(d-b+1),:)],worm_blank(1:(c-a+1+10),1:5,:)];
                imshow(worm_RGB,'InitialMagnification','fit');title(i);
                saveas(gcf,['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/worm_',num2str(i),'.png']);
                imshow(worm_full_RGB,'InitialMagnification','fit');title(i);
                saveas(gcf,['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/worm_full_',num2str(i),'.png']);
                clear a b c d m n l size_a size_b worm_blank Bounding;
                i = i+1;
            end
        end
    end
    total_worms = i-1;
    save (['output/color_',num2str(color_num),'/image_',num2str(image_num),'/threshold_',num2str(threshold),'/data_image.mat']);
    close all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = find_neighbor(line,width)
global A;
[a,b,~] = size(A);
[num,~] = size(line);
c = min(line);
d = max(line);
points = [];
for h=1:num
    for i=max(0,c(1)-5):min(a,d(1)+5)
        for j=max(0,c(2)-5):min(b,d(2)+5)
            if norm([i,j]-line(h,:))<=width
                points = [points;[i,j]];
            end
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function whole_line = connect_line(points,width)
[num,~] = size(points);
if num==1
    whole_line = find_neighbor(points,width);
else
    line = [];
    whole_line = [];
    for i=1:num-1
        line_ref = linked_line(points(i,:),points(i+1,:));
        line = [line;line_ref];
        if i~=num-1
            line = line(1:end-1,:);
        end
        whole_line = [whole_line;find_neighbor(line_ref,width)];
    end
end
whole_line = unique(whole_line,'rows');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = points_simplize(points_sample,dis)
% for points in the neighbor, find the mean of them, and replace the points with the mean
points = points_sample;
[num_size,~] = size(points);
i = 1;
while i<=num_size
    points_group = [0 0];
%     plot(points(:,2),points(:,1),'ow');
%     plot(points(i,2),points(i,1),'oc');
    for j=1:num_size % for every point, find the neighbor points
        if norm(points(i,:)-points(j,:)) <= dis % the "neighbor" is defined by the distance of dis
            points_group = [points_group;points(j,:)]; % list the neighbor points group
        end
    end
    [num_group,~] = size(points_group);
    if num_group > 1 % if there exists a neighbor point for every point i
        points_group = points_group(2:end,:);
%         plot(points_group(:,2),points_group(:,1),'ob');
        [num_group,~] = size(points_group);
        for j=1:num_group % for every point in the group, find the same point in the original point list and remove it
            k = 1;
            while k<=num_size
                if points(k,:)==points_group(j,:)
                    if k==1
                        points = points(2:end,:);
                    elseif k==num_size
                        points = points(1:num_size-1,:);
                    else
                        points = [points(1:k-1,:);points(k+1:end,:)];
                    end
%                     if k <= i % move forward the index, and if i<0, set i=0
%                         i = i-1;
%                     end
                end
                [num_size,~] = size(points);
                k = k+1;
            end
        end
        points = [points;fix(mean(points_group,1))]; % plug the mean at the end
%         plot(points(num_size+1,2),points(num_size+1,1),'or');
%         plot(points_group(:,2),points_group(:,1),'ow');
    end
    [num_size,~] = size(points);
    i = i+1;
%     plot(points(:,2),points(:,1),'ob');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = get_mid_points(worm,edge_sample)
% find list of mid_points
% 1st for loop: for each point
% 2nd for loop: for every points group
% why? see in "judge_group"
[num,~] = size(edge_sample);
points = [0 0];
group_num = 3;
for i=1:num
    goal_dis = 10000;
%     plot(edge_sample(i,2),edge_sample(i,1),'or'); %%%%
    if i==1
        edge_sample3 = edge_sample(2:num,:);
    elseif i==num
        edge_sample3 = edge_sample(1:num-1,:);
    else
        edge_sample3 = [edge_sample(i+1:num,:);edge_sample(1:i-1,:)]; % range of goal_points(num-1)
    end
    for j=1:num-group_num % each group has 3 points
%         plot(edge_sample3(j:j+group_num-1,2),edge_sample3(j:j+group_num-1,1),'*r'); %%%%
        [judge,n,dis] = judge_group(worm,edge_sample3(j:j+group_num-1,:),edge_sample(i,:));
        if judge == 1
            if goal_dis >= dis
                goal_point = edge_sample3(j+n-1,:); % record goal_point
                goal_dis = dis; % record goal_distance
%                 goal_group_num = j; %%%%
%                 goal_num = j+n-1; %%%%
            end
        end
%         plot(edge_sample3(j:j+group_num-1,2),edge_sample3(j:j+group_num-1,1),'*w'); %%%%
%         plot(edge_sample3(j:j+group_num-1,2),edge_sample3(j:j+group_num-1,1),'xm'); %%%%
    end
    if goal_dis < 35 % if there exist a goal point for the point now, and the dis should not be larger than twice the width of the worm
        mid_point = round((goal_point+edge_sample(i,:))/2);
%         now_point = edge_sample(i,:); %%%%
%         goal_group = edge_sample3(goal_group_num:goal_group_num+group_num-1,:);%%%%
%         plot(goal_point(2),goal_point(1),'*r');%%%%
%         plot(mid_point(2),mid_point(1),'ob');%%%%
        points = [points;mid_point];
%         plot(goal_point(2),goal_point(1),'*w');%%%%
%         plot(goal_point(2),goal_point(1),'xm');%%%%
%         plot(mid_point(2),mid_point(1),'ow');%%%%
%         plot(mid_point(2),mid_point(1),'.k');%%%%
    end
%     plot(edge_sample(i,2),edge_sample(i,1),'ow');%%%%
end
points = points(2:end,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [judge,n,k] = judge_group(worm,goal_group,now_point)
% for each sample, to select points to the opposite side, we can let the
% goal point lies in a group where:
% 1.the local min of norm is in the group, not on the side
% 2.the goal_point in the group satisfies "most of the line between two points are in the area"
[num,~] = size(goal_group);
k = 10000;
for i=1:num % judge the 1st principle
    if norm(now_point-goal_group(i,:)) < k
        k = norm(now_point-goal_group(i,:));
        n = i;
    end
end
if judge_twopoints(worm,now_point,goal_group(n,:)) == 1 && (n < num && n > 1) % judge the 2nd principle
    judge = 1;
else
    judge = 0;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_line = linked_line(p1,p2)
if p2(1) == p1(1) 
    if p2(2) ~= p1(2)
        cor_line = [p1(1)*ones(1,abs(p2(2)-p1(2)+(p2(2)-p1(2))/abs(p2(2)-p1(2))));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)];
    end
else
    k = (p2(2)-p1(2))/(p2(1)-p1(1)); % calculate the slope
    if k ~= 0
        if abs(k)<=1
            cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);fix(p1(2):k*(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(2))]; % cor of points in the line
        else
            k = 1/k; % in this case, the line will loss some points if this case is not divided
            cor_line = [fix(p1(1):k*(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(1));p1(2):(p2(2)-p1(2))/abs(p2(2)-p1(2)):p2(2)]; % cor of points in the line
        end
    else
        cor_line = [p1(1):(p2(1)-p1(1))/abs(p2(1)-p1(1)):p2(1);p1(2)*ones(1,abs(p2(1)-p1(1)+(p2(1)-p1(1))/abs(p2(1)-p1(1))))];
    end
end
cor_line = cor_line';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function judge = judge_twopoints(worm,p1,p2)
% judge if most of the line between two points are in the area
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
    [~,num] = size(cor_line);
    s = 0;
    for i=1:num
        if worm(cor_line(1,i),cor_line(2,i)) == true % if this point is in the area
            s = s+1;
        end
    end
    mid_point = round((p1+p2)/2);
%     if ((s/num)>=0.5) && (worm(mid_point(1),mid_point(2))==true) % if most points in the line are in the area and the mid point is in the area
    if ((s/num)>=0.7)
        judge = 1;
    else
        judge = 0;
    end
else
    judge = 0;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function worm = localize_worm(num)
% get localized worm img
global cc;
Bounding = get_boundingbox(num);
worm = false(Bounding(2,1)-Bounding(1,1)+1,Bounding(2,2)-Bounding(1,2)+1);
cor = get_coordinate(cc.PixelIdxList{num})-Bounding(1,:)+[1,1]; % get cor correlating to worm
vector = (cor(:,2)-1)*(Bounding(2,1)-Bounding(1,1)+1)+cor(:,1); % get vector correlating to worm
worm(vector) = true;
% plus a "frame" of width 5 to worm:
worm = [false((Bounding(2,1)-Bounding(1,1)+1)+10,5),[false(5,(Bounding(2,2)-Bounding(1,2)+1));worm;false(5,(Bounding(2,2)-Bounding(1,2)+1))],false((Bounding(2,1)-Bounding(1,1)+1)+10,5)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function worm_full = full_worm(num)
% get worm full img
global cc;
worm_full = false(cc.ImageSize);
worm_full(cc.PixelIdxList{num}) = true;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Bounding = get_boundingbox(num)
% get boundary:we can use wormdata(i).BoundingBox,but it's a 1*4vector 
% [x y x_width y-width], where x&y are cor of upper-left-corner
% we do not use this because: 
% 1st.x&y are not int(is x or y minus 0.5); 
% 2nd.we cannot get all boundaries, we just get widths
global cc;
a = min(get_coordinate(cc.PixelIdxList{num}));
b = max(get_coordinate(cc.PixelIdxList{num}));
Bounding = [a;b];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_area = get_coordinate(vector)
% get cor from vector
global I;
[r,~] = size(I);
x = mod(vector,r)+(mod(vector,r)==0)*r;
y = (vector-x)/r+1;
cor_area = [x,y];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_boundary = get_boundary(worm)
B = bwboundaries(worm); % get a (p*1)cell array of boundary points
[numbcell,~] = size(B);
cor_boundary = [];
for i=1:numbcell
    [numbarray,~] = size(B{i});
    if numbarray>20 % if the number of boundary points are larger than 20, which means it's a big inner area
        cor_boundary = [cor_boundary;B{i}]; % link different boundaries together
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edge_sample = edge_sample_select(cor_boundary,num)
% select sample points in boundary
edge_sample = cor_boundary(1:num:end,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [line_points,points_unused] = form_line(points,dis)
% start with the first point, find the closest point in the neighbor(norm<dis), and give the rest point set "points_unused"
line_points = points(1,:); % from the first point
points_unused = points; % initialize points_unused
[num,~] = size(points);
points2 = points;
points2(1,:) = [-1000 -1000];
% plot(line_points(2),line_points(1),'*r'); %%
i = 1; % find the "head"
while i>0 % for every point i in line_points, find the closest point in the neighbor of dis
    distance = dis;
    n = 0;flag = 1;
    for j=1:num
        if norm(line_points(i,:)-points2(j,:))<distance
            distance = norm(line_points(i,:)-points2(j,:));
            n = j;flag = 0;
        end
    end
    if flag==0
%         plot(points2(n,2),points2(n,1),'*r'); %%
        line_points = [line_points;points2(n,:)];
        points2(n,:) = [-1000 -1000];
        i = i+1;
    else
        break;
    end
end
% plot(line_points(:,2),line_points(:,1),'*w');  %%

line_points = line_points(i,:); % now we have a "head", then start with it again
points2 = points;
for i=1:num
    if line_points==points2(i,:)
        points2(i,:) = [-1000 -1000];
    end
end
% plot(line_points(2),line_points(1),'*r');  %%
i = 1;
while i>0 % for every point i in line_points, find the closest point in the neighbor of dis
    distance = dis;
    n = 0;flag = 1;
    for j=1:num
        if norm(line_points(i,:)-points2(j,:))<distance
            distance = norm(line_points(i,:)-points2(j,:));
            n = j;flag = 0;
        end
    end
    if flag==0
%         plot(points2(n,2),points2(n,1),'*r'); %%
        line_points = [line_points;points2(n,:)];
        points2(n,:) = [-1000 -1000];
        i = i+1;
    else
        break;
    end
end

[num_line,~] = size(line_points);
for i=1:num_line % remove the line_points from points_unused
    j = 1;
    while j<=num
        if line_points(i,:)==points_unused(j,:)
            if j==1
                points_unused = points_unused(2:end,:);
            elseif j==num
                points_unused = points_unused(1:j-1,:);
            else
                points_unused = [points_unused(1:j-1,:);points_unused(j+1:end,:)];
            end
            [num,~] = size(points_unused);
            j = j-1;
        end
        j = j+1;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show_line(line_points)
% show line parts in random color
[num,~] = size(line_points);
hold on;
for i=1:num-1
    plot([line_points(i,2),line_points(i+1,2)],[line_points(i,1),line_points(i+1,1)],'Color',rand(1,3),'LineWidth',2);
end
hold off;
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
