#include "cnn.h"
#include "xsdps.h"		/* SD device driver */
#include "ff.h"
#include "xil_cache.h"
#include "xplatform_info.h"
#include "xtmrctr.h"
#include "temp.h"
#include "platform.h"
#include "xparameters.h"
#include "xscugic.h"
#include "xaxidma.h"
#include "xmmult_accel_core.h"
#include "lib_xmmult_hw.h"

extern XTmrCtr timer_dev;

void cnnsetup(CNN* cnn,nSize inputSize,int outputSize)
{
	cnn->layerNum = 5;

	nSize inSize;
	int mapSize = 5;
	inSize.c = inputSize.c;
	inSize.r = inputSize.r;
	cnn->C1 = initCovLayer(inSize.c,inSize.r,5,1,6);
	inSize.c = inSize.c-mapSize+1;
	inSize.r = inSize.r-mapSize+1;
	cnn->S2 = initPoolLayer(inSize.c,inSize.r,2,6,6,AvePool);
	inSize.c = inSize.c/2;
	inSize.r = inSize.r/2;
	cnn->C3 = initCovLayer(inSize.c,inSize.r,5,6,12);
	inSize.c = inSize.c-mapSize+1;
	inSize.r = inSize.r-mapSize+1;
	cnn->S4 = initPoolLayer(inSize.c,inSize.r,2,12,12,AvePool);
	inSize.c = inSize.c/2;
	inSize.r = inSize.r/2;
	cnn->O5 = initOutLayer(inSize.c*inSize.r*12,outputSize);
}

CovLayer initCovLayer(int inputWidth, int inputHeight, int mapSize, int inChannels, int outChannels)
{
	CovLayer covL;

	covL.inputHeight = inputHeight; //28
	covL.inputWidth = inputWidth; //28
	covL.mapSize = mapSize; //5
	covL.inChannels = inChannels; //1
	covL.outChannels = outChannels; //6

	covL.isFullConnect = 1; // 默认为全连接

	// 权重空间的初始化，先行再列调用，[r][c]
	int i,j,r;

	covL.mapData = (float****)malloc(inChannels*sizeof(float***));

	for(i = 0;i < inChannels;i++)
	{
		covL.mapData[i] = (float***)malloc(outChannels*sizeof(float**));
		for(j = 0;j < outChannels;j++)
		{
			covL.mapData[i][j] = (float**)malloc(mapSize*sizeof(float*));
			for(r = 0;r < mapSize;r++)
			{
				covL.mapData[i][j][r] = (float*)malloc(mapSize*sizeof(float));
			}
		}
	}

	covL.basicData = (float*)calloc(outChannels,sizeof(float));

	int outW=inputWidth-mapSize+1;
	int outH=inputHeight-mapSize+1;


	covL.d = (float***)malloc(outChannels*sizeof(float**));
	covL.v = (float***)malloc(outChannels*sizeof(float**));
	covL.y = (float***)malloc(outChannels*sizeof(float**));
	for(j = 0;j < outChannels;j++)
	{
		covL.d[j] = (float**)malloc(outH*sizeof(float*));
		covL.v[j] = (float**)malloc(outH*sizeof(float*));
		covL.y[j] = (float**)malloc(outH*sizeof(float*));
		for(r = 0;r < outH;r++)
		{
			covL.d[j][r] = (float*)calloc(outW,sizeof(float));
			covL.v[j][r] = (float*)calloc(outW,sizeof(float));
			covL.y[j][r] = (float*)calloc(outW,sizeof(float));
		}
	}
	return covL;
}

PoolLayer initPoolLayer(int inputWidth,int inputHeight,int mapSize,int inChannels,int outChannels,int poolType)
{
	PoolLayer poolL;

	poolL.inputHeight = inputHeight;
	poolL.inputWidth = inputWidth;
	poolL.mapSize = mapSize;
	poolL.inChannels = inChannels;
	poolL.outChannels = outChannels;
	poolL.poolType = poolType; 

	poolL.basicData = (float*)calloc(outChannels,sizeof(float));

	int outW = inputWidth/mapSize;
	int outH = inputHeight/mapSize;

	int j,r;
	poolL.d = (float***)malloc(outChannels*sizeof(float**));
	poolL.y = (float***)malloc(outChannels*sizeof(float**));
	for(j = 0;j < outChannels;j++)
	{
		poolL.d[j] = (float**)malloc(outH*sizeof(float*));
		poolL.y[j] = (float**)malloc(outH*sizeof(float*));
		for(r = 0;r < outH;r++)
		{
			poolL.d[j][r]=(float*)calloc(outW,sizeof(float));
			poolL.y[j][r]=(float*)calloc(outW,sizeof(float));
		}
	}

	return poolL;
}

