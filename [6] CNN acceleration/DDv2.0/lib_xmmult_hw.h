
#ifndef H_LIB_EXAMPLE_HW_H
#define H_LIB_EXAMPLE_HW_H

#define DIM    32
#define SIZE  ((DIM)*(DIM))

#define S 1
#define K 5
#define N 1 //input channel
#define M 6 //output channel
#define C 16
#define R 16
#define Tr 16//row
#define Tc 16//column
#define Tm 8//output channels
#define Tn 8//input channels

//#define INPUT_FM_SIZE (N*R*C)
//#define WEIGHTS_SIZE (M*N*K*K)
//#define OUTPUT_FM_SIZE (M*(R-K+1)*(C-K+1))

#define BLOCK_TO_ROW_ROW  (8*8)
#define BLOCK_TO_ROW_COL  (K*K)
#define BLOCK_TO_ROW_SIZE  (BLOCK_TO_ROW_ROW*BLOCK_TO_ROW_COL )
#define PATTERN_ROW  6
#define PATTERN_COL  (K*K)


#define INPUT_FM_SIZE BLOCK_TO_ROW_SIZE
#define WEIGHTS_SIZE (PATTERN_COL*PATTERN_ROW)
#define OUTPUT_FM_SIZE (BLOCK_TO_ROW_ROW*PATTERN_ROW)



//float Setup_HW_Accelerator(float A[DIM][DIM], float B[DIM][DIM], float res_hw[DIM][DIM], int dma_size);
//
//int Run_HW_Accelerator(float A[DIM][DIM], float B[DIM][DIM], float res_hw[DIM][DIM], int dma_size);
//
//void matrix_multiply_ref(float a[DIM][DIM], float b[DIM][DIM], float out[DIM][DIM]);
//int Setup_HW_Accelerator(int A[DIM*DIM], int B[DIM*DIM], int res_hw[DIM*DIM], int dma_size);
//
//int Run_HW_Accelerator(int A[DIM*DIM], int B[DIM*DIM], int res_hw[DIM*DIM], int dma_size);
//
//void matrix_multiply_ref(int a[DIM*DIM], int b[DIM*DIM], int out[DIM*DIM]);
int Setup_HW_Accelerator(float A[INPUT_FM_SIZE], float B[WEIGHTS_SIZE], float res_hw[OUTPUT_FM_SIZE], int dma_size);
//int Setup_HW_Accelerator(float A[INPUT_FM_SIZE], float B[WEIGHTS_SIZE], float res_hw[PATTERN_ROW][BLOCK_TO_ROW_ROW], int dma_size);
int Run_HW_Accelerator(float A[INPUT_FM_SIZE], float B[WEIGHTS_SIZE], float res_hw[OUTPUT_FM_SIZE], int dma_size);
//int Run_HW_Accelerator(float A[INPUT_FM_SIZE], float B[WEIGHTS_SIZE], float res_hw[PATTERN_ROW][BLOCK_TO_ROW_ROW], int dma_size);
void matrix_multiply_ref(float a[INPUT_FM_SIZE], float b[WEIGHTS_SIZE], float out[OUTPUT_FM_SIZE]);

#endif
