clear all;clc;close all;
load omega_star5.mat
load compare_between_images.mat
omega = omega_star;

min_dist = [];
for image_num=1:4
    F = [];
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    for worm_number=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_number),'.mat']);
        F = [F;feature./var_total];
    end
    F_normed = F;
    mean_F = mean(F);
    clear i;
    for i=1:5
        F_normed(:,i) = F(:,i)/mean_F(i);
    end
    Adj = zeros(total_worms,total_worms);
    clear i j;
    for i=1:total_worms
        for j=1:total_worms
            Adj(i,j) = calculate_dist(F(i,:),F(j,:),omega);
        end
    end
    Adj_sort = sort(Adj,2);
    min_dist_hist = Adj_sort(:,2);
%     min_dist = [min_dist;min(min_dist_hist)];
    [min_dist_sort,index_min_dist] = sort(min_dist_hist,'descend');
    clear F F_normed worm_num Agj i j Adj_sort min_dist_hist worm_number;
    save (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
end
% dist_affinity = min(min_dist);
% clear min_dist;

load ('output/good_worms/image_1/data_image.mat');
total_image = 4;
Worm_List.name = zeros(total_worms,total_image); % given name
Worm_List.feature = cell(total_worms,total_image); % normed_feature
Worm_List.original_name = zeros(total_worms,total_image); % original name
Worm_List.repeat = zeros(total_worms,total_image); % if this worm's given name is repeated, this is 1, ow it's 0
for worm_number=1:total_worms
    load (['output/good_worms/image_1/data_',num2str(index_min_dist(worm_number)),'.mat']);
    Worm_List.name(worm_number,1) = index_min_dist(worm_number); % record worms' names
    Worm_List.feature{worm_number,1} = feature./mean_F;
    Worm_List.original_name(worm_number,1) = index_min_dist(worm_number);
end
worm_name_max = worm_number; % record the last worm's name

for image_number=2:total_image
    [name_num,~] = size(Worm_List.name);
    load (['output/good_worms/image_',num2str(image_number),'/data_image.mat']);
    if total_worms > name_num % if current the total_worms is larger than before
        Worm_List.name = [Worm_List.name;zeros(total_worms-name_num,4)];
        Worm_List.feature = [Worm_List.feature;cell(total_worms-name_num,4)];
        Worm_List.original_name = [Worm_List.original_name;zeros(total_worms-name_num,4)];
        Worm_List.repeat = [Worm_List.repeat;zeros(total_worms-name_num,4)];
    end
    
    for worm_number=1:round(total_worms*0.2)
        load (['output/good_worms/image_',num2str(image_number),'/data_',num2str(index_min_dist(worm_number)),'.mat']);
        n = 0; m = 0;
        used_name_list = [];
        for j=1:image_number-1
            for i=1:name_num
                f1 = Worm_List.feature{i,j};
                [~,num] = size(f1);
                if num > 0
                    f2 = feature./mean_F;
                    if calculate_dist(f1,f2,omega) < min_dist_sort(worm_number)
                        flag = 0;
                        [~,a] = size(used_name_list);
                        for b=1:a
                            if Worm_List.name(i,j)==used_name_list(b)
                               flag = 1; 
                            end
                        end
                        if flag==0
                            n = i;m=j; % record the "closest" worm in the current list
                            break;
                        end
                    end
                end
            end
        end
        if n > 0
            used_name_list = [used_name_list,Worm_List.name(n,m)];
            Worm_List.name(worm_number,image_number) = Worm_List.name(n,m);
            Worm_List.feature{worm_number,image_number} = feature./mean_F;
            Worm_List.original_name(worm_number,image_number) = index_min_dist(worm_number);
            Worm_List.repeat(worm_number,image_number) = 1;
            Worm_List.repeat(n,m) = 1;
        else
            Worm_List.name(worm_number,image_number) = worm_name_max+1; % name the current worm as a new name
            worm_name_max = worm_name_max+1; % record the last worm's name
            Worm_List.feature{worm_number,image_number} = feature./mean_F;
            Worm_List.original_name(worm_number,image_number) = index_min_dist(worm_number);
        end
    end
    
    for worm_number=(round(total_worms*0.2)+1):total_worms
        load (['output/good_worms/image_',num2str(image_number),'/data_',num2str(index_min_dist(worm_number)),'.mat']);
        Worm_List.name(worm_number,image_number) = worm_name_max+1; % name the current worm as a new name
        worm_name_max = worm_name_max+1; % record the last worm's name
        Worm_List.feature{worm_number,image_number} = feature./mean_F;
        Worm_List.original_name(worm_number,image_number) = index_min_dist(worm_number);
    end
end

save result_name_normedF5_between.mat

[name_num,~] = size(Worm_List.name);
for worm_name=1:worm_name_max
    same_num = 0;
    res = [];
    for image_number=1:total_image
        for i=1:name_num
            if Worm_List.name(i,image_number) == worm_name
                same_num = same_num+1;
                res = [res;[image_number,Worm_List.original_name(i,image_number)]];
            end
        end
    end
    if same_num>1
        fprintf('---------same group---------\n')
        for i=1:same_num
            fprintf([num2str(res(i,:)),'\n'])
        end
    end
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