OutLayer initOutLayer(int inputNum,int outputNum)
{
	OutLayer outL;

	outL.inputNum=inputNum;  //192
	outL.outputNum=outputNum; //10


	outL.basicData=(float*)calloc(outputNum,sizeof(float));

	outL.d=(float*)calloc(outputNum,sizeof(float));
	outL.v=(float*)calloc(outputNum,sizeof(float));
	outL.y=(float*)calloc(outputNum,sizeof(float));

	// 权重的初始化
	outL.wData=(float**)malloc(outputNum*sizeof(float*)); // 输入行，输出列
	int i;
	for(i = 0;i < outputNum;i++)
	{
		outL.wData[i] = (float*)malloc(inputNum*sizeof(float));
	}

	outL.isFullConnect=1;
	return outL;
}

int vecmaxIndex(float* vec, int veclength)// 返回向量最大数的序号
{
	int i;
	float maxnum = -1.0;
	int maxIndex = 0;
	// 这里一共有10个数字，每一个的可能性存在vec这个数组里
	for(i = 0;i < veclength;i++)
	{
		if(maxnum < vec[i])
		{
			maxnum = vec[i];
			maxIndex = i;
		}
	}
	return maxIndex;
}

// 测试cnn函数
float cnntest(CNN* cnn, ImgArr inputData, LabelArr outputData, int testNum)
{
	int n = 0;
	for(n = 0;n < testNum; n++)
	{
		/// 这个函数是最重要的，在这里把这张图过了所有的层，然后输出的结果再05->y这个向量里面
		cnnff(cnn, inputData->ImgPtr[n].ImgData);
		///
		xil_printf("the label number is %d \n", vecmaxIndex(outputData->LabelPtr[n].LabelData, cnn->O5.outputNum));
		xil_printf("the cnn number is %d \n", vecmaxIndex(cnn->O5.y, cnn->O5.outputNum));

		cnnclear(cnn);
	}
	return 0;
}

// 导入cnn的数据
void importcnn(CNN* cnn, const char* filename)
{
	UINT NumBytesRead;
	FATFS fatfs;
	TCHAR *Path = "0:/";
	FRESULT Res;
	Res = f_mount(&fatfs, Path, 0);
	FIL fp;

	Res = f_mount(&fatfs, Path, 0);
	if (Res != FR_OK)
	{
		xil_printf("mount failed\n");
	}

	Res = f_open(&fp, filename, FA_READ);
	if(Res)
		xil_printf("open image file failed\n");

	int i,j,c,r;
	// C1的数据
	for(i = 0;i < cnn->C1.inChannels;i++)
		for(j = 0;j < cnn->C1.outChannels;j++)
		{
			for(r = 0;r < cnn->C1.mapSize;r++)
			{
				for(c = 0;c < cnn->C1.mapSize;c++)
				{
					if(cnn->C1.mapData[i][j][r] == NULL)
						xil_printf("wrong \n");
					Res = f_read(&fp, &cnn->C1.mapData[i][j][r][c],  sizeof(float), &NumBytesRead);
					//printf("%f ", cnn->C1.mapData[i][j][r][c]);
				}
				//printf("\n");
			}
			//printf("\n");
		}


	for(i = 0;i < cnn->C1.outChannels;i++)
	{
		Res = f_read(&fp, &cnn->C1.basicData[i],  sizeof(float), &NumBytesRead);
	}

	xil_printf("finish loading C1 layer parameters \n");

	// C3网络
	for(i=0;i<cnn->C3.inChannels;i++)
		for(j=0;j<cnn->C3.outChannels;j++)
			for(r=0;r<cnn->C3.mapSize;r++)
				for(c=0;c<cnn->C3.mapSize;c++)
				{
					// malloc failed
					if(cnn->C3.mapData[i][j][r] == NULL)
						xil_printf("wrong \n");

					Res = f_read(&fp, &cnn->C3.mapData[i][j][r][c],  sizeof(float), &NumBytesRead);
				}

	xil_printf("finish loading C3 layer parameters\n");

	for(i=0;i<cnn->C3.outChannels;i++)
		Res = f_read(&fp, &cnn->C3.basicData[i],  sizeof(float), &NumBytesRead);


	// O5输出层
	for(i = 0;i < cnn->O5.outputNum;i++)
		for(j = 0;j < cnn->O5.inputNum;j++)
			Res = f_read(&fp, &cnn->O5.wData[i][j],  sizeof(float), &NumBytesRead);


	for(i = 0;i < cnn->O5.outputNum;i++)
		Res = f_read(&fp, &cnn->O5.basicData[i],  sizeof(float), &NumBytesRead);

	xil_printf("finish loading 05 layer parameters\n");

	f_close(&fp);
}


