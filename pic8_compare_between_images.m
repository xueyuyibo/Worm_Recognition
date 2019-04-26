clear all;clc;close all;

name_matrix = [1 31 1;2 22 1;4 24 1;3 16 2;4 11 2;1 8 3;2 3 3;3 20 3;1 1 4;2 1 4;3 28 4;4 28 4;1 9 5;2 6 5;3 22 5;4 21 5;1 12 6;2 33 6;4 5 6;1 39 7;2 9 7;3 4 7;1 26 8;2 17 8;3 3 8;2 5 9;3 7 9;4 14 9];
[size_name,~] = size(name_matrix);
var_total = [0 0 0 0 0];
for i=1:9
    f = [];
    for j=1:size_name
        if name_matrix(j,3)==i
            load (['output/good_worms/image_',num2str(name_matrix(j,1)),'/data_',num2str(name_matrix(j,2)),'.mat']);
            f = [f;feature];
        end
    end
    [size_f,~] = size(f);
    var = [0 0 0 0 0];
    mean_f = mean(f,1);
    for j=1:size_f
        var = var+[(f(j,1)-mean_f(1))^2,(f(j,2)-mean_f(2))^2,(f(j,3)-mean_f(3))^2,(f(j,4)-mean_f(4))^2,(f(j,5)-mean_f(5))^2];
    end
    var_total = var_total+var;
    if i==1
        f1 = f;
    elseif i==2
        f2 = f;
    elseif i==3
        f3 = f;
    elseif i==4
        f4 = f;
    elseif i==5
        f5 = f;
    elseif i==6
        f6 = f;
    elseif i==7
        f7 = f;
    elseif i==8
        f8 = f;
    elseif i==9
        f9 = f;
    end
end
var_total = var_total./(1e+5);

save compare_between_images.mat