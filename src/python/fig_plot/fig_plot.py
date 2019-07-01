#! /usr/bin/env python
# -*- coding: utf-8 -*-

'''
---------------------------------
 Figure Plot
 Author: Wei Wang
 Date: 07/01/2019
---------------------------------
'''

import os
import glob
import pandas as pd
import numpy as np # for easy generation of arrays
import matplotlib.pyplot as plt
import matplotlib as mpl

# parameter setting
script_path = os.path.split(os.path.realpath(__file__))[0] # os.getcwd() returns the path in your terminal
(base_path, script_dir) = os.path.split(script_path)
search_path = os.path.join(script_path, '..','..','..','data', 'fig_plot')
filename = os.path.join('*', 'state.csv')
global_path_file = os.path.join(script_path,'..','..','..','data','fig_plot','global_path.txt')
# print('search_path', search_path)
# print('global_path_file', global_path_file)
save_enable = False
image_path = script_path
fig_dpi = 100; # inches = pixels / dpi
figsize_inch = list(np.array([800, 600]) / fig_dpi)

# dynamic rc settings
mpl.rcParams['font.size'] = 18
# mpl.rcParams['font.family'] = 'sans'
mpl.rcParams['font.style'] = 'normal'
mpl.rc('axes', titlesize=18, labelsize=18)
mpl.rc('lines', linewidth=2.5, markersize=5)
mpl.rcParams['xtick.labelsize'] = 16
mpl.rcParams['ytick.labelsize'] = 16

# customize color
green_lv1 = list(np.array([229, 245, 249]) / 255.0)
green_lv2 = list(np.array([153, 216, 201]) / 255.0)
green_lv3 = list(np.array([44, 162, 95]) / 255.0)
gray = list(np.array([99, 99, 99]) / 255.0)

# import data
## read global path from txt file
global_path = pd.read_csv(global_path_file, delimiter='      ', header=None)
global_path.columns = ["point_id", "position_x", "position_y"]
# print(global_path.head())

## read vehicle states from csv files
dataset = []
file_list = glob.glob(os.path.join(search_path, filename))
# print('file_list has:', file_list)
print(os.path.join(search_path, filename))
for file in file_list:
    raw_data = pd.read_csv(file)
    dataset.append(raw_data)
    print(file, '-> dataset[%d]' %(len(dataset)))

# path_comparison
fig = plt.figure(figsize=figsize_inch, dpi=fig_dpi, frameon=False)
ax = fig.add_subplot(111)
line_global, = ax.plot(global_path['position_x'], global_path['position_y'], 
	linestyle='-', color=gray, linewidth=1.5, label='global path')
lines = []
lines.append(line_global)
i = 0
for data in dataset:
    i += 1
    line_tmp, = ax.plot(data['position_x'], data['position_y'], 
    linestyle='--', linewidth=1.5, label='vehicle path # %d'%(i))
    lines.append(line_tmp)

plt.axis('equal')
ax.set_adjustable('box')
# range and ticks setting
x_min = np.min(global_path["position_x"])
x_max = np.max(global_path["position_x"])
y_min = np.min(global_path["position_y"])
y_max = np.max(global_path["position_y"])
rx = x_max - x_min
ry = y_max - y_min
scale = 10
resolution = 10
x_min_scale = np.round((x_min - rx/scale)/resolution) * resolution
x_max_scale = np.round((x_max + rx/scale)/resolution) * resolution
y_min_scale = np.round((y_min - ry/scale)/resolution) * resolution
y_max_scale = np.round((y_max + ry/scale)/resolution) * resolution
# ax.set_xlim(x_min_scale, x_max_scale)
# ax.set_ylim(y_min_scale, y_max_scale)
ax.axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale])
plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

## legend setting
plt.xlabel('x')
plt.ylabel('y')
# plt.title('path comparison')
plt.legend(handles=lines, loc='best', frameon=False, ncol=1)

## grid
plt.grid(True, color=gray, alpha=0.3)

