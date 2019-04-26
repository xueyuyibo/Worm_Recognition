clear all;clc;close all;

omega_list = [];
for image_num=1:4
    image_num
    F1 = []; F2 = [];
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    for worm_num=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_num),'.mat']);
        F1 = [F1;feature1];
        F2 = [F2;feature1];
    end
%     scatter3(F(:,1),F(:,2),F(:,3),'.'); %%
%     figure;plot(F(:,4),F(:,5),'.k'); %%
    [num,~] = size(F1);
    F1_normed = F1;
    F2_normed = F1;
    temp1 = mean(F1);
    temp2 = mean(F2);
    for i=1:17
        F1_normed(:,i) = F1(:,i)/temp1(i);
        F2_normed(:,i) = F2(:,i)/temp2(i);
    end
    clear temp1 temp2 i;
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
                    omega = [omega4,omega5,omega1*ones(1,15)];
                    omegan = omega/norm(omega);
                    for i=1:num
                        for j=1:num
                            Adj(i,j) = min(calculate_dist(F1_normed(i,:),F1_normed(j,:),omegan),calculate_dist(F1_normed(i,:),F2_normed(j,:),omegan));
                        end
                    end
                    Adj_sort = sort(Adj,2);
                    min_dist = Adj_sort(:,2); % maybe this 2nd column can be 3rd or 4th
                    min_dist = sort(min_dist);
%                     dist = min(min_dist);
%                     dist = min_dist(M);
                    dist = mean(min_dist);
                    res = [res;[omegan(1),omegan(2),dist]];
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
omega_weight = [0.25, 0.25, 0.25, 0.25];
omega_star = omega_weight*omega_list;
clear image_num F1 F2 F1_normed F2_normed omega_list worm_num num Adj total_min omegav omegavv omegal omegall res omega1 omega4i omega5i omega4 omega5 omega omegan Adj_sort min_dist dist omega_list omega_weight;
save omega_star20.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calculate_dist(f1,f2,omega)
[~,num] = size(omega);
sum = 0;
for i=1:num
    sum = sum+omega(i)*(f1(i)-f2(i))^2;
end
dist = sqrt(sum);
end