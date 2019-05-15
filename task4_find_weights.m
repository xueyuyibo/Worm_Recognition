clear all;clc;close all;
% color_num image_num threshold idex name
load name_list.mat
% train = [color=0:1 area=0:1 length=0:1 omega=0:0.1:10]
% name image_num idex threshold

list_num = size(name_list,1);
name_max = max(name_list(:,5));
figure(1);hold on;
figure(2);hold on;
figure(3);hold on;
color_distr = [1 1 0;1 0 1;0 0 0;0 1 1;0 0 1;0 1 0;1 0 0;0.5 0.5 0.5;0.5 0.5 0;0.5 0 0.5;0.5 0 0;0 0.5 0.5;0 0.5 0;0 0 0.5;0.25 0.25 0.25;0.25 0.25 0;0.25 0 0.25;0.25 0 0;0 0.25 0.25;0 0.25 0;0 0 0.25;0.1 0 0.5;0.5 0 0.1];
for name=[1:6,8,11:name_max]
    pt = [];
    for i=1:list_num
        if (name_list(i,5)==name)
            load (['output/color_1/image_',num2str(name_list(i,2)),'/threshold_',num2str(name_list(i,3)),'/data_',num2str(name_list(i,4)),'.mat'],'feature');
            pt = [pt;[name_list(i,3),feature]];
        end
    end
    figure(1);plot(pt(:,1),pt(:,2),'Color',color_distr(name,:),'LineWidth',2);axis([0.1 0.2 20 100]);
    figure(2);plot(pt(:,1),pt(:,5),'Color',color_distr(name,:),'LineWidth',2);
    figure(3);plot(pt(:,1),pt(:,6),'Color',color_distr(name,:),'LineWidth',2);
end
close all;

truth_R = [1 1 1 0.1;2 1 2 0.1;3 2 1 0.1;1 2 2 0.1;4 2 3 0.1;5 2 4 0.1;1 3 1 0.1;4 3 2 0.1;3 3 3 0.13;1 4 1 0.1;4 4 2 0.1];

name_max_R = max(truth_R(:,1));
[size_R,~] = size(truth_R);
[name_max,~] = size(name_list);
for name=1:name_max_R
    res{name} = [];
    for i=1:size_R
        for j=1:name_max
            if truth_R(i,1)==name && name_list(j,2)==truth_R(i,2) && name_list(j,3)==truth_R(i,4) && name_list(j,4)==truth_R(i,3)
                res{name} = [res{name};name_list(j,5)];
            end
        end
    end
end

% train = [a=0:0.05:1 b=0:0.05:1 c=0:0.05:1 omega=0:0.1:10]
dist = -Inf;
fig = [];
% for a=0.001:0.2:1
%     for b=0.001:0.2:1
%         for c=0.001:0.2:1
%             for omega=0:10:50
%                 fprintf(['a=',num2str(a),'   b=',num2str(b),'   c=',num2str(c),'   omega=',num2str(omega),'\n']);
%                 distance = -sum_distance(res,omega,name_list,name_max_R,a/norm([a,b,c]),b/norm([a,b,c]),c/norm([a,b,c]),name_max);
%                 fig = [fig;[a/norm([a,b,c]),b/norm([a,b,c]),c/norm([a,b,c]),omega,distance]];
%                 if distance> dist
%                     dist = distance;
%                     a_star = a/norm([a,b,c]);
%                     b_star = b/norm([a,b,c]);
%                     c_star = c/norm([a,b,c]);
%                 end
%             end
%         end
%     end
% end
load weights_star.mat

figure(1);scatter3(fig(:,1),fig(:,2),fig(:,5),'.b');saveas(gcf,'color_area.png');
figure(2);scatter3(fig(:,2),fig(:,3),fig(:,5),'.b');saveas(gcf,'area_length.png');
figure(3);scatter3(fig(:,3),fig(:,4),fig(:,5),'.b');saveas(gcf,'length_omega.png');
figure(4);scatter3(fig(:,1),fig(:,3),fig(:,5),'.b');saveas(gcf,'color_length.png');
figure(5);scatter3(fig(:,1),fig(:,4),fig(:,5),'.b');saveas(gcf,'color_omega.png');
figure(6);scatter3(fig(:,2),fig(:,4),fig(:,5),'.b');saveas(gcf,'area_omega.png');

