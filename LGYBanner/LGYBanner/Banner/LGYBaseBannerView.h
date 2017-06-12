//
//  LGYBaseBannerView.h
//  广告页
//
//  Created by 李冠余 on 2017/6/1.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGYBaseBannerView : UIView
@property (weak, nonatomic,readonly) UIImageView *imageView;
@property (nonatomic, weak,readonly) UILabel * titleL;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, weak,readonly) UIView * coverV;
@property (nonatomic, assign) CGFloat itemsGapMargin;
@end
