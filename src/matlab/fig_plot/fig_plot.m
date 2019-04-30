%% Figure Plot
% Author: Wei Wang
% Date: 02/27/2019
% =======================================

clear; close all;
%% parameter configuration
save_enable_path = 0;
save_enable_str = 0;
save_enable_err = 0;
save_enable_vec = 0;
save_enable_acc = 0;
image_path = pwd;
global_path_file = fullfile(pwd,'..','..','..','data','fig_plot','global_path.txt');
state_name = fullfile(pwd,'..','..','..','data','fig_plot','*','state.csv');

%% Data Import
global_path = load(global_path_file);
file = dir(state_name);
data = cell(length(file), 1);
vehicle_path = cell(length(file), 1);
index_size = zeros(length(file), 1);
record_size = zeros(length(file), 1);
for i=1:length(file)
    file_name = fullfile(file(i).folder, file(i).name);
    ds = tabularTextDatastore(file_name,'TreatAsMissing','NA');
%     preview(ds) % return the first 7 (default) records.
    data{i} = read(ds);
    [record_size(i), index_size(i)] = size(data{i});
    disp([file(i).folder,' --> ','data{',num2str(i),'}']);
    vehicle_path{i} = [data{i}.position_x, data{i}.position_y];
end

%% calculation cost
for i=1:length(file)
    if ismember('time_cost', data{i}.Properties.VariableNames)
        disp(['data{',num2str(i),'} ','average time cost is ',num2str(mean(data{i}.time_cost)),' s'])
        disp(['data{',num2str(i),'} ','maximum time cost is ',num2str(max(data{i}.time_cost)),' s'])
    end
end

%% path_comparison
f_path = figure('Name','frenet-based MPC path tracking comparison');
plot(global_path(:,2),global_path(:,3),...
                'LineStyle','-',...
                'LineWidth',1.5,... 
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5),hold on;
legend_str = cell(1,length(file));
legend_str{1} = 'reference path';
for i = 1:length(file)
plot(vehicle_path{i}(:,1),vehicle_path{i}(:,2),...
                'LineStyle','-.',...
                'LineWidth',1.5), hold on;
legend_str{1 + i} = ['vehicle path ', num2str(i)];
end

% range setting
axis equal; hold off;
matrix = global_path(:,2:3);
for i = 1:length(vehicle_path)
    maxtrix = [matrix;vehicle_path{i}];
end
max_value = max(matrix,[],1);
min_value = min(matrix,[],1);
x_max = max_value(1);
x_min = min_value(1);
y_max = max_value(2);
y_min = min_value(2);
rx = range([x_min, x_max]);
ry = range([y_min, y_max]);
scale = 8;
x_min_scale = round(x_min - rx/scale);
x_max_scale = round(x_max + rx/scale);
y_min_scale = round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale);
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
xticks(linspace(x_min_scale, x_max_scale, 5));
yticks(linspace(y_min_scale, y_max_scale, 5));

xlabel('x / m','FontName','times new roman',...
    'FontSize',18);
ylabel('y / m','FontName','times new roman',...
    'FontSize',18);

lgd = legend(legend_str);
lgd.Box = 'off';

ax1 = gca;
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
% ax1.Color = [239, 237, 245] / 255;
set(ax1,'LineWidth',1.2);
set(ax1,'Box','on');
ax1.TickDir = 'out';
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3);
% grid on;

% set figure location on the screen,given left lower and right upper
% points's location.
set(f_path,'Position',[100 100 650 450]);

size_n = length(global_path);
text(global_path(1, 2) + 1, global_path(1, 3) + 1,...
    'start', 'FontSize',18)
text(global_path(size_n, 2) - 10, global_path(size_n, 3) + 10,...
    'end', 'FontSize',18)

if save_enable_path == 1
   saveas(f_path, fullfile(image_path, 'path_comparison.svg'));
   saveas(f_path, fullfile(image_path, 'path_comparison.png'));   
   savefig(f_path, fullfile(image_path, 'path_comparison'));
end

%%  Steering angle
f_str = cell(length(file), 1);
for i=1:length(file)
num = record_size(i);
des_delta = data{i}.des_steering_angle;
cur_delta = data{i}.cur_steering_angle;
if max(des_delta) < 0.6
    des_delta = des_delta * 180 / pi;
    cur_delta = cur_delta * 180 / pi;
end
time = data{i}.time_cur;
f_str{i} = figure('Name','steering angle vs. time');
set(f_str{i},'Position',[100 100 650 450]);