// 这里InputData是图像数据，inputData[r][c],r行c列，这里跟各权重模板是一致的
void cnnff(CNN* cnn,float** inputData)
{
	// 第一层的传播
	int i, j, r, c;

	// 第一层卷积层输出数据（C1）
	nSize mapSize = {cnn->C1.mapSize, cnn->C1.mapSize};
	nSize inSize = {cnn->C1.inputWidth, cnn->C1.inputHeight};
	nSize outSize = {cnn->S2.inputWidth, cnn->S2.inputHeight};

    float **wholeKernel = (float**)malloc(6 * sizeof(float*));
    for (i = 0; i < 6; i++)
        wholeKernel[i] = (float*)malloc(25 * sizeof(float));
    int cov1layerstart = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	for(j = 0;j < (cnn->C1.inChannels);j++)
	{
		// 卷积
	    int m, n, k;
	    int l;
		for (m = 0; m < 6; m++)
		{
			l = 0;
			for (k = 0; k < 5; k++)
			{
				for (n = 0; n < 5; n++)
				{
					wholeKernel[m][l] = cnn->C1.mapData[j][m][4-k][4-n];
					l++;
				}
			}
		}
		float** mapout = cov_layer1_6(wholeKernel,mapSize,inputData,inSize,valid);
		// 求和
		k = 0;
		for (i = 0; i < 6; i++)
			for (m = 0; m < 24; m++)
				for (n = 0; n < 24; n++)
					cnn->C1.v[i][m][n] += mapout[i][24*m+n];
	}

	for(i = 0;i < (cnn->C1.outChannels);i++)
		for(r = 0;r < outSize.r;r++)
			for(c = 0;c < outSize.c;c++)
				// sigmoid function
				cnn->C1.y[i][r][c] = activation_Sigma(cnn->C1.v[i][r][c], cnn->C1.basicData[i]);


//	for(i=0;i<(cnn->C1.outChannels);i++)
//    {
//		for(j=0;j<(cnn->C1.inChannels);j++)
//        {
//			float** mapout=cov(cnn->C1.mapData[j][i],mapSize,inputData,inSize,valid);
//			addmat(cnn->C1.v[i],cnn->C1.v[i],outSize,mapout,outSize);
//			for(r=0;r<outSize.r;r++)
//				free(mapout[r]);
//			free(mapout);
//		}
//		for(r=0;r<outSize.r;r++)
//			for(c=0;c<outSize.c;c++)
//				cnn->C1.y[i][r][c]=activation_Sigma(cnn->C1.v[i][r][c],cnn->C1.basicData[i]);
//	}
	int cov1layerend = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	xil_printf("%d cycles spent on cov2\n", cov1layerend - cov1layerstart);
	// 第二层的输出传播S2，采样层
	outSize.c = cnn->C3.inputWidth;
	outSize.r = cnn->C3.inputHeight;
	inSize.c = cnn->S2.inputWidth;
	inSize.r = cnn->S2.inputHeight;
	for(i = 0;i < (cnn->S2.outChannels);i++)
	{
		// pooling的类型是取平均
		if(cnn->S2.poolType == AvePool)
			avgPooling(cnn->S2.y[i], outSize, cnn->C1.y[i], inSize, cnn->S2.mapSize);
	}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	outSize.c = cnn->S4.inputWidth;
	outSize.r = cnn->S4.inputHeight;
	inSize.c = cnn->C3.inputWidth;
	inSize.r = cnn->C3.inputHeight;
	mapSize.c = cnn->C3.mapSize;
	mapSize.r = cnn->C3.mapSize;
//	for(i = 0;i < (cnn->C3.outChannels);i++) // 12
//	{
//		for(j = 0;j < (cnn->C3.inChannels);j++) //6
//		{
//			float** mapout = cov(cnn->C3.mapData[j][i], mapSize, cnn->S2.y[j], inSize, valid);
//			addmat(cnn->C3.v[i],cnn->C3.v[i], outSize, mapout, outSize);
//		}
//
////		for(j = 0;j < (cnn->C3.inChannels);j++)
////		{
////			mapKernel[j] = cnn->C3.mapData[j][i];
////			float** mapout = cov_layer3(cnn->C3.mapData[j][i], mapSize, cnn->S2.y[j], inSize, valid);
////
////			addmat(cnn->C3.v[i],cnn->C3.v[i],outSize,mapout,outSize);
////		}
//
//		for(r = 0;r < outSize.r;r++)
//			for(c = 0;c < outSize.c;c++)
//				cnn->C3.y[i][r][c] = activation_Sigma(cnn->C3.v[i][r][c],cnn->C3.basicData[i]);
//	}
//    float **wholeKernel = (float**)malloc(6*sizeof(float*));
//    for (i = 0; i < 6; i++)
//        wholeKernel[i] = (float*)malloc(25 * sizeof(float));


    int cov2layerstart = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	for(j = 0;j < (cnn->C3.inChannels);j++)
	{
	    int m, n, k;
	    int l;

	    // convert 6 kernel to vector
	    for (m = 0; m < 6; m++)
	    {
	        l = 0;
	        for (k = 0; k < 5; k++)
	        {
	            for (n = 0; n < 5; n++)
	            {
	                wholeKernel[m][l] = cnn->C3.mapData[j][m][4-k][4-n];
	                l++;
	            }
	        }
	    }
		float** mapout = cov_layer3_6(wholeKernel, mapSize, cnn->S2.y[j], inSize, valid);
		// add all mapout to the v
		for (i = 0; i < 6; i++)
			for (m = 0; m < 8; m++)
				for (n = 0; n < 8; n++)
					cnn->C3.v[i][m][n] += mapout[i][8*m+n];
		for(i = 0; i < 6;i++)
			free(mapout[i]);
		free(mapout);


	    for (m = 0; m < 6; m++)
	    {
	        l = 0;
	        for (k = 0; k < 5; k++)
	        {
	            for (n = 0; n < 5; n++)
	            {
	                wholeKernel[m][l] = cnn->C3.mapData[j][m+6][4-k][4-n];
	                l++;
	            }
	        }
	    }
		mapout = cov_layer3_6(wholeKernel, mapSize, cnn->S2.y[j], inSize, valid);
		for (; i < 12; i++)
			for (m = 0; m < 8; m++)
				for (n = 0; n < 8; n++)
					cnn->C3.v[i][m][n] += mapout[i-6][8*m+n];

		for(i = 0; i < 6;i++)
			free(mapout[i]);
		free(mapout);
	}
    for (i = 0; i < 6; i++)
        free(wholeKernel[i]);
    free(wholeKernel);

    for (i=0; i < cnn->C3.outChannels; i++)
		for(r=0;r<outSize.r;r++)
			for(c=0;c<outSize.c;c++)
				cnn->C3.y[i][r][c]=activation_Sigma(cnn->C3.v[i][r][c],cnn->C3.basicData[i]);
////////////////////////////////////////////////////////////////////////////////////////////////////
    int cov2layerend = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
    xil_printf("%d cycles spent on cov2\n", cov2layerend - cov2layerstart);
	// 第四层的Pooling层
	inSize.c=cnn->S4.inputWidth;
	inSize.r=cnn->S4.inputHeight;
	outSize.c=inSize.c/cnn->S4.mapSize;
	outSize.r=inSize.r/cnn->S4.mapSize;
	for(i=0;i<(cnn->S4.outChannels);i++)
	{
		if(cnn->S4.poolType == AvePool)
			avgPooling(cnn->S4.y[i],outSize,cnn->C3.y[i],inSize,cnn->S4.mapSize);
	}

	// 输出层O5的处理
	// 首先需要将前面的多维输出展开成一维向量
	float O5inData[192];
	for(i = 0;i < (cnn->S4.outChannels);i++)
		for(r = 0;r < outSize.r;r++)
			for(c = 0;c < outSize.c;c++)
				O5inData[i*outSize.r*outSize.c+r*outSize.c+c]=cnn->S4.y[i][r][c];

	nSize nnSize = {cnn->O5.inputNum, cnn->O5.outputNum};

	nnff(cnn->O5.v, O5inData, cnn->O5.wData, cnn->O5.basicData, nnSize);

	// 计算每一个数字的概率
	for(i = 0;i < cnn->O5.outputNum;i++)
		cnn->O5.y[i] = activation_Sigma(cnn->O5.v[i],cnn->O5.basicData[i]);
}

