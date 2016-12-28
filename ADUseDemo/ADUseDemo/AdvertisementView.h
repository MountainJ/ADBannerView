//
//  AdvertisementView.h
//
//
//  Created by JAY on 16/1/23.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ADV_Type)
{
    ADV_Type_System = 1,//系统默认圆形PageControl
    ADV_Type_Rect = 2,//方形PageControl
};

typedef NS_ENUM(NSInteger, AdvertisementViewType)
{
    //首页
    AdvertisementViewTypeHomePage = 1,
};


typedef void (^TapImageBlock)(NSInteger index);

@protocol AdvertisementViewDelegate <NSObject>
-(void)TapAtIndex:(NSInteger)index;
@end

@interface AdvertisementView : UIView
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic,copy) TapImageBlock tapMyImageBlock;
@property (nonatomic, weak) id<AdvertisementViewDelegate> delegate;

@property (nonatomic, assign) AdvertisementViewType  adType;

-(instancetype)initWithFrame:(CGRect)frame AndImagesArray:(NSArray *)imagesArray;
-(instancetype)initWithFrame:(CGRect)frame AndUrlArray:(NSArray *)imageUrlArray;

//开始滚动
-(void)begin;

//停止滚动
-(void)stop;

//设置PageControl类型
-(void)setPageControlType:(ADV_Type)type;

@end