plot(time,des_delta,...
                'LineStyle','-',...
                'LineWidth',1.5,...
                'Color','r',...% [189, 189, 189] / 255,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;
plot(time,cur_delta,...
                'LineStyle','-.',...
                'LineWidth',1.5,...
                'Color','b',...% [0, 0, 0] / 255,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;

matrix = [des_delta; cur_delta];
x_max = max(time);
x_min = min(time);
y_max = max(matrix);
y_min = min(matrix);
rx = range([x_min, x_max]);
ry = range([y_min, y_max]);
scale = 20;
x_min_scale = x_min; %round(x_min - rx/scale);
x_max_scale = round(x_max + rx/scale);
y_min_scale = round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale);
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
xticks(linspace(x_min_scale, x_max_scale, 5));
yticks(linspace(y_min_scale, y_max_scale, 5));

lgd = legend('desired steering angle','actual steering angle');
lgd.Box = 'off';
lgd.Orientation = 'horizontal'; % vertical (default) | horizontal
lgd.Location = 'northoutside'; 

xlabel('t / s','FontName','times new roman',...
    'FontSize',18);
ylabel('\delta / deg','FontName','times new roman',...
    'FontSize',18);

ax1 = gca;
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
% ax1.Color = [239, 237, 245] / 255;
set(ax1,'LineWidth',1.2);
set(ax1,'Box','on');
ax1.TickDir = 'out';
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3);
% grid on;

% set figure location on the screen,given left lower and right upper
% points's location.
set(f_str{i},'Position',[100 100 650 450]);

% save_enable_str = 1;
if save_enable_str == 1
   saveas(f_str{i},fullfile(image_path, ['steering_angle',num2str(i),'.svg']));
   saveas(f_str{i},fullfile(image_path, ['steering_angle',num2str(i),'.png']));
   savefig(f_str{i}, fullfile(image_path, ['steering_angle',num2str(i)]));
end
end

%% tracking error
f_err = cell(length(file), 1);
for i = 1:length(file)
num = record_size(i);
lateral_error = data{i}.lateral_error;
heading_error = data{i}.heading_error * 180 /pi;
disp(['data{',num2str(i),'} ','average lateral error is ',num2str(mean(abs(lateral_error))),' m'])
disp(['data{',num2str(i),'} ','maximum lateral error is ',num2str(max(abs(lateral_error))),' m'])
disp(['data{',num2str(i),'} ','average heading error is ',num2str(mean(abs(heading_error))),' deg'])
disp(['data{',num2str(i),'} ','maximum heading error is ',num2str(max(abs(heading_error))),' deg'])

start_iter = 1;
end_iter = num;
time = data{i}.time_cur;
f_err{i} = figure('Name','tracking error vs. time');

yyaxis left; % the first y axis on the left
plot(time,lateral_error,...
                'LineStyle','-',...
                'LineWidth',1.5,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;
ylabel('lateral error \it{e_y} / m','FontName','times new roman',...
    'FontSize',18);
y_max = max(lateral_error);
y_min = min(lateral_error);
ry = range([y_min, y_max]);
scale = 20;
x_min_scale = x_min;
x_max_scale = round(x_max + rx/scale);
y_min_scale = round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale);
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
yticks(linspace(y_min_scale, y_max_scale, 5));

yyaxis right;  % the second y axis on the right
plot(time,heading_error,...
                'LineStyle','-.',...
                'LineWidth',1.5,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;

x_max = max(time);
x_min = min(time);
y_max = max(heading_error);
y_min = min(heading_error);
rx = range([x_min, x_max]);
ry = range([y_min, y_max]);
scale = 20;
x_min_scale = x_min;
x_max_scale = round(x_max + rx/scale);
y_min_scale = round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale);
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
xticks(linspace(x_min_scale, x_max_scale, 5));
yticks(linspace(y_min_scale, y_max_scale, 5));

xlabel('\it{t} / s','FontName','times new roman',...
    'FontSize',18);
ylabel('heading error \it{\phi} / deg','FontName','times new roman',...
    'FontSize',18);

ax1 = gca;
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
% ax1.Color = [239, 237, 245] / 255;
set(ax1,'LineWidth',1.2);
set(ax1,'Box','on');
ax1.TickDir = 'out';
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3);
% grid on;

% set figure location on the screen,given left lower and right upper
% points's location.
set(f_err{i},'Position',[100 100 650 450]);

