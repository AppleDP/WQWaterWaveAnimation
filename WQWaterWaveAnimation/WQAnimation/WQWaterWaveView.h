//
//  WQWaterWaveView.h
//  WQWaterWaveAnimation
//
//  Created by iOS on 2018/8/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface WQWaterWaveView : UIView
/** 动画状态 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/**
 * 初始化水纹显示视图
 *
 * @param frame 视图大小
 * @param waveCount 水纹个数
 * @param color 水纹颜色
 */
- (instancetype)initWithFrame:(CGRect)frame
                    waveCount:(NSInteger)waveCount
                        color:(UIColor *)color;
/**
 * 开始动画
 */
- (void)startAnimation;

/**
 * 停止动画
 */
- (void)stopAnimation;
@end
NS_ASSUME_NONNULL_END
