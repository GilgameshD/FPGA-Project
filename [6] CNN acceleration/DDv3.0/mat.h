// 这里库文件主要存在关于二维矩阵数组的操作
#ifndef __MAT_
#define __MAT_

#include <stdlib.h>
#include "lib_xmmult_hw.h"

#define full 0
#define same 1
#define valid 2

typedef struct Mat2DSize
{
	int c; // 列（宽）
	int r; // 行（高）
}nSize;

float** rotate180(float** mat, nSize matSize);// 矩阵翻转180度
void addmat(float** res, float** mat1, nSize matSize1, float** mat2, nSize matSize2);// 矩阵相加
float** correlation(float** map,nSize mapSize,float** inputData,nSize inSize,int type);// 互相关
float** cov(float** map,nSize mapSize,float** inputData,nSize inSize,int type); // 卷积操作
float** cov_layer3(float** map,nSize mapSize,float** inputData,nSize inSize,int type);

// 给二维矩阵边缘扩大，增加addw大小的0值边
float** matEdgeExpand(float** mat,nSize matSize,int addc,int addr);
// 给二维矩阵边缘缩小，擦除shrinkc大小的边
float** matEdgeShrink(float** mat,nSize matSize,int shrinkc,int shrinkr);
void multifactor(float** res, float** mat, nSize matSize, float factor);// 矩阵乘以系数
float summat(float** mat,nSize matSize);// 矩阵各元素的和
void Matrix_TransForm(float** input_mat, float* block_to_row_stream, nSize mapSize, nSize inSize);
void Matrix_TransForm_28x28(float** input_mat, float block_to_row_stream[9][40*40], nSize mapSize, nSize inSize);
void matrix_multiple(float* block_to_row_stream, float** flipmap, float** res,  nSize mapSize, nSize inSize);
void matrix_multiple_hw(float* block_to_row_stream, float flipmap[6][25], float res[6][64], nSize mapSize, nSize inSize);
void cov_layer3_6(float map[6][25],nSize mapSize,float** inputData, float mapout[6][64], nSize inSize,int type); // 卷积操作
float** cov_layer1_6(float flipmap[6][25], nSize mapSize, float** inputData, nSize inSize, int type);
#endif
