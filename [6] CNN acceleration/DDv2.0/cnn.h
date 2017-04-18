#ifndef __CNN_
#define __CNN_

#include <math.h>
#include "mat.h"
#include "minst.h"

#define AvePool 0
#define MaxPool 1
#define MinPool 2

// �����
typedef struct convolutional_layer
{
	int inputWidth;   //����ͼ��Ŀ�
	int inputHeight;  //����ͼ��ĳ�
	int mapSize;      //����ģ��Ĵ�С��ģ��һ�㶼��������

	int inChannels;   //����ͼ�����Ŀ
	int outChannels;  //���ͼ�����Ŀ

	// ��������ģ���Ȩ�طֲ���������һ����ά����
	// ���СΪinChannels*outChannels*mapSize*mapSize��С
	// ��������ά���飬��Ҫ��Ϊ�˱���ȫ���ӵ���ʽ��ʵ���Ͼ���㲢û���õ�ȫ���ӵ���ʽ
	// �����������DeapLearningToolboox���CNN���ӣ����õ�����ȫ����
	float**** mapData;     //�������ģ�������
	float**** dmapData;    //�������ģ������ݵľֲ��ݶ�

	float* basicData;   //ƫ�ã�ƫ�õĴ�С��ΪoutChannels
	int isFullConnect; //�Ƿ�Ϊȫ����
	int* connectModel; //����ģʽ��Ĭ��Ϊȫ���ӣ�

	// �������ߵĴ�Сͬ�����ά����ͬ
	float*** v; // ���뼤���������ֵ
	float*** y; // ���������Ԫ�����

	// ������صľֲ��ݶ�
	float*** d; // ����ľֲ��ݶ�,��ֵ  
}CovLayer;

// ������ pooling
typedef struct pooling_layer
{
	int inputWidth;   //����ͼ��Ŀ�
	int inputHeight;  //����ͼ��ĳ�
	int mapSize;      //����ģ��Ĵ�С

	int inChannels;   //����ͼ�����Ŀ
	int outChannels;  //���ͼ�����Ŀ

	int poolType;     //Pooling�ķ���
	float* basicData;   //ƫ��

	float*** y; // ������������Ԫ�����,�޼����
	float*** d; // ����ľֲ��ݶ�,��ֵ
}PoolLayer;

// ����� ȫ���ӵ�������
typedef struct nn_layer
{
	int inputNum;   //�������ݵ���Ŀ
	int outputNum;  //������ݵ���Ŀ

	float** wData; // Ȩ�����ݣ�Ϊһ��inputNum*outputNum��С
	float* basicData;   //ƫ�ã���СΪoutputNum��С

	// �������ߵĴ�Сͬ�����ά����ͬ
	float* v; // ���뼤���������ֵ
	float* y; // ���������Ԫ�����
	float* d; // ����ľֲ��ݶ�,��ֵ

	int isFullConnect; //�Ƿ�Ϊȫ����
}OutLayer;

typedef struct cnn_network
{
	// һ����5��
	int layerNum;
	CovLayer C1;
	PoolLayer S2;
	CovLayer C3;
	PoolLayer S4;
	OutLayer O5;

}CNN;

//
void cnnsetup(CNN* cnn,nSize inputSize,int outputSize);

// ����cnn����
float cnntest(CNN* cnn, ImgArr inputData,LabelArr outputData,int testNum);

// ����cnn������
void importcnn(CNN* cnn, const char* filename);

// ��ʼ�������
CovLayer initCovLayer(int inputWidth,int inputHeight,int mapSize,int inChannels,int outChannels);

// ��ʼ��������
PoolLayer initPoolLayer(int inputWidth,int inputHeigh,int mapSize,int inChannels,int outChannels,int poolType);

// ��ʼ�������
OutLayer initOutLayer(int inputNum,int outputNum);

// ����� input�����ݣ�inputNum˵��������Ŀ��bas����ƫ��
float activation_Sigma(float input,float bas); // sigma�����

void cnnff(CNN* cnn,float** inputData); // �����ǰ�򴫲�

void cnnclear(CNN* cnn); // ������vyd����

/*
	Pooling Function
	input ��������
	inputNum ����������Ŀ
	mapSize ��ƽ����ģ������
*/
void avgPooling(float** output,nSize outputSize,float** input,nSize inputSize,int mapSize); // ��ƽ��ֵ

//	����ȫ����������Ĵ���
void nnff(float* output,float* input,float** wdata,float* bas,nSize nnSize); // ����ȫ�����������ǰ�򴫲�

#endif
