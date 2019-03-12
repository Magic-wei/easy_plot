%% Basic Examples
% Author: Wei Wang
% Date: 12/12/2018
% =======================================

close all; clear;
%% data generation, fitting and plotting
% original data
f1 = figure('Name','polynomial fitting');
x1 = 1:20;
y1 = rand(1, length(x1));
plot(x1, y1,'o',...
    'markerfacecolor','k',...
    'markersize',5)
hold on;

% polynomial curve fitting
p = polyfit(x1, y1, 5);

% curve plotting
rx = range(x1);
x1_fit = linspace(min(x1) - rx/100,max(x1) + rx/100,350);
y1_fit = polyval(p, x1_fit);
ry = range([y1_fit, y1]);
plot(x1_fit, y1_fit,...
                'LineStyle','-',...
                'LineWidth',2.5,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',5)

% range setting
x_min = min(x1)  - rx/100;
x_max = max(x1) + rx/100;
y_min = min([min(y1), min(y1_fit)] - ry/100);
y_max = max([max(y1), max(y1_fit)] - ry/100);
axis([x_min, x_max,y_min, y_max]);

% legend setting
lgd1 = legend('original data','polynomial fitting');
lgd1.Box = 'off';
lgd1.Orientation = 'horizontal'; % vertical (default) | horizontal
lgd1.Location = 'northoutside';  % north | northeast | northoutside | best

% axes setting, see "Axes Properties" in doc for more details
xlabel('{\it x}','FontName','times new roman',...
    'FontSize',18,...
    'Color','black');
ylabel('{\it y}','FontName','times new roman',...
    'FontSize',18,...
    'Color','black');

ax1 = f1.CurrentAxes; % get current axes handle, you can also use 'ax = gca'.
ax1.FontName = 'times new roman';
ax1.FontSize = 18;
ax1.Color = [239, 237, 245] / 255; % color of background 
set(ax1,'LineWidth',1.5); % you can also do settings like this.
set(ax1,'Box','off');
set(ax1,'BoxStyle','full'); % affect only 3-D views

set(ax1,'XAxisLocation','bottom'); % bottom (default) | top | origin
set(ax1,'YAxisLocation','left'); % left (default) | right | origin
ax1.TickDir = 'out'; % in (default) | out | both
ax1.XTick = [0, 5, 10, 15, 20]; % the same as xticks([0, 5, 10, 15, 20])
ax1.YTick = 0:0.2:1; % the same as yticks(0:0.2:1)

% grid
grid on;
set(ax1,'GridLineStyle','--');
set(ax1,'GridAlpha',0.3); % transparency setting

% set figure location on the screen,given left lower and right upper
% points's location.
set(f1,'Position',[100 100 650 450]);

%% More about legend and text
f2 = figure('Name','linear model with non-polynomial terms');
plot(rand(3));
lgd2 = legend('\it line 1','line 2','\fontname{宋体} 随机线段 Line 3');
lgd2.Title.String = 'My Legend Title';
lgd2.Title.FontSize = 12;

% change figure properties by user-defined function
SetFigureProperties(f2);

% text
text(1, 0.5, '\fontname{宋体} 这是宋体 \fontname{times new roman} and latex \it{\theta_e}',...
     'FontSize',18)

%% save figures to specific format
% for more infomation, search function "savefig" and "saveas" in matlab help documents.
save_enable = 1;
if save_enable == 1
   saveas(f1,'basic_example_using_matlab','epsc'); % .eps with color
   saveas(f2,'basic_example_using_matlab','svg'); % .svg
%   saveas(f1,'basic_example_using_matlab','emf'); % .emf, windows only, not for linux 
   savefig(f1, 'basic_example_using_matlab'); % save figure to Matlab FIG-file for further edit  
end
