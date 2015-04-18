function calctest(index)
	load('settings.mat');
	load('Mapdata_Zero.mat');
	load('Saved_Data.mat');
	load('AntennaData.mat');
	load('Converted.mat');
	load('scattermap.mat');
	Saved_Data.scale=settings.scale;
	Saved_Data.density=settings.density;
	TX=Converted.X(index);
	TY=Converted.Y(index);
	HT=AntennaData.Height(index);
	Freq=AntennaData.Freq(index);
	disp('load data');

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
	disp('restrict the clip in the map');

	[SX,SY]=find(scattermap(ClipX:(ClipX+settings.scale),ClipY:(ClipY+settings.scale))>0);
	disp('generate scatterpoints');

	for RX=ClipX:(ClipX+1)
		for RY=ClipY:(ClipY+1)
			[TD,DD,BD,RD]=LOSDisMatrix(TX,TY,SX,SY,RX,RY,HT,1.8,Mapdata);
			disp('form TDBR');
			TaoT=TD/(3*10^8);
			TaoD=DD/(3*10^8);
			TaoB=BD/(3*10^8);
			TaoR=RD/(3*10^8);
			Fmin=(Freq-20)*10^6;
			loop=2000;
			deltaF=(40/loop)*10^6;
			[TgohneF,DgohneF,BgohneF,RgohneF]=FormGohneF(TD,DD,BD,RD,TaoT,TaoD,TaoB,TaoR,0.8);
			N=length(BD);
			disp('begin parallel loop');
			parfor n=1:1:loop;
			F=Fmin+deltaF*n;
			D=DgohneF/F.*exp(-1j*2*pi.*TaoD*F);
			T=TgohneF/sqrt(F).*exp(-1j*2*pi.*TaoT*F);
			B=BgohneF.*exp(-1j*2*pi.*TaoB*F);
			R=RgohneF/sqrt(F).*exp(-1j*2*pi.*TaoR*F);
			H(n)=D+R/(eye(N)-B)*T;
			end
			Hex=[H,fliplr(H)];
			Hex=Hex.*fftshift(hann(2*loop)');
			h=ifft(Hex);
			h=h(1:length(h)/2);
			Saved_Data.XYA(RX,RY,index,:)=[h];
			disp(RX);
			disp(RY);
			disp(index);
			save Saved_Data.mat Saved_Data;
		end
		% show progress
	end
	save Saved_Data.mat Saved_Data;
end

