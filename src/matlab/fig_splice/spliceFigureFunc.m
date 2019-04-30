% Function SetFigureProperties
% Author: Wei Wang
% Date: 02/27/2019
% =======================================

function outfigure = spliceFigureFunc(image_path, fig_group, column_size, imgtype, cut)

figure_num = length(fig_group);
if mod(figure_num, column_size) ~= 0
    error('mod(figure_num, column_size) ~= 0!');
    return
end

% find the best image size
size_matrix = zeros(figure_num, 3);
for i = 1:figure_num
   tmp_image = imread(fullfile(image_path,fig_group(i).name), imgtype);
   size_matrix(i,:) = size(tmp_image);
end
result = tabulate(size_matrix(:,1)*0.01);
label = find(max(result(:,2)) == result(:,2));
image_size = size_matrix(label(1), :);
disp(image_size)

for i = 1:figure_num
   tmp_image = imread(fullfile(image_path,fig_group(i).name), imgtype);
   disp([fig_group(i).name,': ',num2str(size(tmp_image))])
   if size(tmp_image, 1) ~= image_size(1)
       new_image = imresize(tmp_image, [image_size(1), image_size(2)]);
       figures(:,:,:,i) = new_image;
   else
       figures(:,:,:,i) = tmp_image;
   end
%    figures(:,:,:,i) = imread(fullfile(image_path,fig_group(i).name), imgtype);
   
end

figures = figures(cut(1)+1:end-cut(2), cut(3)+1: end-cut(4),:,:); % cutting out edges

outfigure = [];
row_figure = [];

for i= 1:figure_num
    if mod(i, column_size) == 0
        row_figure = [row_figure, figures(:,:,:,i)];
        outfigure = [outfigure; row_figure];
        row_figure = [];
    else
        row_figure = [row_figure; figures(:,:,:,i)];
    end
end

