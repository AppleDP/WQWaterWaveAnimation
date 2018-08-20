//
//  ViewController.m
//  WQWaterWaveAnimation
//
//  Created by iOS on 2018/8/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WQWaterWaveView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WQWaterWaveView *waveV = [[WQWaterWaveView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, 150, 150) waveCount:3 color:[UIColor blueColor]];
    waveV.layer.cornerRadius = waveV.frame.size.width/2.0;
    waveV.layer.masksToBounds = YES;
    waveV.center = self.view.center;
    [self.view addSubview:waveV];
    [waveV startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
