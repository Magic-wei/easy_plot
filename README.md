# easy_plot

This repo gives examples for better plotting configuration in Matlab and Python. It is not a tutorial but an exhibition to show you some interesting usages when I'm working on daily figure processing. I will also give a list of references for further exploration.

## Quick Start

### basic_example: how to change figure properties

There are two ways to change a figure's properties, one is to change the default settings which is a permanent approach, the other is to change the properties of the specific figure directly. If you are afraid of making a mess by changing the default settings, you may like the second one, and it is recommended to do this by calling a user-defined function by yourself if you have to configure lots of properties for each single figure, which leads to clean code styles.

- [basic_example](src/matlab/basic_example/basic_example.m) gives you an example using the second approach to change figures' properties.

<img src="images/easy_plot_using_matlab_1.png" width="50%" alt="example plotting in matlab"><img src="images/easy_plot_using_matlab_2.png" width="50%" alt="example plotting in matlab">

### fig_plot: advanced figure plot example

This is an example to show how to plot figure based on csv file in a batch approach. Figure property configuration is similar to [basic_example](src/matlab/basic_example/basic_example.m).

### fig_splice: automatic figure splicing

This function can dramatically reduce our efforts to put some figures into one single figure in a batch approach. Here is an example when I am trying to compose four images into a 2x2 single image. Let's see the inputs

<img src="images/fig_splice/acceleration1.png" width="25%" alt="acceleration1"><img src="images/fig_splice/steering_angle1.png" width="25%" alt="steering_angle1"><img src="images/fig_splice/tracking_error1.png" width="25%" alt="tracking_error1"><img src="images/fig_splice/velocity1.png" width="25%" alt="velocity1">

and the output:

<img src="images/fig_splice/outfigure1.png" width="50%" alt="outfigure1">

You can also set the columns of the output image and whether or not cutting image edges by using the function script [spliceFigureFunc.m](src/matlab/fig_splice/spliceFigureFunc.m). To see one example of how to realize this, just have a look at [figure_splice.m](src/matlab/fig_splice/figure_splice.m).

## Dependencies

* Python > 3.0
* Matlab > 2014b

## to-do

- [ ] Python version (coming soon)

## Contributing

If you have any questions or ideas to improve it, just submit issues or PRs to this repo, and I would say thanks for your contribution.

## Acknowledgement

Thanks to Mr. Mie (咩先生) @科研充电宝 (one offical account on WeChat aiming at sharing various research tricks) for providing the original version of figure splicing based on which I improved and formulated the demonstration of fig_splice.
