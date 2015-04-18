function [x1]=convertx(x)
    xcorner=569724.6875;deltaW=100;mapWidth=724;
    x1=1;
    if (x>xcorner) & (x<xcorner+deltaW*mapWidth) 
    x1=round((x-xcorner)/deltaW);
end