// 激活函数 input是数据，inputNum说明数据数目，bas表明偏置
float activation_Sigma(float input,float bas) // sigma激活函数
{
	float temp = input + bas;
	// 在库函数里加一个 m参数才能够使用math这个库
	temp = 1.0/((1.0 + exp(-temp)));
	return temp;
}

void avgPooling(float** output,nSize outputSize,float** input,nSize inputSize,int mapSize) // 求平均值
{
	int outputW=inputSize.c/mapSize;
	int outputH=inputSize.r/mapSize;
	if(outputSize.c!=outputW||outputSize.r!=outputH)
		xil_printf("ERROR: output size is wrong!!");

	int i,j,m,n;
	for(i=0;i<outputH;i++)
		for(j=0;j<outputW;j++)
		{
			float sum=0.0;
			for(m=i*mapSize;m<i*mapSize+mapSize;m++)
				for(n=j*mapSize;n<j*mapSize+mapSize;n++)
					sum=sum+input[m][n];

			output[i][j]=sum/(float)(mapSize*mapSize);
		}
}

float vecMulti(float* vec1,float* vec2,int vecL)// 两向量相乘
{
	int i;
	float m=0;
	for(i=0;i<vecL;i++)
		m = m + vec1[i]*vec2[i];
	return m;
}

