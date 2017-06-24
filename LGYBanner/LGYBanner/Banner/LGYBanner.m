//
//  LGYBanner.m
//  广告页
//
//  Created by 李冠余 on 2017/6/1.
//  Copyright © 2017年 李冠余. All rights reserved.
//
#import "LGYBanner.h"
#import "LGYBaseBannerView.h"
#import "LGYPageControl.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
/* 循环利用图片数目 */
static int const BannerItemsCount = 5;
#define kDefaultscrollTimeInterval 3
@interface LGYBanner ()<UIScrollViewDelegate>
/* 图片轮播期的滚动视图 */
@property (weak, nonatomic) UIScrollView *scrollView;
/* 图片轮播期的滚动视图 */
@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic, weak) LGYPageControl * pageControl;
@property (nonatomic, assign) NSUInteger lastShowPage;
@property (nonatomic, assign) BOOL isLocalImageBanner;
@property (nonatomic, strong) LGYBaseBannerView * currSelBanner;
/** 站位图 */
@property (nonatomic,strong)UIImage *placeholderImage;
- (CGSize)itemSize;
@end

@implementation LGYBanner
{
    NSTimeInterval _timeInterval;
}
+ (LGYBanner *)bannerWithFrame:(CGRect)frame withDelegate:(id<LGYBannerDelegate>)delegate withLocalImagesGroup:(NSArray *)localImageGroup withPlacehoderName:(NSString *)placehoderName
{
    LGYBanner *banner = [[LGYBanner alloc] initWithFrame:frame];
    banner.delegate = delegate;
    banner.placehoderName = placehoderName;
    banner.localImageGroup = localImageGroup;
    return banner;
}

+ (LGYBanner *)bannerWithFrame:(CGRect)frame withDelegate:(id<LGYBannerDelegate>)delegate withImagesUrlGroup:(NSArray *)imageUrlsGroup withPlacehoderName:(NSString *)placehoderName
{
    LGYBanner *banner = [[LGYBanner alloc] initWithFrame:frame];
    banner.delegate = delegate;
    banner.placehoderName = placehoderName;
    banner.imageUrlsGroup = imageUrlsGroup;
    return banner;
}

- (void)setPlacehoderName:(NSString *)placehoderName
{
    _placehoderName = placehoderName;
    _placeholderImage = [UIImage imageNamed:placehoderName];
}
- (void)setLocalImageGroup:(NSArray *)localImageGroup
{
    _localImageGroup = localImageGroup;
    _isLocalImageBanner = YES;
    [self setBannerWithModels:localImageGroup];
}

- (void)setImageUrlsGroup:(NSArray *)imageUrlsGroup
{
    _imageUrlsGroup = imageUrlsGroup;
    _isLocalImageBanner = NO;
    [self setBannerWithModels:imageUrlsGroup];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    if (self.timer) {
        [self stopTimer];
        [self startTimer];
    }
}

- (NSTimeInterval)timeInterval
{
    return (_timeInterval > 0) ? _timeInterval : kDefaultscrollTimeInterval;
}

- (void)setBannerWithModels:(NSArray *)bannerModels
{
    self.pageControl.numberOfPages = bannerModels.count;
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 20);
    [self layoutIfNeeded];

    self.pageControl.currentPage = 0;
    [self updateContent];

    if (bannerModels.count > 1) {
        self.pageControl.hidden = NO;
        // 开始定时器
        [self startTimer];
    }else
    {
        self.pageControl.hidden = YES;
    }
}

- (void)setBannersGapMargin:(CGFloat)bannersGapMargin
{
    _bannersGapMargin = bannersGapMargin;
    for (int i = 0; i < BannerItemsCount; i ++) {
        LGYBaseBannerView *bannerV = self.scrollView.subviews[i];
        bannerV.itemsGapMargin = bannersGapMargin;
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    // 设置内容
    //    [self updateContent];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
//        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUpSubViews
{
    // 重置_scrollView的contentSize
    [self scrollView];
    [self pageControl];
    
    for (int i = 0; i < BannerItemsCount; i ++) {
        LGYBaseBannerView *bannerV = [[LGYBaseBannerView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBannerAtIndex:)];
        [bannerV addGestureRecognizer:tap];
        [self.scrollView addSubview:bannerV];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat y = (self.bounds.size.height - self.itemSize.height) * 0.5;
    self.scrollView.frame = CGRectMake((self.bounds.size.width - self.itemSize.width) * 0.5, y, self.itemSize.width, self.itemSize.height);
    self.scrollView.contentSize = CGSizeMake(self.itemSize.width * BannerItemsCount, self.itemSize.height);
//    // 计算scrollView内容

//
    // 布局5个重复利用的imageView
    for (int i = 0; i<BannerItemsCount; i++) {
        LGYBaseBannerView *bannerV = self.scrollView.subviews[i];
        
        CGFloat banX = i * (self.itemSize.width);//self.bannersGapMargin + 
        bannerV.frame = CGRectMake(banX, 0, self.itemSize.width , self.itemSize.height);
    }

    self.scrollView.contentOffset = CGPointMake(self.itemSize.width * 2, 0);
    
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.itemSize.height + y - 20);
    self.pageControl.currentPage = 0;
}

#pragma mark - <loadImage url>
- (void)loadRemoteImages
{
    for (NSString *imageUrl in self.imageUrlsGroup) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
        }];
    }
}

