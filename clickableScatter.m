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
%

function h = clickableScatter(x, y, functionForFile, varargin)  
  % If figure is at the default size (e.g., was just opened), resize it to be twice
  % as wide to fit two subplots nicely
  pos = get(gcf, 'Position');
  defPos = get(0, 'DefaultFigurePosition');
  if pos(3)==defPos(3) && pos(4)==defPos(4)
    set(gcf, 'Position', [pos(1) pos(2) pos(3)*1.4 pos(4)*0.75]);
  end
  set(gcf, 'Color', [1 1 1]);
  
  % Draw initial scatter
  if isempty(varargin)
    varargin = {25, 'bx'};
  end
  h = subplot(1,2,1); hold off;
  s = scatter(x,y,varargin{:});
  set(gca, 'FontName', 'Courier New', 'FontSize', 10);
  hold on;
  
  % Set up click handlers
  set(gca,'ButtonDownFcn', @Click_Callback);
  set(get(gca,'Children'),'ButtonDownFcn', @Click_Callback);
  curPlot = NaN;
  
  % What to do when an item is clicked
  function Click_Callback(~,~)
    % Get the location that was clicked on
    cP = get(gca,'Currentpoint');
    cx = cP(1,1); 
    cy = cP(1,2);
    
    % Find nearest point
    diffValues = (cx-x).^2 + (cy-y).^2;
    [~,minValue] = min(diffValues);

    % Plot a new point on top of it
    if ~isnan(curPlot)
      delete(curPlot);
    end
    curPlot = plot(x(minValue), y(minValue), 'ro', 'LineWidth', 2, 'MarkerSize', 10);
    
    % Now figure out what to show on the other subplot
    curH = subplot(1,2,2); 
    hold off;
    
    if isa(functionForFile, 'char') 
      % they passed a string, assume it has a %d in it
      fileName = sprintf(functionForFile, minValue);
      imshow(imread(fileName));
    elseif isa(functionForFile, 'cell') 
      % cell array; assume it has N cells, and find the filename in the i-th cell
      fileName = functionForFile{minValue};
      imshow(imread(fileName));      
    elseif isa(functionForFile, 'function_handle') && nargin(functionForFile) == 1
      % function handle with one parameter; assume if we pass i, we will get
      % back a string with the file to show or a cell array with the file and title
      fileName = functionForFile(minValue);
      if isa(fileName, 'char')
        imshow(imread(fileName));
      else
        imshow(imread(fileName{1}));
        title(fileName{2}, 'FontName', 'Courier New', 'FontSize', 9);
      end
    elseif isa(functionForFile, 'function_handle') && nargin(functionForFile) == 2
      % just call this function and let it do the drawing
      functionForFile(minValue, curH);
    end
  end
end