// 单层全连接神经网络的前向传播
void nnff(float* output,float* input,float** wdata,float* bas,nSize nnSize)
{
	int w = nnSize.c;
	int h = nnSize.r;
	
	int i;
	for(i = 0;i < h;i++)
		output[i] = vecMulti(input, wdata[i],w) + bas[i];
}

void cnnclear(CNN* cnn)
{
	// 将神经元的部分数据清除
	int j,c,r;
	// C1网络
	for(j = 0;j < cnn->C1.outChannels;j++)
	{
		for(r = 0;r < cnn->S2.inputHeight;r++)
		{
			for(c = 0;c < cnn->S2.inputWidth;c++)
			{
				cnn->C1.d[j][r][c] = (float)0.0;
				cnn->C1.v[j][r][c] = (float)0.0;
				cnn->C1.y[j][r][c] = (float)0.0;
			}
		}
	}
	// S2网络
	for(j = 0;j < cnn->S2.outChannels;j++)
	{
		for(r = 0;r < cnn->C3.inputHeight;r++)
		{
			for(c = 0;c < cnn->C3.inputWidth;c++)
			{
				cnn->S2.d[j][r][c]=(float)0.0;
				cnn->S2.y[j][r][c]=(float)0.0;
			}
		}
	}
	// C3网络
	for(j=0;j<cnn->C3.outChannels;j++)
	{
		for(r=0;r<cnn->S4.inputHeight;r++)
		{
			for(c=0;c<cnn->S4.inputWidth;c++)
			{
				cnn->C3.d[j][r][c]=(float)0.0;
				cnn->C3.v[j][r][c]=(float)0.0;
				cnn->C3.y[j][r][c]=(float)0.0;
			}
		}
	}
	// S4网络
	for(j=0;j<cnn->S4.outChannels;j++)
	{
		for(r=0;r<cnn->S4.inputHeight/cnn->S4.mapSize;r++)
		{
			for(c=0;c<cnn->S4.inputWidth/cnn->S4.mapSize;c++)
			{
				cnn->S4.d[j][r][c]=(float)0.0;
				cnn->S4.y[j][r][c]=(float)0.0;
			}
		}
	}
	// O5输出
	for(j=0;j<cnn->O5.outputNum;j++)
	{
		cnn->O5.d[j]=(float)0.0;
		cnn->O5.v[j]=(float)0.0;
		cnn->O5.y[j]=(float)0.0;
	}
}
