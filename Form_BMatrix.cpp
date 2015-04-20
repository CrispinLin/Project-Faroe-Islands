#include "mex.h"
#include "math.h"


double Do2lp(double *map,double X1,double Y1,double X2,double Y2,double HT,double HR,int MapM)
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

	double xl[210],yl[210];
	
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
		// mexPrintf(" =0.1 ");
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
				return 0.0;
			}
		}
	}
	return c;
}


/**
 * input:
 * @param nlhs output no
 * @param plhs output pointer([TD,DD,BD,RD])
 * @param nrhs input no
 * @param prhs input pointer(TX,TY,SX,SY,RX,RY,HT,HR,map)
 */
void mexFunction(int nlhs,mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double *SX,*SY,*map;
	int ScatterLen,MapM;
	map        =mxGetPr(prhs[0]);
	MapM       =mxGetM(prhs[0]); //行数
//  map(i,j)-->data(j*M+i)

	SX         =mxGetPr(prhs[1]);
	SY         =mxGetPr(prhs[2]);
	ScatterLen =mxGetScalar(prhs[3]);

	double *BD;
	// BD         =mxGetPr(prhs[4]);

	plhs[0]=mxCreateDoubleMatrix(ScatterLen,ScatterLen,mxREAL);
	BD=mxGetPr(plhs[0]);


	for (int i=0;i<ScatterLen;i++)
	{
		for (int j=i+1;j<ScatterLen;j++)
		{
			// not overflow  PROBLEM is in Do2lp
			// mexPrintf("SX=%f,SY=%f\n",SX[i],SY[i],SX[j],SY[j]);
			BD[i+ScatterLen*j]= Do2lp(map,SX[i],SY[i],SX[j],SY[j],0,0,MapM);
		}
	}

}
