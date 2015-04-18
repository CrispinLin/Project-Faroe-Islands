function [y1]=converty(y)
    ycorner=6808687.5;deltaH=100;mapHeight=1117;y1=1;
    if (y>=ycorner) & (y<ycorner+deltaH*mapHeight) 
    y1=round((ycorner-y)/deltaH)+1116;
end