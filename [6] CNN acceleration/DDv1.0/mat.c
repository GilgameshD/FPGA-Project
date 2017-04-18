#include "mat.h"

float** rotate180(float** mat, nSize matSize)// ����ת180��
{
	int i,c,r;
	int outSizeW=matSize.c;
	int outSizeH=matSize.r;
	float** outputData = (float**)malloc(outSizeH*sizeof(float*));
	for(i = 0;i < outSizeH;i++)
		outputData[i] = (float*)malloc(outSizeW*sizeof(float));

	for(r = 0;r < outSizeH;r++)
		for(c = 0;c < outSizeW;c++)
			outputData[r][c] = mat[outSizeH-r-1][outSizeW-c-1];

	return outputData;
}

// ���ھ������ز��������ѡ��
// ���ﹲ������ѡ��full��same��valid���ֱ��ʾ
// fullָ��ȫ�����������Ĵ�СΪinSize+(mapSize-1)
// sameָͬ������ͬ��С
// validָ��ȫ������Ĵ�С��һ��ΪinSize-(mapSize-1)��С���䲻��Ҫ��������0����

//////////////////////////////// �����Ż� ///////////////////////////////////
float** correlation(float** map,nSize mapSize,float** inputData,nSize inSize,int type)// �����
{
	// ����Ļ�������ں��򴫲�ʱ���ã������ڽ�Map��ת180���پ��
	// Ϊ�˷�����㣬�����Ƚ�ͼ������һȦ
	// ����ľ��Ҫ�ֳ�������ż��ģ��ͬ����ģ��
	int i,j,c,r;
	int halfmapsizew;
	int halfmapsizeh;
	if(mapSize.r%2 == 0 && mapSize.c%2 == 0)
	{ // ģ���СΪż��
		halfmapsizew=(mapSize.c)/2; // ���ģ��İ���С
		halfmapsizeh=(mapSize.r)/2;
	}
	else
	{
		halfmapsizew=(mapSize.c-1)/2; // ���ģ��İ���С
		halfmapsizeh=(mapSize.r-1)/2;
	}

	// ������Ĭ�Ͻ���fullģʽ�Ĳ�����fullģʽ�������СΪinSize+(mapSize-1)
	int outSizeW=inSize.c+(mapSize.c-1); // ������������һ����
	int outSizeH=inSize.r+(mapSize.r-1);
	float** outputData=(float**)malloc(outSizeH*sizeof(float*)); // ����صĽ��������
	for(i=0;i<outSizeH;i++)
		outputData[i]=(float*)calloc(outSizeW,sizeof(float));

	// Ϊ�˷�����㣬��inputData����һȦ
	float** exInputData = matEdgeExpand(inputData,inSize,mapSize.c-1,mapSize.r-1);

	for(j=0;j<outSizeH;j++)
		for(i=0;i<outSizeW;i++)
			for(r=0;r<mapSize.r;r++)
				for(c=0;c<mapSize.c;c++)
				{
					outputData[j][i]=outputData[j][i]+map[r][c]*exInputData[j+r][i+c];
				}

	for(i=0;i<inSize.r+2*(mapSize.r-1);i++)
		free(exInputData[i]);
	free(exInputData);

	nSize outSize = {outSizeW,outSizeH};
	switch(type)
	{ // ���ݲ�ͬ����������ز�ͬ�Ľ��
	case full: // ��ȫ��С�����
			return outputData;
	case same:
		{
			float** sameres = matEdgeShrink(outputData,outSize,halfmapsizew,halfmapsizeh);
			for(i=0;i<outSize.r;i++)
				free(outputData[i]);
			free(outputData);
			return sameres;
		}
	case valid:
		{
			float** validres;
			if(mapSize.r%2==0&&mapSize.c%2==0)
				validres = matEdgeShrink(outputData,outSize,halfmapsizew*2-1,halfmapsizeh*2-1);
			else
				validres = matEdgeShrink(outputData,outSize,halfmapsizew*2,halfmapsizeh*2);
			for(i=0;i<outSize.r;i++)
				free(outputData[i]);
			free(outputData);
			return validres;
		}
	default:
		return outputData;
	}
}

