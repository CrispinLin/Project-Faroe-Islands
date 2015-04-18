% Form the Los-Distance Matrix between Scatter points
% input:vector of x and y
% output:matrix of distance(0 for n-LOS)

function [TD,DD,BD,RD]=LOSDisMatrix(Xt,Yt,Xs,Ys,Xr,Yr,HT,HR,map)
	% x=[Xt,Xs,Xr];
	% y=[Yt,Ys,Yr];
	% N=length(x);
	% D=zeros(N,N);
	% for i=1:1:length(Xs)
	% 	for k=1:1:length(Xs)
 %            D((i-1)*length(Ys)+j,(k-1)*length(Ys)+l)=Do2LP(map,Xs(i),Ys(i),Xs(k),Ys(k),0,0);
	% % 	end
	% % end
	% for i=2:1:N-1
	% 	D(1,i)=Do2LP(map,x(1),y(1),x(i),y(i),HT,0);
	% end
	% D(1,N)=Do2LP(map,x(1),y(1),x(N),y(N),HT,HR);
	% for i=2:1:N-1
	% 	for j=i+1:1:N-1
	% 		D(i,j)=Do2LP(map,x(i),y(i),x(j),y(j),0,0);
	% 	end
	% end
	% for i=2:1:N-1
	% 	D(N,i)=Do2LP(map,x(i),y(i),x(N),y(N),0,HR);
	% end
	N=length(Xs);

	TD=zeros(N,1);
	for i=1:1:N
		TD(i,1)=Do2LP(map,Xt,Yt,Xs(i),Ys(i),HT,0);
	end

	DD=0;
	DD=Do2LP(map,Xt,Yt,Xr,Yr,HT,HR);

	BD=zeros(N,N);
	for i=1:1:N
		for j=i+1:1:N
			BD(i,j)=Do2LP(map,Xs(i),Ys(i),Xs(j),Ys(j),0,0);
		end
	end
	BD=BD+BD';

	RD=zeros(1,N);
	for i=1:1:N
		RD(1,i)=Do2LP(map,Xs(i),Ys(i),Xr,Yr,0,HR);
	end

end