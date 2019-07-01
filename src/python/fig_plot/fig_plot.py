#! /usr/bin/env python
# -*- coding: utf-8 -*-

'''
---------------------------------
 Figure Plot
 Author: Wei Wang
 Date: 02/27/2019
---------------------------------
'''

import os
import glob
import pandas as pd
import numpy as np # for easy generation of arrays
import matplotlib.pyplot as plt

# parameter setting
script_path = os.path.split(os.path.realpath(__file__))[0] # os.getcwd() returns the path in your terminal
(base_path, script_dir) = os.path.split(script_path)
search_path = os.path.join(script_path, '..','..','..','data', 'fig_plot')
filename = os.path.join('*', 'state.csv')
global_path_file = os.path.join(script_path,'..','..','..','data','fig_plot','global_path.txt')
# print('search_path', search_path)
# print('global_path_file', global_path_file)

# customize color
green_lv1 = list(np.array([229, 245, 249]) / 255.0)
green_lv2 = list(np.array([153, 216, 201]) / 255.0)
green_lv3 = list(np.array([44, 162, 95]) / 255.0)
gray = list(np.array([99, 99, 99]) / 255.0)

# import data
global_path = pd.read_csv(global_path_file, sep=' ', header=None)
print(global_path.head())
global_path.columns = ["point_id", "position_x", "position_y"]
dataset = []
file_list = glob.glob(os.path.join(search_path, filename))
# print('file_list has:', file_list)
print(os.path.join(search_path, filename))
for file in file_list:
	raw_data = pd.read_csv(file)
	dataset.append(raw_data)
	print(file, '-> dataset[%d]' %(len(dataset)))

# path_comparison
fig = plt.figure(num=1, dpi=150, frameon=False)
x1 = range(1,21)
y1 = np.random.uniform(0,1,len(x1))
coeffis = np.polyfit(x1, y1, 5)
p = np.poly1d(coeffis)
y1_fit = p(x1)

ax = fig.add_subplot(111)
line_global, = ax.plot(global_path['position_x'], global_path['position_y'], 
	linestyle='-', linewidth=1.5, label='global path')
lines = []
lines.append(line_global)
i = 0
for data in dataset:
	i += 1
	line_tmp, = ax.plot(data['position_x'], data['position_y'], 
	linestyle='-', linewidth=1.5, label='vehicle path # %d'%(i))
	lines.append(line_tmp)

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
plt.title('path comparison')
plt.legend(loc='best', frameon=False, ncol=1)

# grid off
plt.grid(True, color=gray, alpha=0.3)
	
for data in dataset:
	time_cur = data['time_cur']
	s_length = data['s_length']
	des_steering_angle = data['des_steering_angle']
	cur_steering_angle = data['cur_steering_angle']
	lateral_error = data['lateral_error']
	heading_error = data['heading_error']
	linear_v_x = data['linear_v_x']
	linear_v_y = data['linear_v_y']
	linear_v_z = data['linear_v_z']
	angular_v_x = data['angular_v_x']
	angular_v_y = data['angular_v_y']
	angular_v_z = data['angular_v_z']
	position_x = data['position_x']
	position_y = data['position_y']
	position_z = data['position_z']
	heading = data['heading']
	pitch = data['pitch']
	roll = data['roll']
	linear_acc_x = data['linear_acc_x']
	linear_acc_y = data['linear_acc_y']
	linear_acc_z = data['linear_acc_z']
	time_cost = data['time_cost']

	# tracking errors vs s_length
	plt.figure()
	plt.subplot(211)
	plt.plot(s_length, lateral_error)
	plt.xlabel('s_length (m)')
	plt.ylabel('lateral error (m)')
	plt.grid(True)
	plt.subplot(212)
	plt.plot(s_length, heading_error)
	plt.xlabel('s_length (m)')
	plt.ylabel('heading error (m)')
	plt.grid(True)

plt.show()