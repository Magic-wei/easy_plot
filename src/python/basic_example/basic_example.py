#! /usr/bin/env python
# -*- coding: utf-8 -*-

'''
---------------------------------
 Basic Example
 Author: Wei Wang
 Date: 07/01/2019
---------------------------------
'''

import os
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import numpy as np

# parameter setting
fig_dpi = 100; # inches = pixels / dpi
figsize_inch = list(np.array([800, 600]) / fig_dpi)
save_enable = False
script_path = os.path.split(os.path.realpath(__file__))[0]
image_path = script_path


# customize style
# plt.style.use('ggplot')

# dynamic rc settings
mpl.rcParams['font.size'] = 18
# mpl.rcParams['font.family'] = 'sans'
mpl.rcParams['font.style'] = 'normal'
mpl.rc('axes', titlesize=18, labelsize=18)
mpl.rc('lines', linewidth=2.5, markersize=5)
mpl.rcParams['xtick.labelsize'] = 16
mpl.rcParams['ytick.labelsize'] = 16
# mpl.rcdefaults() # restore the standard matplotlib default settings

# customize color
gray = list(np.array([99, 99, 99]) / 255.0)

# plot
fig = plt.figure(num=1, figsize=figsize_inch, dpi=fig_dpi, frameon=False)
x1 = range(1,21)
y1 = np.random.uniform(0,1,len(x1))
coeffis = np.polyfit(x1, y1, 5)
p = np.poly1d(coeffis)
y1_fit = p(x1)

ax = fig.add_subplot(111)
line_1, = ax.plot(x1, y1, 'o', markerfacecolor='k', markeredgecolor='b', markersize=5, label='raw data')
line_2, = ax.plot(x1, y1_fit, linestyle='-', linewidth=2.5,	color='r', label='ploynomial fitting')

# range and ticks setting
x_min = np.min(x1)
x_max = np.max(x1)
y_min = np.min([np.min(y1), np.min(y1_fit)])
y_max = np.max([np.max(y1), np.max(y1_fit)])
rx = x_max - x_min
ry = y_max - y_min
scale = 8
x_min_scale = np.round(x_min - rx/scale)
x_max_scale = np.round(x_max + rx/scale)
y_min_scale = np.round(y_min - ry/scale)
y_max_scale = np.round(y_max + ry/scale)
ax.set_xlim(x_min_scale, x_max_scale)
ax.set_ylim(y_min_scale, y_max_scale)
plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

# legend setting
plt.xlabel('x')
plt.ylabel('y')
plt.title('Python Simple Plot #1')
plt.legend(handles=[line_1, line_2], loc='best', frameon=False, ncol=1)

# grid off
plt.grid(True, color=gray, alpha=0.3)

if save_enable:
    save_name = 'easy_plot_using_python'
    plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))

plt.show()