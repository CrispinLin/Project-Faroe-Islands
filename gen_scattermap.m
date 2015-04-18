% Generate Scatter Points
% input:settings.mat (density)
% output:map of scatters in 0/1 (with density and +peak scatters, need to
% cut certain part for local calculation)
function gen_scattermap
% 	global settings;
    load('settings.mat');
	load('Mapdata50.mat');
	map=Mapdata>0;
    mask=zeros(size(Mapdata));
    mask(1:settings.density:end,1:settings.density:end)=1;
    map=map.*mask;
	load('peak.mat');
	scattermap=map+peak';
    save scattermap.mat scattermap;
end


% sel_scatterpoints
% output:a vector for x and a vector for y

% [X,Y]=find(map(x1:d:x2,y1:d:y2)>0);

% X=((X-1)*d+x1)';
% Y=((Y-1)*d+y1)';