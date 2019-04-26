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
    omegav=[0:0.1:5];
    omegavv=[0:0.1:5];
    omegal=length(omegav);
    omegall=length(omegavv);
    for M=1:num
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
                    Adj_sort = sort(Adj,2);
                    min_dist = Adj_sort(:,2); % maybe this 2nd column can be 3rd or 4th
                    min_dist = sort(min_dist);
%                     dist = min(min_dist);
%                     dist = min_dist(round(num*0.1));
                    dist = min_dist(M);
                    res = [res;[omegan(4),omegan(5),dist]];
                    if dist>total_min
                        total_min = dist;
                        omega_star = omegan;
                    end
                end
            end
        end
        scatter3(res(:,1),res(:,2),res(:,3),'.');
        saveas(gcf,['output/image',num2str(image_num),'_',num2str(M),'.png'])
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