% save weights_star.mat a_star b_star c_star dist fig;

function distance = sum_distance(res,omega,name_list,name_max_R,a,b,c,number)
distance = 0;
for name=1:name_max_R
    [num,~] = size(res{name});
    for i=1:num
        for j=1:num
            if i~=j
                distance = distance+calculate_distance(res{name}(i),res{name}(j),omega,name_list,a,b,c,number);
            end
        end
    end
end
end

function distance = calculate_distance(name_A,name_B,omega,name_list,a,b,c,num)

resA_1 = [];
resA_2 = [];
resA_3 = [];
for i=1:num
    if name_list(i,5)==name_A
        load (['output/color_',num2str(name_list(i,1)),'/image_',num2str(name_list(i,2)),'/threshold_',num2str(name_list(i,3)),'/data_',num2str(name_list(i,4)),'.mat'],'feature');
        resA_1 = [resA_1;[feature(name_list(i,1)),name_list(i,3)]];
        resA_2 = [resA_2;[feature(4),name_list(i,3)]];
        resA_3 = [resA_3;[feature(5),name_list(i,3)]];
    end
end

resB_1 = [];
resB_2 = [];
resB_3 = [];
for i=1:num
    if name_list(i,5)==name_B
        load (['output/color_',num2str(name_list(i,1)),'/image_',num2str(name_list(i,2)),'/threshold_',num2str(name_list(i,3)),'/data_',num2str(name_list(i,4)),'.mat'],'feature');
        resB_1 = [resB_1;[feature(name_list(i,1)),name_list(i,3)]];
        resB_2 = [resB_2;[feature(4),name_list(i,3)]];
        resB_3 = [resB_3;[feature(5),name_list(i,3)]];
    end
end
max_1 = max(min(resA_1(:,2)),min(resB_1(:,2)));
max_2 = max(min(resA_2(:,2)),min(resB_2(:,2)));
max_3 = max(min(resA_3(:,2)),min(resB_3(:,2)));
min_1 = min(max(resA_1(:,2)),max(resB_1(:,2)));
min_2 = min(max(resA_2(:,2)),max(resB_2(:,2)));
min_3 = min(max(resA_3(:,2)),max(resB_3(:,2)));
[sizeA,~] = size(resA_1);
[sizeB,~] = size(resB_1);
distance1 = 0;
weight = exp(omega*(max_1:0.01:min_1));
sum_weight = sum(weight);
for threshold=max_1:0.01:min_1
    for i=1:sizeA
        if resA_1(i,2)==threshold
            for j=1:sizeB
                if resB_1(j,2)==threshold
                    distance1 = distance1+(exp(omega*threshold)/sum_weight)*((resA_1(i,1)-resB_1(j,1))^2);
                end
            end
        end
    end
end
[sizeA,~] = size(resA_2);
[sizeB,~] = size(resB_2);
distance2 = 0;
weight = exp(omega*(max_2:0.01:min_2));
sum_weight = sum(weight);
for threshold=max_2:0.01:min_2
    for i=1:sizeA
        if resA_2(i,2)==threshold
            for j=1:sizeB
                if resB_2(j,2)==threshold
                    distance2 = distance2+(exp(omega*threshold)/sum_weight)*((resA_2(i,1)-resB_2(j,1))^2);
                end
            end
        end
    end
end
[sizeA,~] = size(resA_3);
[sizeB,~] = size(resB_3);
distance3 = 0;
weight = exp(omega*(max_3:0.01:min_3));
sum_weight = sum(weight);
for threshold=max_3:0.01:min_3
    for i=1:sizeA
        if resA_3(i,2)==threshold
            for j=1:sizeB
                if resB_3(j,2)==threshold
                    distance3 = distance3+(exp(omega*threshold)/sum_weight)*((resA_3(i,1)-resB_3(j,1))^2);
                end
            end
        end
    end
end
distance = distance1*a+distance2*b+distance3*c;
end
