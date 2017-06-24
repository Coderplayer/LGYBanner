//
//  BaseBannerView.m
//  广告页
//
//  Created by 李冠余 on 2017/6/1.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import "LGYBaseBannerView.h"
#import <Masonry.h>
@interface LGYBaseBannerView ()

@end
@implementation LGYBaseBannerView

- (CGFloat)titleHeight
{
    return _titleHeight ? _titleHeight : 20;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
//        imageV.layer.cornerRadius = 5.0;
//        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];

        _imageView = imageV;
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"your team has been slain!";
        titleL.textColor = [UIColor whiteColor];
        titleL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.hidden = YES;
        [imageV addSubview:titleL];
        _titleL = titleL;

        UIView *coverV = [[UIView alloc] init];
        coverV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [imageV addSubview:coverV];
        _coverV = coverV;
        
        [coverV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageV);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.itemsGapMargin * 0.5, 0, self.bounds.size.width - self.itemsGapMargin, self.bounds.size.height);
    self.titleL.frame = CGRectMake(0, self.bounds.size.height - self.titleHeight, self.imageView.bounds.size.width, self.titleHeight);
}

- (void)setItemsGapMargin:(CGFloat)itemsGapMargin
{
    _itemsGapMargin = itemsGapMargin;
    [self setNeedsLayout];
}

@end
