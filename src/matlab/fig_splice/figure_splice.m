%% Figure Splice
% Author: Wei Wang
% Date: 02/27/2019
% =======================================

clear; close all;
%% Image Import - Support format: png, jpg, bmp
imgtype = 'png';
image_path = fullfile(pwd,'..','..','..','images','fig_splice');
fig_import = dir(fullfile(image_path,['*.', imgtype]));
figure_num = length(fig_import); 

sum = 0;
for i = 1 : figure_num
    if strfind(fig_import(i).name, 'velocity')
        sum = sum + 1;
    end
end

fig_group = cell(sum, 1);
outfigure = cell(sum, 1);
cut = [0, 0, 0, 0]; % cutting out edges if existing white space
for i = 1:sum
    fig_group{i}(1).name = ['velocity', num2str(i),'.',imgtype];
    fig_group{i}(2).name = ['steering_angle', num2str(i),'.', imgtype];
    fig_group{i}(3).name = ['tracking_error', num2str(i),'.', imgtype];
    fig_group{i}(4).name = ['acceleration', num2str(i),'.', imgtype];
    outfigure{i} = spliceFigureFunc(image_path, fig_group{i}, 2, imgtype, cut);
    image(uint8(outfigure{i}));
    axis equal;
    axis off;
    imwrite(outfigure{i},fullfile(image_path, ['outfigure',num2str(i),'.',imgtype]));
end

disp('figure splicing complete!')

