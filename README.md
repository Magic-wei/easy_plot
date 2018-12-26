# easy_plot

This repo gives examples for better plotting configuration in Matlab and Python. It is not a tutorial but an exhibition to show you common usages when I'm trying to make better plotting. I will also give a list of references for further exploration.

## How to change figure properties

There are two ways to change a figure's properties, one is to change the default settings which is a permanent approach, the other is to change the properties of the specific figure directly. If you are afraid of making a mess by changing the default settings, you may like the second one, and it is recommended to do this by calling a user-defined function by yourself if you have to configure lots of properties for each single figure, which leads to clean code styles.

### Matlab

- [Matlab plot](src/matlab/easy_plot.m) gives you an example using the second approach to change figures' properties.

<img src="images/easy_plot_using_matlab_1.png" width="50%" alt="example plotting in matlab"><img src="images/easy_plot_using_matlab_1.png" width="50%" alt="example plotting in matlab">

### Python

- [Python plot (coming soon)](src/Python/easy_plot.py)


## Dependencies

* Python > 3.0
* Matlab > 2014b

## Contribution

If you have any questions or ideas to improve it, just submit issues or PRs to this repo, and I would say thanks for your contribution.
