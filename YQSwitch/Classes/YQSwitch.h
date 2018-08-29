//
//  YQSwitch.h
//  YaoTiA
//
//  Created by midas on 2018/8/28.
//  Copyright © 2018年 麦都. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQSwitch : UIView

@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, strong) UIView *mumTrackView;

@property (nonatomic, strong) UIColor *minimumTrackTintColor;

@property (nonatomic, strong) UIColor *maximumTrackTintColor;

@property (nonatomic, strong) UIColor *miniThumbTintColor;

@property (nonatomic, strong) UIColor *maxThumbTintColor;

/**
 打开/关闭状态
 */
@property (nonatomic, assign) BOOL isOn;

/**
 开关操作

 @param on 打开/关闭
 @param animted 是否有动画
 */
- (void)setOn:(BOOL)on animated:(BOOL)animted;

/**
 打开/关闭回调
 */
@property (nonatomic, copy) void (^onBlock)(BOOL on);

/**
 展示
 */
- (void)show;

@end