## save
if save_enable:
    save_name = 'path_comparison'
    # plt.savefig(os.path.join(script_path, '%s.svg'%(save_name)))
    plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))
    # plt.savefig(os.path.join(script_path, '%s.eps'%(save_name)))
    # plt.savefig(os.path.join(script_path, '%s.pdf'%(save_name)))

# steering angle
i = 0
for data in dataset:
    i += 1
    time_cur = data['time_cur']
    des_steering_angle = data['des_steering_angle']
    cur_steering_angle = data['cur_steering_angle']
    if max(des_steering_angle) < 0.6:
        des_steering_angle = des_steering_angle * 180 / np.pi;
        cur_steering_angle = cur_steering_angle * 180 / np.pi;

    fig = plt.figure(figsize=figsize_inch, dpi=fig_dpi, frameon=False)
    ax = fig.add_subplot(111)
    line_des, = ax.plot(time_cur, des_steering_angle, 
    	linestyle='-', color=green_lv2, label='desired steering angle')
    line_cur, = ax.plot(time_cur, cur_steering_angle, 
    	linestyle='--', color=green_lv3, label='actual steering angle')
    lines = [line_des, line_cur]

    # range and ticks setting
    x_min = np.min(time_cur)
    x_max = np.max(time_cur)
    y_min = np.min([np.min(des_steering_angle), np.min(cur_steering_angle)])
    y_max = np.max([np.max(des_steering_angle), np.max(cur_steering_angle)])
    rx = x_max - x_min
    ry = y_max - y_min
    scale = 10
    resolution = 1
    x_min_scale = x_min
    x_max_scale = np.round((x_max + rx/scale)/resolution) * resolution
    y_min_scale = np.round((y_min - ry/scale)/resolution) * resolution
    y_max_scale = np.round((y_max + ry/scale)/resolution) * resolution
    ax.axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale])
    plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
    plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

    ## legend setting
    plt.xlabel('time (s)')
    plt.ylabel('sterring angle (deg)')
    # plt.title('steering angle')
    plt.legend(loc='best', frameon=False, ncol=1)

    ## grid
    plt.grid(True, color=gray, alpha=0.3)

    ## save
    if save_enable:
        save_name = 'steering_angle_%d'%(i)
        # plt.savefig(os.path.join(script_path, '%s.svg'%(save_name)))
        plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.eps'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.pdf'%(save_name)))

# tracking error
i = 0
for data in dataset:
    i += 1
    time_cur = data['time_cur']
    lateral_error = data['lateral_error']
    heading_error = data['heading_error']

    fig = plt.figure(figsize=figsize_inch, dpi=fig_dpi, frameon=False)
    ax = fig.add_subplot(111)
    line_1, = ax.plot(time_cur, lateral_error, 
        linestyle='-', color=green_lv2, label='lateral error')

    # range and ticks setting
    y_min = np.min(lateral_error)
    y_max = np.max(lateral_error)
    ry = y_max - y_min
    scale = 10
    resolution = 1
    y_min_scale = np.round((y_min - ry/scale)/resolution) * resolution
    y_max_scale = np.round((y_max + ry/scale)/resolution) * resolution
    ax.set_ylim([y_min_scale, y_max_scale])
    plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

    ax2 = ax.twinx()
    line_2, = ax2.plot(time_cur, heading_error, 
        linestyle='--', color=green_lv3, label='heading error')
    # range and ticks setting
    x_min = np.min(time_cur)
    x_max = np.max(time_cur)
    y_min = np.min(heading_error)
    y_max = np.max(heading_error)
    rx = x_max - x_min
    ry = y_max - y_min
    scale = 10
    resolution = 1
    x_min_scale = x_min
    x_max_scale = np.round((x_max + rx/scale)/resolution) * resolution
    y_min_scale = np.round((y_min - ry/scale)/resolution) * resolution
    y_max_scale = np.round((y_max + ry/scale)/resolution) * resolution
    ax.set_xlim([x_min_scale, x_max_scale])
    ax2.set_ylim([y_min_scale, y_max_scale])
    plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
    plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

    ## legend setting
    ax.set_ylabel('lateral error (m)')
    ax2.set_ylabel('heading error (deg)')
    ax.set_xlabel('time (s)')
    # plt.title('tracking error')
    ax.legend(loc=1, frameon=False, ncol=1)
    ax2.legend(loc=2, frameon=False, ncol=1)

    ## save
    if save_enable:
        save_name = 'tracking_error_%d'%(i)
        # plt.savefig(os.path.join(script_path, '%s.svg'%(save_name)))
        plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.eps'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.pdf'%(save_name)))

