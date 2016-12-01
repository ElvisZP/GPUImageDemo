//
//  ViewController.m
//  GPUImageDemo
//
//  Created by zhangpeng on 2016/11/29.
//  Copyright © 2016年 elviszp. All rights reserved.
//

#import "ViewController.h"
//#import "GPUImage.h"
#import <GPUImage/GPUImageFramework.h>

@interface ViewController (){
    GPUImageView *_captureVideoPreview;
    GPUImageVideoCamera *_videoCamera;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pipeSimple];
}

-(void)simpleFilter{
    UIImage *inputImage = [UIImage imageNamed:@"gyy"];
    
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
    //添加上滤镜
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    //加载出来
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    imageView.frame = CGRectMake(0,50,inputImage.size.width ,inputImage.size.height);
    [self.view addSubview:imageView];
}

-(void)pipeSimple{
    UIImage *inputImage = [UIImage imageNamed:@"gyy"];
    
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
    GPUImageView *gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0,50,inputImage.size.width ,inputImage.size.height)];
    [self.view addSubview:gpuImageView];
    
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    GPUImageFilterPipeline *pipeline = [[GPUImageFilterPipeline alloc]initWithOrderedFilters:@[filter] input:stillImageSource output:gpuImageView];
    [stillImageSource processImage];
    [filter useNextFrameForImageCapture];
    
    
    UIImage *newImage = [pipeline currentFilteredFrame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    imageView.frame = CGRectMake(0,250,inputImage.size.width ,inputImage.size.height);
    [self.view addSubview:imageView];
}


-(void)video{
    /**
     创建视频源
     sessionPreset:屏幕分辨率
     cameraPosition:摄像头位置
     */
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    // 创建最终预览View
    _captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_captureVideoPreview atIndex:0];
    
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    GPUImageFilterPipeline *pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:@[bilateralFilter] input:_videoCamera output:_captureVideoPreview];
        GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    [pipeline addFilter:sepiaFilter];
    //可添加多个滤镜
    [_videoCamera startCameraCapture];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
