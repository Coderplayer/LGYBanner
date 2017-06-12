//
//  ViewController.m
//  LGYBanner
//
//  Created by 李冠余 on 2017/6/12.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import "ViewController.h"
#import "LGYBanner.h"
#import <Masonry.h>
@interface ViewController ()<LGYBannerDelegate>
@property (nonatomic, weak) LGYBanner * banner;
/** <#描述#> */
@property (nonatomic,weak)UILabel *selL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 300);
    NSArray *bannerMs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    LGYBanner *banner = [LGYBanner bannerWithFrame:frame withDelegate:self withLocalImagesGroup:bannerMs withPlacehoderName:nil];

    banner.bannersGapMargin = 6;
    [self.view addSubview:banner];
    self.banner = banner;
    
    UILabel *selL = [[UILabel alloc] init];
    selL.textAlignment = NSTextAlignmentCenter;
    selL.backgroundColor = [UIColor orangeColor];
    selL.textColor = [UIColor whiteColor];
    [self.view addSubview:selL];
    
    [selL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    self.selL = selL;
    
}
#pragma mark - <HCBannerDelegate>
- (CGSize)sizeForItemInBannerView:(LGYBanner *)bannerView
{
    return CGSizeMake(400, 250);
}

- (void)lgyBanner:(LGYBanner *)banner didSelectBannerIndex:(NSInteger)index
{
    NSLog(@"选中了第%zd",index);
    self.selL.text = [NSString stringWithFormat:@"选中了第%zd",index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSArray *bannerMs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];//,@"4",@"5",@"6"
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//    self.banner.imageUrlsGroup = bannerMs;
}

@end
