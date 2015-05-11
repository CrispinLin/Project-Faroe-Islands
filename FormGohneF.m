function [TgohneF,DgohneF,BgohneF,RgohneF]=FormGohneF(TD,DD,BD,RD,TaoT,TaoD,TaoB,TaoR,gain);
	% g=zeros(N,N);
	% % D
	% if (Dis(1,N)~=0)
	% 	g(1,N)=1/(4*pi*Tao(1,N));
	% end
	% % T
	% TaoT=Tao(1,2:N-1);
	% DisT=Dis(1,2:N-1);
	% muet=mean(TaoT);
	% Set=sum(TaoT(TaoT~=0).^-2);
	% get=zeros(1,N-2);
	% get(DisT~=0)=sqrt(1/(4*pi*muet*Set))./TaoT(DisT~=0);
	% g(1,2:N-1)=get;
	% % B
	% TaoB=Tao(2:N-1,2:N-1);
	% DisB=Dis(2:N-1,2:N-1);
	% odi=sum(Dis(2:N-1,2:N-1)~=0);
	% odi=kron(odi',ones(1,N-2));
	% g(2:N-1,2:N-1)=gain./odi.*(Dis(2:N-1,2:N-1)~=0);
	% % R
	% muer=mean(Tao(2:N-1,N));
	% Ser=sum(Tao(2:N-1,N).^-2);
	% g(2:N-1,N)=sqrt(1/(4*pi*muer*Ser))./Tao(2:N-1,N).*(Dis(2:N-1,N)~=0);

	N=length(BD);
	% D
	DgohneF=0;
	if(DD~=0)	
		DgohneF=1/(4*pi*TaoD);
	end
	% T
	muet=mean(TaoT(TaoT~=0));
	Set=sum(TaoT(TaoT~=0).^-2);
	TgohneF=zeros(N,1);
	TgohneF(TD~=0)=sqrt(1/(4*pi*muet*Set))./TaoT(TD~=0);
	% B
	BgohneF=zeros(N,N);
	odi=sum(BD~=0);
	odi=kron(odi',ones(1,N));
	BgohneF(BD~=0)=gain./odi(BD~=0);
	% R
	muer=mean(TaoR(TaoR~=0));
	Ser=sum(TaoR(TaoR~=0).^-2);
	RgohneF=zeros(1,N);
	RgohneF(RD~=0)=sqrt(1/(4*pi*muer*Ser))./TaoR(RD~=0);
end