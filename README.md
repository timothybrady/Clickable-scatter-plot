Clickable-scatter-plot
======================

Matlab code for a scatter plot where you can click the points for more information.

% CLICKABLESCATTER Like scatter(), but allows meta-data to be present for each point  
% such that when you click a point something shows to the right of it. The general  
% format is:  
%  
%  h = clickableScatter(x, y, metaData, ...)  
%  
% Any additional parameters that you can pass to scatter(), for example, a string   
% with line specifications like 'bx' or a 'Color' parameter, or a size   
% for each point, can be passed after the metaData parameter and will be passed  
% directly to scatter().  
%  
% There are several formats possible for the metaData parameter:  
%  
% 1) A string with %d in it. When the i-th point is clicked, this will show the  
% image with %d replaced with i.  
%  'images/item%d.png'  
%  
% 2) A cell array of strings. When the i-th point is clicked, this will show the  
% image from the i-th cell.  
%  {'images/item1.png', 'images/item2.png', ..., 'images/itemN.png'}  
%  
% 3) A function that takes a single input (i, which item was clicked), and returns  
% a string for which filename to show:  
%  @(i) sprintf('images/item%d.png',i)  
%  
% 4) A function that takes a single input (i) and returns a cell array with two  
% values: which file to show; and the title to put on the meta-data plot.  
%  @(i) {sprintf('images/item%d.png',i), sprintf('display %d',i)}  
%  
% 5) A function that takes two inputs, i, and the subplot handle on which to draw.  
% This function then draws whatever is needed into that plot. The plot is also set  
% to the current axis before this function is called.  
%  @(i,h) imshow(imread(sprintf('images/item%d.png',i)))  