if save_enable_err == 1
  saveas(f_err{i},fullfile(image_path, ['tracking_error',num2str(i),'.svg']));
  saveas(f_err{i},fullfile(image_path, ['tracking_error',num2str(i),'.png']));   
  savefig(f_err{i}, fullfile(image_path, ['tracking_error',num2str(i)]));
end
end

%% velocity
f_vec = cell(length(file), 1);
for i=1:length(file)
num = record_size(i);
linear_v_x = data{i}.linear_v_x;
time = data{i}.time_cur;
f_vec{i} = figure('Name','velocity vs. time');

plot(time,linear_v_x,...
                'LineStyle','-',...
                'LineWidth',1.5,...
                'Color','r',...% [189, 189, 189] / 255,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;

x_max = max(time);
x_min = min(time);
y_max = max(linear_v_x);
y_min = min(linear_v_x);
rx = range([x_min, x_max]);
ry = range([y_min, y_max]);
scale = 20;
x_min_scale = x_min; %round(x_min - rx/scale);
x_max_scale = round(x_max + rx/scale);
y_min_scale = y_min; %round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale) + 1;
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
xticks(linspace(x_min_scale, x_max_scale, 5));
yticks(linspace(y_min_scale, y_max_scale, 5));

xlabel('\it{t} / s','FontName','times new roman',...
    'FontSize',18);
ylabel('longitudinal velocity \it{v} / (m/s)','FontName','times new roman',...
    'FontSize',18);

ax1 = gca; % get current axes handle, you can also use 'ax = gca'.
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
% ax1.Color = [239, 237, 245] / 255;
set(ax1,'LineWidth',1.2); % you can also do settings like this.
set(ax1,'Box','on');
ax1.TickDir = 'out';
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3);
% grid on;

% set figure location on the screen,given left lower and right upper
% points's location.
set(f_vec{i},'Position',[100 100 650 450]);

if save_enable_vec == 1
   saveas(f_vec{i},fullfile(image_path, ['velocity',num2str(i),'.svg']));
   saveas(f_vec{i},fullfile(image_path, ['velocity',num2str(i),'.png']));
   savefig(f_vec{i}, fullfile(image_path, ['velocity',num2str(i)]));
end
end

%% acceleration
f_acc = cell(length(file), 1);
for i=1:length(file)
num = record_size(i);
linear_acc_y = data{i}.linear_acc_y;
time = data{i}.time_cur;
f_acc{i} = figure('Name','acceleration vs. time');

plot(time,linear_acc_y,...
                'LineStyle','-',...
                'LineWidth',1.5,...
                'Color','r',...% [189, 189, 189] / 255,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5), hold on;

x_max = max(time);
x_min = min(time);
y_max = max(linear_acc_y);
y_min = min(linear_acc_y);
rx = range([x_min, x_max]);
ry = range([y_min, y_max]);
scale = 20;
x_min_scale = x_min; %round(x_min - rx/scale);
x_max_scale = round(x_max + rx/scale);
y_min_scale = round(y_min - ry/scale);
y_max_scale = round(y_max + ry/scale);
axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale]);
xticks(linspace(x_min_scale, x_max_scale, 5));
yticks(linspace(y_min_scale, y_max_scale, 5));

% lgd = legend('desired steering angle','actual steering angle');
% lgd.Box = 'off';
% lgd.Orientation = 'horizontal'; % vertical (default) | horizontal
% lgd.Location = 'north'; 

xlabel('\it{t} / s','FontName','times new roman',...
    'FontSize',18);
ylabel('lateral acceleration \it{a_y} / (m/s^2)','FontName','times new roman',...
    'FontSize',18);

ax1 = gca; % get current axes handle, you can also use 'ax = gca'.
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
% ax1.Color = [239, 237, 245] / 255;
set(ax1,'LineWidth',1.2); % you can also do settings like this.
set(ax1,'Box','on');
ax1.TickDir = 'out';
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3);
% grid on;

% set figure location on the screen,given left lower and right upper
% points's location.
set(f_acc{i},'Position',[100 100 650 450]);

if save_enable_acc == 1
   saveas(f_acc{i},fullfile(image_path, ['acceleration',num2str(i),'.svg']));
   saveas(f_acc{i},fullfile(image_path, ['acceleration',num2str(i),'.png']));
   savefig(f_acc{i}, fullfile(image_path, ['acceleration',num2str(i)]));
end
end
