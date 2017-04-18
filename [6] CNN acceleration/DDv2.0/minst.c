#include "minst.h"
#include "xsdps.h"		/* SD device driver */
#include "ff.h"
#include "xil_cache.h"
#include "xplatform_info.h"

//英特尔处理器和其他低端机用户必须翻转头字节。(小端)
int ReverseInt(int i)   
{  
	unsigned char ch1, ch2, ch3, ch4;  
	ch1 = i & 255;  
	ch2 = (i >> 8) & 255;  
	ch3 = (i >> 16) & 255;  
	ch4 = (i >> 24) & 255;  
	return((int) ch1 << 24) + ((int)ch2 << 16) + ((int)ch3 << 8) + ch4;  
}

ImgArr read_Img(const char* filename, int testNumber) // 读入图像
{
	UINT NumBytesRead;
	FATFS fatfs;
	TCHAR *Path = "0:/";
	FRESULT Res;
	FIL fp;

	Res = f_mount(&fatfs, Path, 0);

	if (Res != FR_OK)
	{
		xil_printf("mount failed\n");
	}

	Res = f_open(&fp, filename, FA_READ);

	if(Res)
	{
		xil_printf("open image file failed\n");
		exit(1);
	}

	int magic_number = 0;  
	int number_of_images = 0;  
	int n_rows = 0;  
	int n_cols = 0;  

	Res = f_read(&fp, (char*)&magic_number,  sizeof(magic_number), &NumBytesRead);
	magic_number = ReverseInt(magic_number);

	Res = f_read(&fp, (char*)&number_of_images,  sizeof(number_of_images), &NumBytesRead);
	number_of_images = ReverseInt(number_of_images);    
	xil_printf("the count of image is %d\n", number_of_images);

	Res = f_read(&fp, (char*)&n_rows,  sizeof(n_rows), &NumBytesRead);
	n_rows = ReverseInt(n_rows);

	Res = f_read(&fp, (char*)&n_cols,  sizeof(n_cols), &NumBytesRead);
	n_cols = ReverseInt(n_cols);  

	//获取第i幅图像，保存到vec中 
	int i,r,c;

	// 图像数组的初始化
	ImgArr imgarr=(ImgArr)malloc(sizeof(ImgArr));
	imgarr->ImgNum = 1;
	imgarr->ImgPtr=(MinstImg*)malloc(sizeof(MinstImg));

	unsigned char temp = 0;
	for(i = 0; i < testNumber; ++i)
	{  
		for(r = 0; r < n_rows; ++r)
		{
			for(c = 0; c < n_cols; ++c)
			{
				Res = f_read(&fp, (char*)&temp,  sizeof(temp), &NumBytesRead);
			}
		}
		if(i == testNumber-1)
		{
			imgarr->ImgPtr[0].r = n_rows;
			imgarr->ImgPtr[0].c = n_cols;
			imgarr->ImgPtr[0].ImgData = (float**)malloc(n_rows*sizeof(float*));
			for(r = 0; r < n_rows; ++r)
			{
				imgarr->ImgPtr[0].ImgData[r]=(float*)malloc(n_cols*sizeof(float));
				for(c = 0; c < n_cols; ++c)
				{
					Res = f_read(&fp, (char*)&temp,  sizeof(temp), &NumBytesRead);
					imgarr->ImgPtr[0].ImgData[r][c] = (float)temp/255.0;
					printf("%f ", imgarr->ImgPtr[0].ImgData[r][c]);
				}
				printf("\n");
			}
		}
	}

	Res = f_close(&fp);
	return imgarr;
}

LabelArr read_Lable(const char* filename, int testNumber) // 读入标签
{
	UINT NumBytesRead;
	FATFS fatfs;
	TCHAR *Path = "0:/";
	FRESULT Res;
	Res = f_mount(&fatfs, Path, 0);
	FIL fp;

	if (Res != FR_OK)
	{
		xil_printf("mount failed\n");
	}

	Res = f_open(&fp, filename, FA_READ);

	if(Res)
	{
		xil_printf("open label file failed\n");
		exit(1);
	}

	int magic_number = 0;  
	int number_of_labels = 0; 

	Res = f_read(&fp, (char*)&magic_number,  sizeof(magic_number), &NumBytesRead);
	magic_number = ReverseInt(magic_number);  

	Res = f_read(&fp, (char*)&number_of_labels,  sizeof(number_of_labels), &NumBytesRead);
	number_of_labels = ReverseInt(number_of_labels);    
	xil_printf("the count of label is: %d\n", number_of_labels);

	int i, j;

	// 图像标记数组的初始化
	LabelArr labarr = (LabelArr)malloc(sizeof(LabelArr));
	labarr->LabelNum = 1;
	labarr->LabelPtr = (MinstLabel*)malloc(sizeof(MinstLabel));
	
	unsigned char temp = 0;
	for(i = 0; i < testNumber; ++i)
	{
		Res = f_read(&fp, (char*)&temp,  sizeof(temp), &NumBytesRead);
		if(i == testNumber-1)
		{
			for(j = 0;j < 10; j++)
				labarr->LabelPtr[0].LabelData[j] = 0;

			labarr->LabelPtr[0].l = 10;
			Res = f_read(&fp, (char*)&temp,  sizeof(temp), &NumBytesRead);
			labarr->LabelPtr[0].LabelData[(int)temp] = 1.0;
		}
	}

	f_close(&fp);
	return labarr;	
}
