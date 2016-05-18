//
//  PictureViewController.m
//  errand
//
//  Created by wjjxx on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@property CGRect frame1;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.imageView = [[UIImageView alloc]initWithImage:_image];
    
    CGFloat widthRatio = SCREEN_WIDTH/_image.size.width;
    CGFloat heightRatio = SCREEN_HEIGHT/_image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    if (initialZoom > 1) {
        initialZoom = 1;
    }
    
    CGRect r = CGRectZero;
    r.size.width = _image.size.width * initialZoom;
    r.size.height = _image.size.height * initialZoom;
    self.imageView.frame = r;
    
    self.imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    //图片的大小 比真实的大一些 缩小了一半
//    self.imageView.frame  = CGRectMake((SCREEN_WIDTH - _image.size.width/2)/2, (SCREEN_HEIGHT - _image.size.height/2)/2, _image.size.width/2 , _image.size.height/2);
    
//    self.imageView.frame  = CGRectMake((SCREEN_WIDTH - _image.size.width)/2, (SCREEN_HEIGHT - _image.size.height)/2, _image.size.width , _image.size.height);

    [self.view addSubview:self.imageView];
    self.view.multipleTouchEnabled = YES;
    [self.imageView setUserInteractionEnabled:YES];
    
//    点击手势
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeImage:)];
    [self.imageView addGestureRecognizer:tapGestureRecongnizer];
    //捏合手势
    UIPinchGestureRecognizer *pinchGestureRecongnizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [self.imageView addGestureRecognizer:pinchGestureRecongnizer];
     self.frame1 = self.imageView.frame;
    
}

- (void)changeImage:(UIPinchGestureRecognizer*)pinchGestureRecognizer {
    if ((pinchGestureRecognizer.state == UIGestureRecognizerStateEnded )&& (pinchGestureRecognizer.view.size.height < self.frame1.size.height)) {
        //重置
         pinchGestureRecognizer.view.transform = CGAffineTransformIdentity;
        
//        pinchGestureRecognizer.view.frame = self.frame1;
//        pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    }else{

        //形变
        // pinchGestureRecognizer.view.transform = CGAffineTransformMakeScale(pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        //在形变基础上,再形变
         pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
   
    
    
}
- (void)closeImage:(UITapGestureRecognizer*)tapGestureRecongnizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
