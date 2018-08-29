//
//  YQSwitch.m
//  YaoTiA
//
//  Created by midas on 2018/8/28.
//  Copyright © 2018年 麦都. All rights reserved.
//

#import "YQSwitch.h"


@implementation YQSwitch

- (void)show {

    [self addSubview:self.mumTrackView];
    [self addSubview:self.thumbView];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [_thumbView addGestureRecognizer:tap];
    
    // 添加左滑动手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_thumbView addGestureRecognizer:leftSwipe];
    
    // 添加右滑动手势
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [_thumbView addGestureRecognizer:rightSwipe];
}


- (UIView *)mumTrackView {
    if (!_mumTrackView) {
        _mumTrackView = [[UIView alloc] initWithFrame:self.bounds];
        _mumTrackView.backgroundColor = [UIColor lightGrayColor];
    }
    return _mumTrackView;
}

- (UIView *)thumbView {
    if (!_thumbView) {
        CGFloat scale = self.frame.size.width > self.frame.size.height? self.frame.size.height - 2: self.frame.size.width - 2;
        _thumbView = [[UIView alloc] initWithFrame:CGRectMake(1.0, 1.0, scale, scale)];
        _thumbView.backgroundColor = [UIColor whiteColor];
        _thumbView.userInteractionEnabled = YES;
    }
    return _thumbView;
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    if (_isOn) {
        CGAffineTransform transform = [self ffineTransform];
        self.thumbView.transform = transform;
        
        if (_maxThumbTintColor) {
            self.thumbView.backgroundColor = _maxThumbTintColor;
        }
        if (_maximumTrackTintColor) {
            self.mumTrackView.backgroundColor = _maximumTrackTintColor;
        }
    } else {
        self.thumbView.transform = CGAffineTransformIdentity;
        if (_miniThumbTintColor) {
            self.thumbView.backgroundColor = _miniThumbTintColor;
        }
        if (_minimumTrackTintColor) {
            self.mumTrackView.backgroundColor = _minimumTrackTintColor;
        }
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animted {
    _isOn = on;
    if (on) { // 打开
        [self transformAnimation:animted];
    } else { // 关闭
        [self reTransformAnimation:animted];
    }
}

- (void)setMiniThumbTintColor:(UIColor *)miniThumbTintColor {
    _miniThumbTintColor = miniThumbTintColor;
    if (!_isOn && _miniThumbTintColor) {
        _thumbView.backgroundColor = _miniThumbTintColor;
    }
}

- (void)setMaxThumbTintColor:(UIColor *)maxThumbTintColor {
    _maxThumbTintColor = maxThumbTintColor;
    if (_isOn && _maxThumbTintColor) {
        _thumbView.backgroundColor = _maxThumbTintColor;
    }
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    if (!_isOn && _minimumTrackTintColor) {
        _mumTrackView.backgroundColor = _minimumTrackTintColor;
    }
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    if (_isOn && _maximumTrackTintColor) {
        _mumTrackView.backgroundColor = _maximumTrackTintColor;
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    if (tap.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (_thumbView.frame.origin.x == 1.0) {
        [self setOn:YES animated:YES];
    } else {
        [self setOn:NO animated:YES];
    }
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)swipe {
    if (_thumbView.frame.origin.x == 1.0) {
        return;
    }
    [self setOn:NO animated:YES];
   
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)swipe {
    if (_thumbView.frame.origin.x != 1.0) {
        return;
    }
    [self setOn:YES animated:YES];
    
}

#pragma mark - 平移动画

- (CGAffineTransform)ffineTransform {
    CGFloat animaScale = self.frame.size.width - _thumbView.frame.size.width - 2;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(animaScale, 0.0);
    if (self.frame.size.width < self.frame.size.height) {
        animaScale = self.frame.size.height - _thumbView.frame.size.height - 2;
        transform = CGAffineTransformMakeTranslation(0.0, animaScale);
    }
    return transform;
}

#pragma mark - 移动
- (void)transformAnimation:(BOOL)animated {
   
    CGAffineTransform transform = [self ffineTransform];
    _thumbView.userInteractionEnabled = NO;
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            _thumbView.transform = transform;
        } completion:^(BOOL finished) {
            [self maxCOlorsSet];
        }];
    } else {
        _thumbView.transform = transform;
        [self maxCOlorsSet];
    }
    
}

- (void)maxCOlorsSet {
    if (_maxThumbTintColor) {
        _thumbView.backgroundColor = _maxThumbTintColor;
    }
    if (_maximumTrackTintColor) {
        _mumTrackView.backgroundColor = _maximumTrackTintColor;
    }
    if (_onBlock) {
        _onBlock(_isOn);
    }
    _thumbView.userInteractionEnabled = YES;

}

#pragma mark - 回到起点
- (void)reTransformAnimation:(BOOL)animated {
    
    _thumbView.userInteractionEnabled = NO;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _thumbView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [self miniColorSet];
        }];

    } else {
        _thumbView.transform = CGAffineTransformIdentity;
        [self miniColorSet];
    }
}

- (void)miniColorSet {
    if (_miniThumbTintColor) {
        _thumbView.backgroundColor = _miniThumbTintColor;
    }
    if (_minimumTrackTintColor) {
        _mumTrackView.backgroundColor = _minimumTrackTintColor;
    }
    if (_onBlock) {
        _onBlock(_isOn);
    }
    _thumbView.userInteractionEnabled = YES;
}

@end
