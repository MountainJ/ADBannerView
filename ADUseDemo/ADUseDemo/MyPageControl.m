//
//  MyPageControl.m
//
//
//  Created by JAY on 13-10-31.
//  Copyright (c) 2013年 . All rights reserved.
//
#define KAUTOFIT 5

#import "MyPageControl.h"

@implementation MyPageControl

@synthesize kSpacing;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
            [self setPageIndicatorTintColor:[UIColor clearColor]];
        }
        [self setBackgroundColor:[UIColor clearColor]];
        activeImage = [[UIImage imageNamed:@"focus_black1.png"] retain];
        inactiveImage = [[UIImage imageNamed:@"focus_white1.png"] retain];
        kSpacing = [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f ? 10.0f : 5.0f;
        _usedToRetainOriginalSubview=[NSArray arrayWithArray:self.subviews];
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
        self.contentMode=UIViewContentModeRedraw;
        [self setCurrentPage:0];
    }
    return self;
}

-(void) updateDots{

    UIImageView *dot = nil;
    for ( int i = 0; i< [self.subviews count]; i++) {
        UIView* subview  = [self.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIImageView class]])
        {
            dot = (UIImageView*)subview;
            if (i == self.currentPage)
                dot.image = activeImage;
            else
                dot.image = inactiveImage;
        }
    }

}

-(void) setCurrentPage:(NSInteger)page
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self updateDots];
    }
    [super setCurrentPage:page];
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)iRect
{
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0){//加个判断
        int i;
        CGRect rect;
        UIImage *image;
        iRect = self.bounds;
        if ( self.opaque ) {
            [self.backgroundColor set];
            UIRectFill( iRect );
        }
        if ( self.hidesForSinglePage && self.numberOfPages == 1 ) return;
        rect.size.height = activeImage.size.height-KAUTOFIT;
        rect.size.width = self.numberOfPages * activeImage.size.width + ( self.numberOfPages - 1 ) * kSpacing;
        rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
        rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
        rect.size.width = activeImage.size.width-KAUTOFIT;
        for ( i = 0; i < self.numberOfPages; ++i ) {
            image = i == self.currentPage ? activeImage : inactiveImage;
            [image drawInRect: rect];
            rect.origin.x += activeImage.size.width + kSpacing;
        }
    }
}
- (void)dealloc{
    [activeImage release];
    activeImage = nil;
    [inactiveImage release];
    inactiveImage = nil;
    [super dealloc];
}

@end
