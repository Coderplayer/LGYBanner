//
//  LGYPageControl.h
//  广告页
//
//  Created by 李冠余 on 2017/6/12.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    Normal = 0,
    Special,
} CurrentStyle;

@interface LGYPageControl : UIView

@property (nonatomic)   UIImage * currentImage; //高亮图片
@property (nonatomic)   UIImage * defaultImage; //默认图片
@property (nonatomic,strong) UIColor * currenColor;//高亮颜色
@property (nonatomic,strong) UIColor * defaultColor;//默认颜色

@property (nonatomic,assign)   CGSize pageSize; //图标大小 默认（4，4）

@property (nonatomic,assign) NSInteger currentPage;//当前页码

@property (nonatomic,assign) NSInteger numberOfPages;//总页码

@property (nonatomic,assign) float space;//图标间隔,默认5.0

@property (nonatomic, assign) CurrentStyle currenStyle;
@property (nonatomic, assign) CGSize currenPageSize; //当前高亮图标大小 默认（4，4）

- (void)setUpDots;//刷新图标状态

//返回指示器的宽高
- (CGSize)sizeForNumberOfPages:(NSInteger)numberOfPages;

- (instancetype)initWithFrame:(CGRect)frame withNumberOfPages:(NSInteger)numberOfPages;
@end
