function peakDetect
    load('Mapdata_Zero.mat');
	[mapWidth,mapHeight]=size(Mapdata)
	peakout=zeros(mapHeight,mapWidth);
	temp=zeros(mapHeight,mapWidth);
%     可用矩阵减法重写
	for y=3:mapHeight-3
		for x=3:mapWidth-3
			if Mapdata(x,y)>=Mapdata(x-1,y-1) && Mapdata(x,y)>Mapdata(x-1,y+1) && Mapdata (x,y)>Mapdata(x+1,y-1) && Mapdata(x-1,y-1)>Mapdata(x-2,y) && Mapdata (x-1,y-1)>Mapdata(x,y-2)
				temp(y,x)=1;
			elseif Mapdata(x,y)>=Mapdata(x,y-1) && Mapdata(x,y)>Mapdata(x-1,y) && Mapdata(x,y)>Mapdata(x+1,y) && Mapdata(x,y-1)>Mapdata(x-1,y-1) && Mapdata(x,y-1)>Mapdata(x+1,y-1)
				temp(y,x)=2;
			elseif Mapdata(x,y)>=Mapdata(x+1,y-1) && Mapdata(x,y)>Mapdata(x-1,y-1) && Mapdata(x,y)>Mapdata(x+1,y+1) && Mapdata(x+1,y-1)>Mapdata(x,y-2) && Mapdata(x+1,y-1)>Mapdata(x+2,y)
				temp(y,x)=3;
			elseif Mapdata(x,y)>=Mapdata(x-1,y) && Mapdata(x,y)>Mapdata(x-1,y-1) && Mapdata(x,y)>Mapdata(x-1,y+1) && Mapdata(x-1,y)>Mapdata(x-1,y-1) && Mapdata(x-1,y)>Mapdata(x-1,y+1)
				temp(y,x)=4;
			elseif Mapdata(x,y)>=Mapdata(x+1,y) && Mapdata(x,y)>Mapdata(x+1,y-1) && Mapdata(x,y)>Mapdata(x+1,y+1) && Mapdata(x+1,y)>Mapdata(x+1,y-1) && Mapdata(x+1,y)>Mapdata(x+1,y+1)
				temp(y,x)=6;
			elseif Mapdata(x,y)>=Mapdata(x-1,y+1) && Mapdata(x,y)>Mapdata(x-1,y-1) && Mapdata(x,y)>Mapdata(x+1,y+1) && Mapdata(x-1,y+1)>Mapdata(x-2,y) && Mapdata(x-1,y+1)>Mapdata(x,y+2)
				temp(y,x)=7;
			elseif Mapdata(x,y)>=Mapdata(x,y+1) && Mapdata(x,y)>Mapdata(x-1,y) && Mapdata(x,y)>Mapdata(x+1,y) && Mapdata(x,y+1)>Mapdata(x-1,y+1) && Mapdata(x,y+1)>Mapdata(x+1,y+1)
				temp(y,x)=8;
			elseif Mapdata(x,y)>=Mapdata(x+1,y+1) && Mapdata(x,y)>Mapdata(x-1,y+1) && Mapdata (x,y)>Mapdata(x+1,y-1) && Mapdata(x+1,y+1)>Mapdata(x,y+2) && Mapdata(x+1,y+1)>Mapdata(x+2,y)
				temp(y,x)=9;
			end
		end
	end

	for x=3:mapHeight-3
		for y=3:mapWidth-3
			if temp(x,y)==1 && (temp(x-1,y-1)==1||temp(x-1,y-1)==4||temp(x-1,y-1)==2)
				peakout(x,y)=1;
			elseif temp(x,y)==2 && (temp(x,y-1)==2||temp(x,y-1)==1||temp(x,y-1)==3)
				peakout(x,y)=2;
			elseif temp(x,y)==3 && (temp(x+1,y-1)==3||temp(x+1,y-1)==2||temp(x+1,y-1)==6)
				peakout(x,y)=3;
			elseif temp(x,y)==4 && (temp(x-1,y)==4||temp(x-1,y)==1||temp(x-1,y)==7)
				peakout(x,y)=4;
			elseif temp(x,y)==6 && (temp(x+1,y)==6||temp(x+1,y)==3||temp(x+1,y)==9)
				peakout(x,y)=6;
			elseif temp(x,y)==7 && (temp(x-1,y+1)==7||temp(x-1,y+1)==4||temp(x-1,y+1)==8)
				peakout(x,y)=7;
			elseif temp(x,y)==8 && (temp(x,y+1)==8||temp(x,y+1)==7||temp(x,y+1)==9)
				peakout(x,y)=8;
			elseif temp(x,y)==9 && (temp(x+1,y+1)==9||temp(x+1,y+1)==8||temp(x+1,y+1)==6)
				peakout(x,y)=9;
			end
		end
    end
    
%     -1- peak(x,y)
% ====
%     n=1;
%     for x=1:1:mapWidth
%         for y=1:1:mapHeight
%         	if (peakout(y,x)>0)
%             	peak(n,1)=y;
%                 peak(n,2)=x;
%                 n=n+1;
%                 disp(y);disp(x);
%             end
%         end
%     end
% ====
%   -1-
    
%   -2- map 
% ====
    peak=peakout>0;
% ====
%   -2-
    save('peak.mat','peak');
end