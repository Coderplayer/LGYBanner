//
//  LGYBanner.h
//  广告页
//
//  Created by 李冠余 on 2017/6/1.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGYBanner;
@protocol LGYBannerDelegate <NSObject>
@optional
- (CGSize)sizeForItemInBannerView:(LGYBanner *)bannerView;
@required
- (void)lgyBanner:(LGYBanner *)banner didSelectBannerIndex:(NSInteger)index;
@required

@end
@interface LGYBanner : UIView
@property (nonatomic, strong) NSArray *localImageGroup;
@property (nonatomic, strong) NSArray *imageUrlsGroup;///<BannerModel *>
@property (nonatomic, weak) id<LGYBannerDelegate> delegate;
@property (nonatomic, assign) CGFloat bannersGapMargin;
@property (nonatomic, assign) CGFloat bannerLRMargin;
@property (nonatomic,copy) NSString *placehoderName;
@property (nonatomic,assign)NSTimeInterval timeInterval;

+ (LGYBanner *)bannerWithFrame:(CGRect)frame withDelegate:(id <LGYBannerDelegate>)delegate withLocalImagesGroup:(NSArray *)localImageGroup withPlacehoderName:(NSString *)placehoderName;
+ (LGYBanner *)bannerWithFrame:(CGRect)frame withDelegate:(id <LGYBannerDelegate>)delegate withImagesUrlGroup:(NSArray *)imageUrlsGroup withPlacehoderName:(NSString *)placehoderName;
@end
