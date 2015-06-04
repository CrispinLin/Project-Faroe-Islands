function BD=Mat_BMatrix(Mapdata,SX,SY,N);
	for i=1:1:N
		for j=i:1:N
			BD(i,j)=Do2LP(Mapdata,SX(i),SY(i),SX(j),SY(j),0,0);
		end
	end
end