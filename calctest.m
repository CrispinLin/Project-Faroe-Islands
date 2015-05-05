function calctest(index)
	load('settings.mat');
	load('Mapdata_Zero.mat'); %debugging
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
	
    gain=0.8
    
	N=length(SX);

	BD=zeros(N,N);
	BD=Form_BMatrix(Mapdata,SX,SY,N);
	BD=BD+BD';
	TaoB=BD/(3*10^8);
	BgohneF=zeros(N,N);
	odi=sum(BD~=0);
	odi=kron(odi',ones(1,N));
	BgohneF(BD~=0)=gain./odi(BD~=0);

	Bandwidth=20

	Fmin=(Freq-Bandwidth/2)*10^6;
	loop=2000;
	deltaF=(Bandwidth/loop)*10^6;
	HannWindow=hann(loop)';


	% profiling +settings.scale

	for RX=ClipX:5:(ClipX+settings.scale)
		for RY=ClipY:5:(ClipY+settings.scale)
			if (Saved_Data.x<=RX && Saved_Data.y<=RY)
				tic;
				disp(RX);
				disp(RY);
				disp(index);

				TD=zeros(N,1);
				DD=0;
				RD=zeros(1,N);
				[TD,DD,RD]=Form_3Matrix(TX,TY,SX,SY,RX,RY,HT,1.8,Mapdata);
				TaoT=TD/(3*10^8);
				TaoD=DD/(3*10^8);
				TaoR=RD/(3*10^8);

				[TgohneF,DgohneF,RgohneF]=FormGohneF(TD,DD,BD,RD,TaoT,TaoD,TaoB,TaoR,gain);
				disp('begin parallel loop');
				parfor n=1:1:loop;
					F=Fmin+deltaF*n;
					D=DgohneF/F.*exp(-1j*2*pi.*TaoD*F);
					T=TgohneF/sqrt(F).*exp(-1j*2*pi.*TaoT*F);
					B=BgohneF.*exp(-1j*2*pi.*TaoB*F);
					R=RgohneF/sqrt(F).*exp(-1j*2*pi.*TaoR*F);
					H(n)=D+R/(eye(N)-B)*T;
				end
				disp('parallel loop ended')
				Hex=H.*HannWindow;
				h=ifft(Hex);
				Saved_Data.XYA(RX,RY,index,:)=h;
				if rem(RY-1,25)==0
					disp('saving');
					% save the data and the calculation status every 5 points
					Saved_Data.x       =RX;
					Saved_Data.y       =RY;
					Saved_Data.Antenna =index;
					save Saved_Data.mat Saved_Data;
					disp('saved');
				end
				toc;
			end
		end
		Saved_Data.y=ClipY;
		% show progress
	end
end

