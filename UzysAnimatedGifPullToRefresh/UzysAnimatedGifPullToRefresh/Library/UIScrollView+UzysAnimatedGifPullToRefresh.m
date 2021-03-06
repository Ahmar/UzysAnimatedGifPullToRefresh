//
//  UIScrollView+UzysAnimatedGifPullToRefresh.m
//  UzysAnimatedGifPullToRefresh
//
//  Created by Uzysjung on 2014. 4. 8..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import <objc/runtime.h>
#import <AnimatedGIFImageSerialization.h>
static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (UzysAnimatedGifPullToRefresh)
@dynamic pullToRefreshView, showPullToRefresh;

- (void)addPullToRefreshActionHandler:(actionHandler)handler
                       ProgressImages:(NSArray *)progressImages
                        LoadingImages:(NSArray *)loadingImages
              ProgressScrollThreshold:(NSInteger)threshold
               LoadingImagesFrameRate:(NSInteger)lframe;
{
    if(self.pullToRefreshView == nil)
    {
        UzysAnimatedGifActivityIndicator *view = [[UzysAnimatedGifActivityIndicator alloc] initWithProgressImages:progressImages LoadingImages:loadingImages ProgressScrollThreshold:threshold LoadingImagesFrameRate:lframe];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
    
}

- (void)addPullToRefreshActionHandler:(actionHandler)handler ProgressImages:(NSArray *)progressImages ProgressScrollThreshold:(NSInteger)threshold
{
    if(self.pullToRefreshView == nil)
    {
        UzysAnimatedGifActivityIndicator *view = [[UzysAnimatedGifActivityIndicator alloc] initWithProgressImages:progressImages LoadingImages:nil ProgressScrollThreshold:threshold LoadingImagesFrameRate:0];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}

- (void)addPullToRefreshActionHandler:(actionHandler)handler ProgressImagesGifName:(NSString *)progressGifName LoadingImagesGifName:(NSString *)loadingGifName ProgressScrollThreshold:(NSInteger)threshold
{
    UIImage *progressImage = [UIImage imageNamed:progressGifName];
    UIImage *loadingImage = [UIImage imageNamed:loadingGifName];
    
    [self addPullToRefreshActionHandler:handler ProgressImages:progressImage.images LoadingImages:loadingImage.images ProgressScrollThreshold:threshold LoadingImagesFrameRate:(NSInteger)(1.0/loadingImage.duration)];
}
- (void)addPullToRefreshActionHandler:(actionHandler)handler ProgressImagesGifName:(NSString *)progressGifName LoadingImagesGifName:(NSString *)loadingGifName ProgressScrollThreshold:(NSInteger)threshold LoadingImageFrameRate:(NSInteger)frameRate
{
    UIImage *progressImage = [UIImage imageNamed:progressGifName];
    UIImage *loadingImage = [UIImage imageNamed:loadingGifName];
    
    [self addPullToRefreshActionHandler:handler ProgressImages:progressImage.images LoadingImages:loadingImage.images ProgressScrollThreshold:threshold LoadingImagesFrameRate:frameRate];
}
- (void)addPullToRefreshActionHandler:(actionHandler)handler ProgressImagesGifName:(NSString *)progressGifName ProgressScrollThreshold:(NSInteger)threshold
{
    UIImage *progressImage = [UIImage imageNamed:progressGifName];
    [self addPullToRefreshActionHandler:handler ProgressImages:progressImage.images ProgressScrollThreshold:threshold];
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}
- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}
#pragma mark - property
- (void)setPullToRefreshView:(UzysAnimatedGifActivityIndicator *)pullToRefreshView
{
    [self willChangeValueForKey:@"UzysAnimatedGifActivityIndicator"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysAnimatedGifActivityIndicator"];
}
- (UzysAnimatedGifActivityIndicator *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.pullToRefreshView.isObserving)
        {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToRefreshView.isObserving)
        {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}

- (void)setShowAlphaTransition:(BOOL)showAlphaTransition
{
    self.pullToRefreshView.showAlphaTransition = showAlphaTransition;
}
- (BOOL)showAlphaTransition
{
    return self.pullToRefreshView.showAlphaTransition;
}
@end
