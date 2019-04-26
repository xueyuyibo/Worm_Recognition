clear all;clc;close all;

omega_list = [0,0,0,0,0];
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
    Adj = zeros(num,num);
    total_min = 0;
    omegav=[0:0.05:5];
    omegavv=[0:0.05:5];
    omegal=length(omegav);
    omegall=length(omegavv);
    ab_list = [];
    judge = 0;
%     if image_num==1
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
                            Adj(i,j) = calculate_dist(F(i,:),F(j,:),omegan);
                        end
                    end
                    [Adj_sort,Adj_sort_idx] = sort(Adj,2);
                    min_dist = Adj_sort(:,2); % maybe this 2nd column can be 3rd or 4th
                    min_dist_idx1 = Adj_sort_idx(:,2); % maybe this 2nd column can be 3rd or 4th
                    [min_dist,min_dist_idx2] = sort(min_dist);
%                     dist = min(min_dist);
                    dist = min_dist(round(num*0.1));
                    a_now = min_dist_idx2(round(num*0.1)); 
                    b_now = min_dist_idx1(min_dist_idx2(round(num*0.1)));
                    if omega4i==1 && omega5i==1
                        ab_list = [a_now,b_now]; 
                    end
                    [ab_num,~] = size(ab_list);
                    for ab_num_i=1:ab_num
                        if abs(a_now-b_now)==abs(ab_list(ab_num_i,1)-ab_list(ab_num_i,2)) && a_now*b_now==ab_list(ab_num_i,1)*ab_list(ab_num_i,2)
                            judge = 1;
                            break;
                        end
                    end
                    if judge==1
                        [~,dim] = size(res);
                        temp1 = zeros(1,(ab_num_i-1)*3);
                        temp2 = zeros(1,(dim/3-ab_num_i)*3);
                        res = [res;[temp1,omegan(4),omegan(5),dist,temp2]];
                    else
                        [dim,~] = size(res);
                        temp = zeros(dim-1,3);
                        res = [res,[temp;omegan(4),omegan(5),dist]];
                        ab_list = [ab_list;[a_now,b_now]];
                    end
                    judge = 0;
                    if dist>total_min
                        total_min = dist;
                        omega_star = omegan;
                    end
                end
            end
        end
%     else
%         for omega1=max(0,omega_star(1)-0.2):0.05:min(1,omega_star(1)+0.2)
%             for omega4=max(0,omega_star(4)-0.2):0.05:min(1,omega_star(4)+0.2)
%                 for omega5=max(0,omega_star(4)-0.2):0.05:min(1,omega_star(4)+0.2)
%                     omega = [omega1,omega1,omega1,omega4,omega5];
%                     omegan=omega/norm(omega);
%                     for i=1:num
%                         for j=1:num
%                             Adj(i,j) = calculate_dist(F(i,:),F(j,:),omegan);
%                         end
%                     end
%                     Adj_sort = sort(Adj,2);
%                     min_dist = Adj_sort(:,2);
%                     min_dist = sort(min_dist);
%                     dist = min_dist(round(num*0.1));
%                     if dist>total_min
%                         total_min = dist;
%                         omega_star = omega;
%                     end
%                 end
%             end
%         end
%     end
    figure;hold on;
    [~,dim] = size(res);
    for i=0:(dim/3-1)
        scatter3(res(:,3*i+1),res(:,3*i+2),res(:,3*i+3),'.');
    end
    for i=1:num
        for j=1:num
            Adj(i,j) = calculate_dist(F(i,:),F(j,:),omega_star);
        end
    end
    Adj_sort = sort(Adj,2);
    min_dist = Adj_sort(:,2);
%     min_dist = max(0,mean(Adj,2));
    min_dist = sort(min_dist);
%     figure;plot(1:num,min_dist,'.k');
    omega_list = [omega_list;omega_star];
    image_num
end
omega_list = omega_list(2:end,:);
omega_star = mean(omega_list);
clear image_num F omega_list worm_num num Adj total_min omegav omegavv omegal omegall res omega1 omega4i omega5i omega4 omega5 omega omegan Adj_sort min_dist dist omega_list;
save omega_star.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calculate_dist(f1,f2,omega)
[~,num] = size(omega);
sum = 0;
for i=1:num
    sum = sum+omega(i)*(f1(i)-f2(i))^2;
end
dist = sqrt(sum);
end