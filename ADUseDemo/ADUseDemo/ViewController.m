//
//  ViewController.m
//  ADUseDemo
//
//  Created by Jayzy on 16/12/28.
//  Copyright © 2016年 MountainJay. All rights reserved.
//

#import "ViewController.h"

#import "AdvertisementView.h"

@interface ViewController ()<AdvertisementViewDelegate>

@property (nonatomic, strong) AdvertisementView * adView;//广告滚动窗口

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //广告滚动条开始滚动
    [self.adView begin];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //广告滚动条停止滚动
    [self.adView stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
     self.view.backgroundColor = [UIColor lightGrayColor];
    
    // Do any additional setup after loading the view, typically from a nib.
         NSArray *imgArr = @[@"http://www.51kys.com.cn/ADMINSYS/images/YSTP/TPYL/46.png",@"http://www.51kys.com.cn/ADMINSYS/images/YSTP/TPYL/44.png"];
         self.adView = [[AdvertisementView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 180) AndUrlArray:imgArr];
        self.adView.delegate = self;
        self.adView.adType = AdvertisementViewTypeHomePage;
        [self.view addSubview:self.adView];

}

#pragma mark  CBAdvertisementViewDelegate
-(void)TapAtIndex:(NSInteger)index{

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
