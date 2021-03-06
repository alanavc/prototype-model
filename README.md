# prototype-model
Matlab/Octave code to create discrete models from time-course data

We present an implementation of several algorithms, which together, form a pipeline for prototyping models from time-course data. Our approach is modular so that each module can be modified or even replaced as the user sees fit. It is written in Matlab/Octave and does need any external toolboxes or libraries. 

Starting from experimental time courses, we first transform the data into discrete values. Using algebraic techniques, we find the best networks that explain the data. Each network found will be consistent with all discrete time courses. We select the best network from the networks found and then find a discrete model that fits all the discrete data. This will result in a discrete model that can be simulated and compared with the original data. The model can also be run with new initial conditions or for longer time to create novel time courses that can be used to make predictions.  
