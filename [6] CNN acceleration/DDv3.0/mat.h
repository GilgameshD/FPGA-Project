// ������ļ���Ҫ���ڹ��ڶ�ά��������Ĳ���
#ifndef __MAT_
#define __MAT_

#include <stdlib.h>
#include "lib_xmmult_hw.h"

#define full 0
#define same 1
#define valid 2

typedef struct Mat2DSize
{
	int c; // �У���
	int r; // �У��ߣ�
}nSize;

float** rotate180(float** mat, nSize matSize);// ����ת180��
void addmat(float** res, float** mat1, nSize matSize1, float** mat2, nSize matSize2);// �������
float** correlation(float** map,nSize mapSize,float** inputData,nSize inSize,int type);// �����
float** cov(float** map,nSize mapSize,float** inputData,nSize inSize,int type); // �������
float** cov_layer3(float** map,nSize mapSize,float** inputData,nSize inSize,int type);

// ����ά�����Ե��������addw��С��0ֵ��
float** matEdgeExpand(float** mat,nSize matSize,int addc,int addr);
// ����ά�����Ե��С������shrinkc��С�ı�
float** matEdgeShrink(float** mat,nSize matSize,int shrinkc,int shrinkr);
void multifactor(float** res, float** mat, nSize matSize, float factor);// �������ϵ��
float summat(float** mat,nSize matSize);// �����Ԫ�صĺ�
void Matrix_TransForm(float** input_mat, float* block_to_row_stream, nSize mapSize, nSize inSize);
void Matrix_TransForm_28x28(float** input_mat, float block_to_row_stream[9][40*40], nSize mapSize, nSize inSize);
void matrix_multiple(float* block_to_row_stream, float** flipmap, float** res,  nSize mapSize, nSize inSize);
void matrix_multiple_hw(float* block_to_row_stream, float flipmap[6][25], float res[6][64], nSize mapSize, nSize inSize);
void cov_layer3_6(float map[6][25],nSize mapSize,float** inputData, float mapout[6][64], nSize inSize,int type); // �������
float** cov_layer1_6(float flipmap[6][25], nSize mapSize, float** inputData, nSize inSize, int type);
#endif
