#ifndef __MINST_
#define __MINST_

#include <stdlib.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"

typedef struct MinstImg
{
	int c;           // ͼ���
	int r;           // ͼ���
	float** ImgData; // ͼ�����ݶ�ά��̬����
}MinstImg;

typedef struct MinstImgArr
{
	int ImgNum;        // �洢ͼ�����Ŀ
	MinstImg* ImgPtr;  // �洢ͼ������ָ��
}*ImgArr;              // �洢ͼ�����ݵ�����

typedef struct MinstLabel
{
	int l;            // �����ǵĳ�
	float LabelData[10]; // ����������
}MinstLabel;

typedef struct MinstLabelArr
{
	int LabelNum;
	MinstLabel *LabelPtr;
}*LabelArr;              // �洢ͼ���ǵ�����

LabelArr read_Lable(const char* filename, int); // ����ͼ����
ImgArr read_Img(const char* filename, int); // ����ͼ��


#endif
