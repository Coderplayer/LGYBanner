//
//  ViewController.m
//  LGYBanner
//
//  Created by 李冠余 on 2017/6/12.
//  Copyright © 2017年 李冠余. All rights reserved.
//

#import "ViewController.h"
#import "LGYBanner.h"
@interface ViewController ()<LGYBannerDelegate>
@property (nonatomic, weak) LGYBanner * banner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 350);
    NSArray *bannerMs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    LGYBanner *banner = [LGYBanner bannerWithFrame:frame withDelegate:self withLocalImagesGroup:bannerMs withPlacehoderName:nil];

    banner.bannersGapMargin = 6;
    [self.view addSubview:banner];
    self.banner = banner;
}
#pragma mark - <HCBannerDelegate>
- (CGSize)sizeForItemInBannerView:(LGYBanner *)bannerView
{
    return CGSizeMake(700, 300);
}

- (void)lgyBanner:(LGYBanner *)banner didSelectBannerIndex:(NSInteger)index
{
    NSLog(@"选中了第%zd",index);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSArray *bannerMs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];//,@"4",@"5",@"6"
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//    self.banner.imageUrlsGroup = bannerMs;
}

@end