float** cov(float** map,nSize mapSize,float** inputData,nSize inSize,int type) // �������
{
	// ���������������ת180�ȵ�����ģ���������
	float** flipmap = rotate180(map,mapSize); //��ת180�ȵ�����ģ��
	float** res = correlation(flipmap,mapSize,inputData,inSize,type);
	int i;

	for(i = 0;i < mapSize.r;i++)
		free(flipmap[i]);
	free(flipmap);
	return res;
}

float** cov_layer3(float** map,nSize mapSize,float** inputData,nSize inSize,int type) // �������
{
	// ���������������ת180�ȵ�����ģ���������
	float** flipmap = rotate180(map,mapSize); //��ת180�ȵ�����ģ��

	float* block_to_row_stream = (float*)malloc(8*8*5*5*sizeof(float));
	Matrix_TransForm(inputData, flipmap, block_to_row_stream, mapSize, inSize);

	int i,j,err=0;
    float** res = (float**)malloc((inSize.r - mapSize.r + 1)*sizeof(float*));
    for (i = 0; i < (inSize.r - mapSize.r + 1); i++)
        res[i] = (float*)malloc((inSize.c - mapSize.c + 1)*sizeof(float));

    float** res2 = (float**)malloc((inSize.r - mapSize.r + 1)*sizeof(float*));
    for (i = 0; i < (inSize.r - mapSize.r + 1); i++)
	    res2[i] = (float*)malloc((inSize.c - mapSize.c + 1)*sizeof(float));


	matrix_multiple_hw(block_to_row_stream, flipmap, res, mapSize, inSize);
	matrix_multiple(block_to_row_stream, flipmap, res2, mapSize, inSize);

	for (i = 0; i < 8; i++)
		for (j = 0; j < 8; j++)
			if (res[i][j]!=res2[i][j])
				err++;

	xil_printf("the error number is %d \n", err);

	for (i = 0; i < mapSize.r; i++)
		free(flipmap[i]);
	free(flipmap);
	free(block_to_row_stream);
    for (i = 0; i < (inSize.r - mapSize.r + 1); i++)
	    free(res[i]);
	return res;
}

// ����ά�����Ե��������addw��С��0ֵ��
float** matEdgeExpand(float** mat,nSize matSize,int addc,int addr)
{ // ������Ե����
	int i,j;
	int c=matSize.c;
	int r=matSize.r;
	float** res=(float**)malloc((r+2*addr)*sizeof(float*)); // ����ĳ�ʼ��
	for(i=0;i<(r+2*addr);i++)
		res[i]=(float*)malloc((c+2*addc)*sizeof(float));

	for(j=0;j<r+2*addr;j++)
	{
		for(i=0;i<c+2*addc;i++)
		{
			if(j<addr||i<addc||j>=(r+addr)||i>=(c+addc))
				res[j][i]=(float)0.0;
			else
				res[j][i]=mat[j-addr][i-addc]; // ����ԭ����������
		}
	}
	return res;
}

// ����ά�����Ե��С������shrinkc��С�ı�
float** matEdgeShrink(float** mat,nSize matSize,int shrinkc,int shrinkr)
{ // ��������С������Сaddw������Сaddh
	int i,j;
	int c=matSize.c;
	int r=matSize.r;
	float** res = (float**)malloc((r-2*shrinkr)*sizeof(float*)); // �������ĳ�ʼ��
	for(i = 0;i < (r-2*shrinkr);i++)
		res[i] = (float*)malloc((c-2*shrinkc)*sizeof(float));

	
	for(j=0;j<r;j++)
	{
		for(i=0;i<c;i++)
		{
			if(j>=shrinkr&&i>=shrinkc&&j<(r-shrinkr)&&i<(c-shrinkc))
				res[j-shrinkr][i-shrinkc] = mat[j][i]; // ����ԭ����������
		}
	}
	return res;
}

void addmat(float** res, float** mat1, nSize matSize1, float** mat2, nSize matSize2)// �������
{
	int i,j;

	for(i=0;i<matSize1.r;i++)
		for(j=0;j<matSize1.c;j++)
			res[i][j]=mat1[i][j]+mat2[i][j];
}

//////////////////////////////// �����Ż� ///////////////////////////////////
void multifactor(float** res, float** mat, nSize matSize, float factor)// �������ϵ��
{
	int i,j;
	for(i=0;i<matSize.r;i++)
		for(j=0;j<matSize.c;j++)
			res[i][j]=mat[i][j]*factor;
}

