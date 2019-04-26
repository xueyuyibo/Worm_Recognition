clear all;clc;close all;

for image_num=1:4
    load (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
    RED = [];
    GREEN = [];
    BLUE = [];
    MID_GB = [];
    NONE = []; % include dark and color_not_specified
    for worm_number=1:total_worms
        load (['output/good_worms/image_',num2str(image_num),'/data_',num2str(worm_number),'.mat']);
        if feature(1)>60 % devide into RED group
            RED = [RED;worm_number];
        elseif max(feature(1:3))<30 % devide into dark group
            NONE = [NONE;worm_number];
        elseif feature(3)<20 %devide into GREEN group
            GREEN = [GREEN;worm_number];
        else
            mid_GB = abs(feature(3)-0.7615*feature(2)-10.6);
            blue = abs(feature(3)-1.657*feature(2)-24.22);
            if min(mid_GB,blue)>10
                NONE = [NONE;worm_number];
            else
                if mid_GB<blue
                    MID_GB = [MID_GB;worm_number];
                else
                    BLUE = [BLUE;worm_number];
                end
            end
        end
    end
    clear mid_GB blue;
    save (['output/good_worms/image_',num2str(image_num),'/data_image.mat']);
end