# velocity
i = 0
for data in dataset:
    i += 1
    time_cur = data['time_cur']
    linear_v_x = data['linear_v_x']
    linear_v_y = data['linear_v_y']
    time_cost = data['time_cost']

    fig = plt.figure(figsize=figsize_inch, dpi=fig_dpi, frameon=False)
    ax = fig.add_subplot(111)
    line_des, = ax.plot(time_cur, linear_v_x, 
        linestyle='-', color=green_lv2, label='longitudinal velocity')
    line_cur, = ax.plot(time_cur, linear_v_y, 
        linestyle='--', color=green_lv3, label='lateral velocity')
    lines = [line_des, line_cur]

    # range and ticks setting
    x_min = np.min(time_cur)
    x_max = np.max(time_cur)
    y_min = 0.
    y_max = np.max([np.max(linear_v_x), np.max(linear_v_y)])
    rx = x_max - x_min
    ry = y_max - y_min
    scale = 10
    resolution = 0.5
    x_min_scale = x_min
    x_max_scale = np.round((x_max + rx/scale)/resolution) * resolution
    y_min_scale = np.round((y_min)/resolution) * resolution
    y_max_scale = np.round((y_max)/resolution) * resolution
    ax.axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale])
    plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
    plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

    ## legend setting
    plt.xlabel('time (s)')
    plt.ylabel('velocity (m/s)')
    # plt.title('velocity')
    plt.legend(loc='best', frameon=False, ncol=1)

    ## grid
    plt.grid(True, color=gray, alpha=0.3)

    ## save
    if save_enable:
        save_name = 'velocity_%d'%(i)
        # plt.savefig(os.path.join(script_path, '%s.svg'%(save_name)))
        plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.eps'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.pdf'%(save_name)))

# acceleration
i = 0
for data in dataset:
    i += 1
    time_cur = data['time_cur']
    linear_acc_y = data['linear_acc_y']

    fig = plt.figure(figsize=figsize_inch, dpi=fig_dpi, frameon=False)
    ax = fig.add_subplot(111)
    line_acc, = ax.plot(time_cur, linear_acc_y, 
        linestyle='-', color=green_lv2, label='lateral acceleration')

    # range and ticks setting
    x_min = np.min(time_cur)
    x_max = np.max(time_cur)
    y_min = np.min(linear_acc_y)
    y_max = np.max(linear_acc_y)
    rx = x_max - x_min
    ry = y_max - y_min
    scale = 10
    resolution = 1
    x_min_scale = x_min
    x_max_scale = np.round((x_max + rx/scale)/resolution) * resolution
    y_min_scale = np.round((y_min - ry/scale)/resolution) * resolution
    y_max_scale = np.round((y_max + ry/scale)/resolution) * resolution
    ax.axis([x_min_scale, x_max_scale, y_min_scale, y_max_scale])
    plt.xticks(np.linspace(x_min_scale, x_max_scale, 5))
    plt.yticks(np.linspace(y_min_scale, y_max_scale, 5))

    ## legend setting
    plt.xlabel('time (s)')
    plt.ylabel('acceleration (% m/s^2 %)')
    # plt.title('acceleration')
    plt.legend(loc='best', frameon=False, ncol=1)

    ## grid
    plt.grid(True, color=gray, alpha=0.3)

    ## save
    if save_enable:
        save_name = 'acceleration_%d'%(i)
        # plt.savefig(os.path.join(script_path, '%s.svg'%(save_name)))
        plt.savefig(os.path.join(script_path, '%s.png'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.eps'%(save_name)))
        # plt.savefig(os.path.join(script_path, '%s.pdf'%(save_name)))

plt.show()