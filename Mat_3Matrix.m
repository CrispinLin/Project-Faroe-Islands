function [TD,DD,RD]=Mat_3Matrix(TX,TY,SX,SY,RX,RY,HT,HR,Mapdata)
	N=length(SX);
	TD=zeros(N,1);
	for i=1:1:N
		TD(i,1)=Do2LP(Mapdata,TX,TY,SX(i),SY(i),HT,0);
	end

	DD=0;
	DD=Do2LP(Mapdata,TX,TY,RX,RY,HT,HR);

	RD=zeros(1,N);
	for i=1:1:N
		RD(1,i)=Do2LP(Mapdata,SX(i),SY(i),RX,RY,0,HR);
	end
end