#include "cnn.h"
#include "minst.h"
#include "platform.h"
#include "xparameters.h"

//-----------------------------------------
#include <stdio.h>
#include "xil_io.h"
#include "platform.h"
#include "xparameters.h"
#include "xscugic.h"
#include "xaxidma.h"
#include "xmmult_accel_core.h"
#include "xil_printf.h"
#include "lib_xmmult_hw.h"
#include "xtmrctr.h"
#include "temp.h"

#define UPDATE_PACE (100000000)
#undef USE_HIGH_LEVEL_API_TIMERS

// AXI DMA Instance
XAxiDma AxiDma;

// TIMER Instance
XTmrCtr timer_dev;

int init_dma(){
	XAxiDma_Config *CfgPtr;
	int status;

	CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if(!CfgPtr){
		print("Error looking for AXI DMA config\n\r");
		return XST_FAILURE;
	}
	status = XAxiDma_CfgInitialize(&AxiDma,CfgPtr);
	if(status != XST_SUCCESS){
		print("Error initializing DMA\n\r");
		return XST_FAILURE;
	}
	//check for scatter gather mode
	if(XAxiDma_HasSg(&AxiDma)){
		print("Error DMA configured in SG mode\n\r");
		return XST_FAILURE;
	}
	/* Disable interrupts, we use polling mode */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DMA_TO_DEVICE);

	return XST_SUCCESS;
}


// 这是一个 LeNET-5 的CNN网络
int main(void)
{
	xil_printf("---------------------------------------------------------------\n");
	init_platform();
	int status = init_dma();
	if(status != XST_SUCCESS){
		print("\rError: DMA init failed\n");
		return XST_FAILURE;
	}
	print("\rDMA Init done\n\r");
	status = TmrCtrLowLevelExample(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	unsigned int init_time, curr_time, calibration;
	unsigned int begin_time;
	unsigned int end_time;
	unsigned int run_time_sw = 0;
	unsigned int run_time_hw = 0;

	init_time = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	curr_time = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);

	calibration = curr_time - init_time;
	xil_printf("\rCalibration report:\r\n");
	xil_printf("\rinit_time: %d cycles.\r\n", init_time);
	xil_printf("\rcurr_time: %d cycles.\r\n", curr_time);
	xil_printf("\rcalibration: %d cycles.\r\n", calibration);


	int testNumber = 110;
	xil_printf("start loading data...\n");
	ImgArr testImg = read_Img("images.txt", testNumber);
	LabelArr testLabel = read_Lable("labels.txt", testNumber);
	xil_printf("finish loading data...\n\n");

	nSize inputSize = {testImg->ImgPtr[0].c, testImg->ImgPtr[0].r};
	int outSize = testLabel->LabelPtr[0].l;

	// CNN结构的初始化
	CNN* cnn = malloc(sizeof(CNN));
	cnnsetup(cnn, inputSize, outSize);

	// CNN testing
	xil_printf("start testing data...\n");
	importcnn(cnn,"minst.cnn");
	int testNum = 1;
	begin_time = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	cnntest(cnn, testImg, testLabel, testNum);
	end_time = XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, TIMER_COUNTER_0);
	run_time_hw = end_time - begin_time - calibration;
	xil_printf("totally use %d cycles\n", run_time_hw);
	xil_printf("test finished... \n");

	cleanup_platform();
	return 0;
}