#pragma mark - tapbanner
- (void)tapBannerAtIndex:(UITapGestureRecognizer *)tap
{
    // 先暂停定时轮播，在判断点击
    [self stopTimer];
    
    LGYBaseBannerView *banner = (LGYBaseBannerView *)tap.view;

    LGYBaseBannerView *centerBanner = nil;
    CGFloat minDistance = MAXFLOAT;
//    选中banner的索引
//    NSUInteger *index = [self.scrollView.subviews indexOfObject:banner];
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        LGYBaseBannerView *bannerV = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(bannerV.frame.origin.x - self.scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance;
            centerBanner = bannerV;
        }
    }
    

    CGPoint offset = self.scrollView.contentOffset;
    offset.x = banner.frame.origin.x;
    [self.scrollView setContentOffset:offset animated:YES];
    
    if ([centerBanner isEqual:banner]) {
        
        [self callDelegateSelMethodWith:banner.tag];
        [self startTimer];
    }else
    {
        if (![banner isEqual:self.currSelBanner]) {
            self.currSelBanner.userInteractionEnabled = YES;
            self.currSelBanner = banner;
        }else
        {
            self.currSelBanner.userInteractionEnabled = NO;
        }
    }
}

- (void)callDelegateSelMethodWith:(NSInteger)selIndex
{
    if (self.localImageGroup.count || self.imageUrlsGroup.count) {
        NSLog(@"点击了%ld",(long)selIndex);//
        if ([self.delegate respondsToSelector:@selector(lgyBanner:didSelectBannerIndex:)]) {
            [self.delegate lgyBanner:self didSelectBannerIndex:selIndex];
        }
    }

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     // 找出最中间的那个图片控件

        NSInteger page = 0;
        CGFloat minDistance = MAXFLOAT;
        for (int i = 0; i < self.scrollView.subviews.count; i++) {
            LGYBaseBannerView *bannerV = self.scrollView.subviews[i];
            CGFloat distance = 0;
            distance = ABS(bannerV.frame.origin.x - scrollView.contentOffset.x);
            
            bannerV.coverV.alpha = 0.7 * (distance / self.itemSize.width);
            
            if (distance < minDistance) {
                minDistance = distance;
                page = bannerV.tag;
            }
        }
        self.pageControl.currentPage = page;

    if (scrollView.contentOffset.x > 3 * self.itemSize.width || scrollView.contentOffset.x < self.itemSize.width) {
        [self updateContent];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self startTimer];
    self.currSelBanner.userInteractionEnabled = YES;
    [self updateContent];
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    
//    NSLog(@"%f-----%f",targetContentOffset->x, targetContentOffset->y);
//}
#pragma mark - 内容更新
- (void)updateContent
{
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        LGYBaseBannerView *bannerV = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if (i ==0) {
            index = index -2;
        }
        else if (i == 1) {
            index --;
        }
        else if (i == 3) {
            index++;
        }else if (i == 4) {
            index += 2;
        }
        
        if (index < 0) {
            index = self.pageControl.numberOfPages + index;
        } else if (index >= self.pageControl.numberOfPages) {
            index = index - self.pageControl.numberOfPages;
        }
        bannerV.tag = index;
       
        if (_isLocalImageBanner) {
            UIImage *image = [UIImage imageNamed:self.localImageGroup[index]];
            if (image.size.width == 0 && self.placeholderImage) {
                image = self.placeholderImage;
            }
            bannerV.imageView.image = image;
        }else
        {
            [bannerV.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlsGroup[index]] placeholderImage:self.placeholderImage];
        }
        
    }
    
    // 设置偏移量在中间
    self.scrollView.contentOffset = CGPointMake(self.itemSize.width * 2, 0);
//    [self.scrollView setContentOffset: animated:NO];
}

#pragma mark - 定时器处理
- (void)startTimer
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(next) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next
{
    [self.scrollView setContentOffset:CGPointMake(3 * self.itemSize.width, 0) animated:YES];
}

#pragma mark - getter property
- (CGSize)itemSize
{
    if ([self.delegate respondsToSelector:@selector(sizeForItemInBannerView:)]) {
        return [self.delegate sizeForItemInBannerView:self];
    }else{
        return self.bounds.size;
    }
}

#pragma mark - hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = [_scrollView convertPoint:point fromView:self];
        for (LGYBaseBannerView *subView in _scrollView.subviews) {
            if (CGRectContainsPoint(subView.frame, newPoint)) {
                CGPoint newSubViewPoint = [subView convertPoint:point fromView:self];
                return [subView hitTest:newSubViewPoint withEvent:event];
            }
        }
    }
    return nil;
}

#pragma mark - subVs
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.clipsToBounds = NO;
        scrollView.bounces = NO;
        scrollView.delaysContentTouches = NO;
        scrollView.decelerationRate = 0;
//        scrollView.backgroundColor = [UIColor blueColor];//[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (LGYPageControl *)pageControl
{
    if (!_pageControl) {
        LGYPageControl *pageControl = [[LGYPageControl alloc] init];
        pageControl.currenStyle = Special;
        pageControl.pageSize = CGSizeMake(20, 2);
        pageControl.currenPageSize = CGSizeMake(20, 2);
        pageControl.currenColor = [UIColor colorWithRed:244/255.0 green:36/255.0 blue:64/255.0 alpha:1.0];
        pageControl.defaultColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}
@end
