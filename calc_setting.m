function calc_setting(index)
	load('settings.mat');
	load('AntennaData.mat');
	load('Converted.mat');
	TX=Converted.X(index);
	TY=Converted.Y(index);
	
	if TX-settings.scale/2<1
		ClipX=1;
	elseif TX+settings.scale/2>724
		ClipX=324;
	else ClipX=TX-settings.scale/2;
	end
	if TY-settings.scale/2<1
		ClipY=1;
	elseif TY+settings.scale/2>1117
		ClipY=717;
	else ClipY=TY-settings.scale/2;
	end

	Saved_Data.x=ClipX;
	Saved_Data.y=ClipY;
	save Saved_Data.mat
end
