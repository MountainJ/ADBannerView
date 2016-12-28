//
//  AdvertisementView.m
//
//  Created by JAY on 16/1/23.
//  Copyright © 2016年 . All rights reserved.
//

#import "AdvertisementView.h"
#import "MyPageControl.h"
#import <objc/runtime.h>

#import "UIImageView+WebCache.h"

//默认图片
#define IMAGE_DEFAULT @""
//BANNER滚动时间间隔
#define TIME_SCROLL 3.0f

@interface AdvertisementView()<UIScrollViewDelegate>
{
    CGFloat imageWidth;//图片宽度
    CGFloat imageHeight;//图片高度
}
@property (nonatomic, strong)NSArray *imagesArray;

//网络图片地址数组
@property (nonatomic, strong) NSArray * urlArray;

@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong) MyPageControl * myPageControl;

//为图片数量+2
@property (nonatomic, assign)NSInteger pageCount;

//包含收尾两张图片之后的下表
@property (nonatomic, assign)NSInteger currentPage;

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation AdvertisementView
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        self.currentPage = 1;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.bounds.size.width, 20)];
    }
    return _pageControl;
}

-(MyPageControl *)myPageControl{
    if(!_myPageControl){
        CGFloat pcWidth = 15 * (self.pageCount -2);
        _myPageControl=[[MyPageControl alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10- pcWidth , self.bounds.size.height - 15 , pcWidth, 10)];
        _myPageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _myPageControl.tintColor = [UIColor whiteColor];
    }
    return _myPageControl;
}

-(instancetype)initWithFrame:(CGRect)frame AndImagesArray:(NSArray *)imagesArray{
    if(self = [super initWithFrame:frame]){
        self.imagesArray = imagesArray;
        self.pageCount = imagesArray?(imagesArray.count+2):0;
        [self createUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame AndUrlArray:(NSArray *)imageUrlArray{
    if(self = [super initWithFrame:frame]){
        //如果传入空数组则直接返回
        if(!imageUrlArray.count || imageUrlArray.count == 0){
            return self;
        }
        self.urlArray = imageUrlArray;
        self.currentPage = 1;
        self.pageCount = imageUrlArray.count+2;
        [self createUIWithUrl];
        //如果只有一张图片则不滚动
        if(imageUrlArray.count > 1){
             [self createTimer];
        }else{
            [self.scrollView setScrollEnabled:NO];
        }
    }
    return self;
}

-(void)scrollToNextPage{
    if(self.currentPage == 1){
        [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width *self.currentPage, 0)];
          [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*self.currentPage, 0, self.bounds.size.width, 20) animated:NO];
    }
    self.currentPage ++;
    if(self.currentPage == self.pageCount-1){
        self.myPageControl.currentPage = 0;
        self.pageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = self.currentPage - 1;
        self.pageControl.currentPage = self.currentPage - 1;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*self.currentPage, 0, self.bounds.size.width, 20) animated:YES];
    if(self.currentPage == self.pageCount - 1){
        self.currentPage = 1;
    }
}

#pragma mark - 加载网络图片
-(void)createUIWithUrl{
    imageWidth = self.frame.size.width;
    imageHeight = self.frame.size.height;
    for(int i=0; i<self.pageCount; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        btn.tag = i;
        if(i == 0){
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[self.pageCount - 3]] placeholderImage:[UIImage imageNamed:IMAGE_DEFAULT]];
        }else if(i == self.pageCount-1){
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[0]] placeholderImage:[UIImage imageNamed:IMAGE_DEFAULT]];
        }else{
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[i-1]] placeholderImage:[UIImage imageNamed:IMAGE_DEFAULT]];
        }
        [self.scrollView addSubview:imgView];
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth *self.pageCount, imageHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self scrollToPage:self.currentPage];
    
   
    //如果只有一张图片则不需要PageControl
    if(self.pageCount > 3){
         //MyPageControl
        [self addSubview:self.myPageControl];
        self.myPageControl.numberOfPages = self.pageCount-2;
        self.myPageControl.currentPage = 0;
        self.myPageControl.userInteractionEnabled = NO;
        
        //系统自带PageControl
        [self addSubview:self.pageControl];
        self.pageControl.numberOfPages = self.pageCount -2;
        self.pageControl.currentPage = 0;
        self.pageControl.userInteractionEnabled = NO;
        [self.pageControl setHidden:YES];
    }
}

#pragma mark - 定时器
-(void)createTimer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_SCROLL target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

-(void)stopTimer{
    if(_timer){
        if([_timer isValid]){
            [_timer invalidate];
            _timer = nil;
        }
    }
}

-(void)stop{
    [self stopTimer];
}

-(void)begin{
    //如果只有一张图片则不能滚动
    if(self.pageCount <=3){
        [self.scrollView setScrollEnabled:NO];
        return;
    }
    [self createTimer];
}

#pragma mark - 加载本地图片
-(void)createUI{
    imageWidth = self.frame.size.width;
    imageHeight = self.frame.size.height;

    for(int i=0; i<self.pageCount; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, imageHeight)];
        imgView.userInteractionEnabled = YES;
         btn.tag = i;
        
        if(i == 0){
            imgView.image = [UIImage imageNamed:self.imagesArray[self.pageCount-3]];
        }else if(i == self.pageCount-1){
            imgView.image = [UIImage imageNamed:self.imagesArray[0]];
        }else{
            imgView.image = [UIImage imageNamed:self.imagesArray[i-1]];
        }
        [self.scrollView addSubview:imgView];
        
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth *self.pageCount, imageHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self scrollToPage:self.currentPage];
    
    self.myPageControl.numberOfPages = self.pageCount-2;
    self.myPageControl.currentPage = 0;
    self.myPageControl.userInteractionEnabled = NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self createTimer];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.currentPage = offsetX / self.frame.size.width;
    if(self.currentPage == 0){
        self.myPageControl.currentPage = self.pageCount-2;
        self.pageControl.currentPage = self.pageCount-2;
        [self scrollToPage:self.pageCount-2];
        self.currentPage = self.pageCount - 2;
    }else if(self.currentPage == self.pageCount-1){
        self.myPageControl.currentPage = 0;
        self.pageControl.currentPage = 0;
        [self scrollToPage:1];
        self.currentPage = 1;
    }else{
        self.myPageControl.currentPage= self.currentPage - 1;
        self.pageControl.currentPage= self.currentPage - 1;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self stopTimer];
}

-(void)scrollToPage:(NSInteger)page{
    [self.scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*page, 0, self.bounds.size.width, 20) animated:NO];
}

#pragma mark - 点击事件
-(void)clickBtn:(UIButton *)btn{
    NSInteger index= btn.tag - 1;
    if(index == -1){
        index = self.pageCount - 1;
    }else if(index >= self.pageCount-2){
        index = 0;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(TapAtIndex:)]){
        [_delegate TapAtIndex:index];
    }
}

-(void)setPageControlType:(ADV_Type)type{
    switch (type) {
        case ADV_Type_System:
        {
            [self.myPageControl setHidden:YES];
            [self.pageControl setHidden:NO];
        }
            break;
        case ADV_Type_Rect:
        {
            [self.myPageControl setHidden:NO];
            [self.pageControl setHidden:YES];

        }
            break;
        default:
            break;
    }
}

-(void)dealloc{
    [self stopTimer];
}





@end
