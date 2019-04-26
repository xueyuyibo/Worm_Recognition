clear all;clc;close all;
load omega_star.mat
% color_weight = 0.1*ones(1,15);
% omega = [2,2,2,1.2,0.8,0.8,color_weight]; % weights of dist: R,G,B,area,line_points_num,boundary_points_num,5 part of color distribution
% omega = [0.565,0.565,0.565,0.185,0.09];
omega = omega_star;

min_dist = 0;
for image_num=1:4
    F = [0 0 0 0 0];
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    for worm_num=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
        F = [F;feature];
    end
    F = F(2:end,:);
    [num,~] = size(F);
    Adj = zeros(num,num);
    for i=1:num
        for j=1:num
            Adj(i,j) = calculate_dist(F(i,:),F(j,:),omega);
        end
    end
    Adj_sort = sort(Adj,2);
    min_dist_hist = Adj_sort(:,2);
    min_dist = [min_dist;min(min_dist_hist)];
end
min_dist = min_dist(2:end,:);
dist_affinity = min(min_dist);

% dist_affinity = 425; % defination of the closest dist
load ('output/good_worms/image_1/data_image.mat');
total_image = 4;
Worm_List.name = zeros(total_worms,4);
Worm_List.vec_area = cell(total_worms,4);
Worm_List.feature = cell(total_worms,4);
Worm_List.worm = cell(total_worms,4);
for worm_num=1:total_worms
    load (['output/good_worms/image_1/data_',num2str(worm_num),'.mat']);
    Worm_List.name(worm_num,1) = worm_num; % record worms' names from 1
    Worm_List.vec_area{worm_num,1} = connected_area.PixelIdxList{1};
    Worm_List.feature{worm_num,1} = feature;
    Worm_List.worm{worm_num,1} = worm_full;
end
worm_name_max = worm_num; % record the last worm's name

for image_number=2:total_image
    [name_num,~] = size(Worm_List.name);
    load (['output/good_worms/image_',num2str(image_number),'/data_image.mat']);
    if total_worms > name_num % if current the total_worms is larger than before
        Worm_List.name = [Worm_List.name;zeros(total_worms-name_num,4)];
        Worm_List.vec_area = [Worm_List.vec_area;cell(total_worms-name_num,4)];
        Worm_List.feature = [Worm_List.feature;cell(total_worms-name_num,4)];
        Worm_List.worm = [Worm_List.worm;cell(total_worms-name_num,4)];
    elseif total_worms == 0
        break;
    end
    for worm_num=1:total_worms
        load (['output/good_worms/image_',num2str(image_number),'/data_',num2str(worm_num),'.mat']);
        for j=1:image_number-1
            dist = 10000000;
            for i=1:name_num
                f1 = Worm_List.feature{i,j};
                [~,num] = size(f1);
                if num > 0
                    f2 = feature;
                    if dist > calculate_dist(f1,f2,omega)
                        dist = calculate_dist(f1,f2,omega);
                        n = i;m=j; % record the "closest" worm in the current list
                    end
                end
            end
        end
        if dist < dist_affinity % if the closest worm is closed enough, name the current worm as this closest one's
            Worm_List.name(worm_num,image_number) = Worm_List.name(n,m);
            Worm_List.vec_area{worm_num,image_number} = connected_area.PixelIdxList{1};
            Worm_List.feature{worm_num,image_number} = feature;
            Worm_List.worm{worm_num,image_number} = worm_full;
        else
            Worm_List.name(worm_num,image_number) = worm_name_max+1; % name the current worm as a new name
            worm_name_max = worm_name_max+1; % record the last worm's name
            Worm_List.vec_area{worm_num,image_number} = connected_area.PixelIdxList{1};
            Worm_List.feature{worm_num,image_number} = feature;
            Worm_List.worm{worm_num,image_number} = worm_full;
        end
    end
end

[name_num,~] = size(Worm_List.name);
for worm_name=1:worm_name_max
    figure('units', 'pixels', 'innerposition', [0 0 1500 1100]);
    for image_number=1:total_image
        load (['output/good_worms/image_',num2str(image_number),'/data_image.mat']);
        subplot(2,2,image_number);
        imshow(A);title(['image ',num2str(image_number)]);
        hold on;
        for i=1:name_num
            if Worm_List.name(i,image_number) == worm_name
                cor_boundary = get_boundary(Worm_List.worm{i,image_number});
                plot(cor_boundary(:,2),cor_boundary(:,1),'Color',[1,1,1],'LineWidth',2);
            end
        end
    end
    saveas(gcf,['output/worm_name_',num2str(worm_name),'.png']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calculate_dist(f1,f2,omega)
[~,num] = size(omega);
sum = 0;
for i=1:num
    sum = sum+omega(i)*(f1(i)-f2(i))^2;
end
dist = sqrt(sum);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cor_boundary = get_boundary(worm)
B = bwboundaries(worm); % get a (p*1)cell array of boundary points
[numbcell,~] = size(B);
cor_boundary = [0 0];
for i=1:numbcell
    [numbarray,~] = size(B{i});
    if numbarray>20 % if the number of boundary points are larger than 20, which means it's a big inner area
        cor_boundary = [cor_boundary;B{i}]; % link different boundaries together
    end
end
cor_boundary = cor_boundary(2:end,:);
end