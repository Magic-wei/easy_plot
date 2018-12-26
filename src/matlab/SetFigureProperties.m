% Function SetFigureProperties
% Author: Wei Wang
% Date: 12/12/2018
% =======================================

function SetFigureProperties(f)
% INPUT: figure handle

ax = f.CurrentAxes; % get current axes handle.
ax.FontName = 'times new roman';
ax.FontSize = 18;
% ax.Color = [239, 237, 245] / 255; % color of background
set(ax,'LineWidth',1.5); % you can also do settings like this.
set(ax,'Box','off');
set(ax,'BoxStyle','full'); % affect only 3-D views

set(ax,'XAxisLocation','bottom'); % bottom (default) | top | origin
set(ax,'YAxisLocation','left'); % left (default) | right | origin
ax.TickDir = 'out'; % in (default) | out | both

% grid
grid on;
set(ax,'GridLineStyle','--');
set(ax,'GridAlpha',0.3); % transparency setting

% set figure location on the screen, given left lower and right upper
% points's location.
set(f,'Position',[100 100 650 450]);
