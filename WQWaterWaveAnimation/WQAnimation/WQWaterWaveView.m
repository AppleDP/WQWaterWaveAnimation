//
//  WQWaterWaveView.m
//  WQWaterWaveAnimation
//
//  Created by iOS on 2018/8/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WQWaterWaveView.h"

@interface UIView (WQExtension)
/**
 * View Frame
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@interface WQWave : CAShapeLayer
/** 水纹移动速度 */
@property (nonatomic, assign) CGFloat offsetX;
@end

@interface WQWaterWaveView ()
/** 动画定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;
/** 水纹数组 */
@property (nonatomic, copy) NSArray<WQWave *> *waves;

/**
 * 区间随机数
 *
 * @param min 最小值
 * @param max 最大值
 */
- (CGFloat)randomWithMin:(CGFloat)min max:(CGFloat)max;

/**
 * 定时器回调
 */
- (void)displayLinkHandle;
@end


@implementation UIView (WQExtension)
#pragma mark -- View Frame --
- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
-(CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height {
    return self.frame.size.height;
}
@end


@implementation WQWave
@end


@implementation WQWaterWaveView
#pragma mark -- 公有方法 --
- (void)startAnimation {
    if (!_isAnimating) {
        self.displayLink.paused = NO;
        _isAnimating = YES;
    }
}

- (void)stopAnimation {
    if (_isAnimating) {
        self.displayLink.paused = YES;
    }
}


#pragma mark -- 私有方法 --
- (CGFloat)randomWithMin:(CGFloat)min max:(CGFloat)max {
    // 位数精度
    int precision = 100;
    CGFloat mini = MIN(min, max) + 1;
    int section = ABS(min - max)*100 + 1;
    CGFloat random = arc4random()%section + 1;
    return random/precision + mini;
}

- (void)displayLinkHandle {
    for (int index = 0; index < self.waves.count; index ++) {
        @autoreleasepool {
            WQWave *wave = self.waves[index];
            CGFloat x = wave.position.x + wave.offsetX;
            if (x < -2*self.width) {
                // 水纹复位
                x = 0;
            }
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            wave.position = CGPointMake(x, wave.position.y);
            [CATransaction commit];
        }
    }
}


#pragma mark -- 系统方法 --
- (instancetype)initWithFrame:(CGRect)frame
                    waveCount:(NSInteger)waveCount
                        color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray<WQWave *> *waves = [NSMutableArray arrayWithCapacity:waveCount];
        for (int index = 0; index < waveCount; index ++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, self.height/2.0)];
            [path addQuadCurveToPoint:CGPointMake(self.width, self.height/2.0) controlPoint:CGPointMake(self.width/2, 0)];
            [path addQuadCurveToPoint:CGPointMake(2*self.width, self.height/2.0) controlPoint:CGPointMake(self.width*3/2, self.height)];
            [path addQuadCurveToPoint:CGPointMake(3*self.width, self.height/2.0) controlPoint:CGPointMake(self.width*5/2, 0)];
            [path addLineToPoint:CGPointMake(3*self.width, self.height)];
            [path addLineToPoint:CGPointMake(0, self.height)];
            [path addLineToPoint:CGPointMake(0, self.height/2.0)];
            [path closePath];
            
            WQWave *wave = [WQWave layer];
            wave.backgroundColor = color.CGColor;
            wave.strokeColor = color.CGColor;
            wave.fillColor = color.CGColor;
            wave.opacity = [self randomWithMin:10.0 max:30.0]/100;
            wave.path = path.CGPath;
            wave.offsetX = [self randomWithMin:-300 max:-80]/100;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            wave.position = CGPointMake([self randomWithMin:-99 max:0]/100*self.width, wave.position.y);
            [CATransaction commit];
            [self.layer addSublayer:wave];
            [waves addObject:wave];
        }
        self.waves = [waves copy];
    }
    return self;
}


#pragma mark -- Getter --
- (CADisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandle)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return _displayLink;
}
@end