//////////////////////////////// �����Ż� ///////////////////////////////////
float summat(float** mat,nSize matSize) // �����Ԫ�صĺ�
{
	float sum=0.0;
	int i,j;
	for(i=0;i<matSize.r;i++)
		for(j=0;j<matSize.c;j++)
			sum=sum+mat[i][j];
	return sum;
}


void Matrix_TransForm(float** input_mat, float** conv_pattern, float* block_to_row_stream, nSize mapSize, nSize inSize)
{
	int start_r, start_c;
	int i, j;
	int p = 0;
	for (start_r = 0; start_r < inSize.r-mapSize.r+1; start_r++)
		for (start_c = 0; start_c <inSize.c-mapSize.c+1; start_c++)
			for (j = start_r; j < mapSize.r + start_r; j++)
				for (i = start_c; i < mapSize.c + start_c; i++)
				{
					block_to_row_stream[p] = input_mat[j][i];
					p = p + 1;
				}
	return;
	//throw block_to_row_stream and conv_pattern into DMA
}

void matrix_multiple(float* block_to_row_stream, float** flipmap, float** res, nSize mapSize, nSize inSize)
{
	int i,j,k;
	int pattern_size =  mapSize.r * mapSize.c;
	int block_row_size = (inSize.c - mapSize.c + 1)*(inSize.r - mapSize.r + 1);
//	for (l = 0; l < inSize.r - mapSize.r + 1; l++)
//		for (j = 0; j < inSize.c - mapSize.c + 1; j++)
//			for(i = 0; i < mapSize.r; i++)
//				for (k = 0; k < mapSize.c; k++)
//				{
//					res[l][j] = res[l][j] + block_to_row_stream[l*(inSize.c - mapSize.c + 1)+j)*pattern_size+i*mapSize.c+k]*flipmap[i][k];
//					p = p + 1;
//
	float *out = (float*)malloc(block_row_size*sizeof(float));
    for (i = 0; i < block_row_size; i++)
    {
        out[i] = 0;
    }
	for (j = 0; j < block_row_size; j++)
	{
		for(i = 0; i < mapSize.r; i++)
		{
			for (k = 0; k < mapSize.c; k++)
			{
				out[j] = out[j] + block_to_row_stream[j*pattern_size+i*mapSize.c+k]*flipmap[i][k];

			}
		}
	}

	for (i = 0; i < inSize.r - mapSize.r + 1; i++)
		for (j = 0; j < inSize.c - mapSize.c + 1; j++)
			res[i][j] = out[i * (inSize.c - mapSize.c + 1) + j];

	free(out);
}

void matrix_multiple_hw(float* block_to_row_stream, float** flipmap, float** res, nSize mapSize, nSize inSize)
{
	int i,j,k;
	int pattern_size =  mapSize.r * mapSize.c;
	int block_row_size = (inSize.c - mapSize.c + 1)*(inSize.r - mapSize.r + 1);
//	for (l = 0; l < inSize.r - mapSize.r + 1; l++)
//		for (j = 0; j < inSize.c - mapSize.c + 1; j++)
//			for(i = 0; i < mapSize.r; i++)
//				for (k = 0; k < mapSize.c; k++)
//				{
//					res[l][j] = res[l][j] + block_to_row_stream[l*(inSize.c - mapSize.c + 1)+j)*pattern_size+i*mapSize.c+k]*flipmap[i][k];
//					p = p + 1;
//
	float *map=(float*)malloc(25*sizeof(float));
	float *out = (float*)malloc(8*8*sizeof(float));
	for (i = 0; i < mapSize.r; i++)
		for (j = 0; j < mapSize.c; j++)
			map[i*5+j] = flipmap[i][j];

	Setup_HW_Accelerator(block_to_row_stream, map, out, 1024);
	Run_HW_Accelerator(block_to_row_stream, map, out, 1024);
	//matrix_multiply_ref(block_to_row_stream, map, out);

	for (i = 0; i < inSize.r - mapSize.r + 1; i++){
		for (j = 0; j < inSize.c - mapSize.c + 1; j++){
			res[i][j] = out[i * (inSize.c - mapSize.c + 1) + j];
			printf("%f ",res[i][j]);
		}
		printf("\n");
	}

	free(out);
	free(map);
}


