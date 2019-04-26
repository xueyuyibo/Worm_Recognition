load weights_star.mat

figure(1);scatter3(fig(:,1),fig(:,2),fig(:,5),'.b');saveas(gcf,'color_area.png');
figure(2);scatter3(fig(:,2),fig(:,3),fig(:,5),'.b');saveas(gcf,'area_length.png');
figure(3);scatter3(fig(:,3),fig(:,4),fig(:,5),'.b');saveas(gcf,'length_omega.png');
figure(4);scatter3(fig(:,1),fig(:,3),fig(:,5),'.b');saveas(gcf,'color_length.png');
figure(5);scatter3(fig(:,1),fig(:,4),fig(:,5),'.b');saveas(gcf,'color_omega.png');
figure(6);scatter3(fig(:,2),fig(:,4),fig(:,5),'.b');saveas(gcf,'area_omega.png');
