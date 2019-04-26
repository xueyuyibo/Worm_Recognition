clear all;clc;close all;
load compare_between_images.mat

omega_list = [];
for image_num=1:4
    image_num
    F = [0 0 0 0 0];
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    for worm_num=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
        F = [F;feature];
    end
    F = F(2:end,:);
%     scatter3(F(:,1),F(:,2),F(:,3),'.'); %%
%     figure;plot(F(:,4),F(:,5),'.k'); %%
    [num,~] = size(F);
    F_normed = F;
    temp = mean(F);
    for i=1:5
        F_normed(:,i) = F(:,i)/temp(i);
    end
    clear temp i;
    Adj = zeros(num,num);
    total_min = 0;
    omegav=[0:0.1:5];
    omegavv=[0:0.1:5];
    omegal=length(omegav);
    omegall=length(omegavv);
% 	for M=1:num
        res = [];
        for omega1=1
%         omega1=0;
            for omega4i=1:omegal
                omega4i/omegal*100
                for omega5i=1:omegall
                    omega4=omegav(omega4i);
                    omega5=omegavv(omega5i);
                    omega = [omega1,omega1,omega1,omega4,omega5];
                    omegan = omega/norm(omega);
                    for i=1:num
                        for j=1:num
                            Adj(i,j) = calculate_dist(F_normed(i,:),F_normed(j,:),omegan);
                        end
                    end
                    Adj_sort = sort(Adj,2);
                    min_dist = Adj_sort(:,2); % maybe this 2nd column can be 3rd or 4th
                    min_dist = sort(min_dist);
%                     dist = min(min_dist);
%                     dist = min_dist(6);
                    dist = mean(min_dist);
                    res = [res;[omegan(4),omegan(5),dist]];
                    if dist>total_min
                        total_min = dist;
                        omega_star = omegan;
                    end
                end
            end
        end
        figure;scatter3(res(:,1),res(:,2),res(:,3),'.');
% 	end
    omega_list = [omega_list;omega_star];
end
omega_weight = [0.35, 0.15, 0.2, 0.3];
omega_star = omega_weight*omega_list;
clear image_num F F_normed omega_list worm_num num Adj total_min omegav omegavv omegal omegall res omega1 omega4i omega5i omega4 omega5 omega omegan Adj_sort min_dist dist omega_list omega_weight;
save omega_star5.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calculate_dist(f1,f2,omega)
[~,num] = size(omega);
sum = 0;
for i=1:num
    sum = sum+omega(i)*(f1(i)-f2(i))^2;
end
dist = sqrt(sum);
end