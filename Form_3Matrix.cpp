#include "mex.h"
#include "math.h"



double Do2LP(double *map,double X1,double Y1,double X2,double Y2,double HT,double HR,int MapM)
{

// makeline
	int N;
	if (fabs(X1-X2)>fabs(Y1-Y2))
	{
		N =fabs(X1-X2);
	}
	else
	{
		N =fabs(Y1-Y2);
	}

	double *xl,*yl;
	xl=new double[N+1];
	yl=new double[N+1]; 


	
	if (N>=1)
	{
		double dx=(X2-X1)/(double)N, dy=(Y2-Y1)/(double)N;	
		for (int i=0;i<=N;i++)
		{
			xl[i]=X1+i*dx;
			yl[i]=Y1+i*dy;
			// mexPrintf("N=%d",N);
			// mexPrintf("i=%d,xl[i]=%f,yl[i]=%f\n",i,xl[i],yl[i]);//debugging
		}

	}
	else
	{
		delete []xl;
		delete []yl;
		return 0.0;
	}

// LOSDistance
// 
	#define D 12756000
	#define deltaW 100
	#define deltaH 100
	#define pi 3.1416
	double l =hypot((xl[0]-xl[N])*deltaW,(yl[0]-yl[N])*deltaH);
	double CosC=cos(l/D*2);
	//  map(i,j)-->data(i+M*j)

	int mapindex=ceil(xl[0]+0.5)+MapM*ceil(yl[0]+0.5);
	double a = D/2.0+map[mapindex]+HT;
	mapindex=ceil(xl[N]+0.5)+MapM*ceil(yl[N]+0.5);
	double b = D/2.0+map[mapindex]+HR;
	double c = sqrt(pow(a,2)+pow(b,2)-2*a*b*CosC);
	

	N++; //N=xl点数
	
	if (N==2)
	{
		delete []xl;
		delete []yl;
		return c;
	}

		

	double B=acos((pow(a,2)+pow(c,2)-pow(b,2))/(2*a*c));
	double SinB=sin(B);

	if (N>2)
	{
		double dR=hypot((xl[0]-xl[1])*deltaW,(yl[0]-yl[1])*deltaH);
		double HC;


		for (int ct=1;ct<=N-1;ct++)
		{
			HC=a*SinB/sin(pi-dR/D*2*ct-B);
			mapindex=(ceil(xl[ct]+0.5)+MapM*ceil(yl[ct]+0.5));

			// mexPrintf("CT=%d\n",ct);
			// mexPrintf("xl[ct]=%f,yl[ct]=%f\n",xl[ct],yl[ct]);//debugging
			// mexPrintf("rxl=%f,ryl=%f\n",round(xl[ct]),round(yl[ct]));//debugging
			// mexPrintf("mapindex=%d\n",mapindex);//debugging

			if (HC<(D/2.0+map[mapindex]))
			{
				delete []xl;
				delete []yl;
				return 0.0;
			}
		}
	}
	delete []xl;
	delete []yl;
	return c;
}




/**
 * input:
 * @param nlhs output no
 * @param plhs output pointer(TD,DD,RD)
 * @param nrhs input no
 * @param prhs input pointer(TX,TY,SX,SY,RX,RY,HT,HR,map,TD,DD,RD)
 */
void mexFunction(int nlhs,mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double TX,TY,*SX,*SY,RX,RY,HT,HR,*map;
	int ScatterLen,MapM;
	TX         =mxGetScalar(prhs[0]);
	TY         =mxGetScalar(prhs[1]);
	SX         =mxGetPr(prhs[2]);
	SY         =mxGetPr(prhs[3]);
	ScatterLen =mxGetM(prhs[2]);
	RX         =mxGetScalar(prhs[4]);
	RY         =mxGetScalar(prhs[5]);
	HT         =mxGetScalar(prhs[6]);
	HR         =mxGetScalar(prhs[7]);
	map        =mxGetPr(prhs[8]);
	MapM       =mxGetM(prhs[8]); //行数
//  map(i,j)-->data(j*M+i)

	double *TD,*DD,*RD;
	plhs[0]=mxCreateDoubleMatrix(ScatterLen,1,mxREAL);
	plhs[1]=mxCreateDoubleMatrix(1,1,mxREAL);
	plhs[2]=mxCreateDoubleMatrix(1,ScatterLen,mxREAL);

	TD         =mxGetPr(plhs[0]);
	DD         =mxGetPr(plhs[1]);
	RD         =mxGetPr(plhs[2]);

	for (int i=0;i<ScatterLen;i++)
	{
		TD[i]=Do2LP(map,TX,TY,SX[i],SY[i],HT,0,MapM);
		RD[i]=Do2LP(map,SX[i],SY[i],RX,RY,0,HR,MapM);
	}

	DD[0]=Do2LP(map,TX,TY,RX,RY,HT,HR,MapM);

}
