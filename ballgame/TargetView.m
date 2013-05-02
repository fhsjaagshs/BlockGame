//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "TargetView.h"

@implementation TargetView

- (void)setClassicMode:(BOOL)cm {
    self.isClassicMode = cm;
    self.layer.cornerRadius = 5;
    [self setNeedsDisplay];
}

- (void)redrawWithBackgroundColor:(UIColor *)color vertically:(BOOL)vertically {
    self.backgroundColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (_isClassicMode) {
        [super drawRect:rect];
    } else {
        UIImage *image = [UIImage imageNamed:_isHorizontal?@"target-hor":@"target-ver"];
        [image drawInRect:self.bounds];
    }
}

- (void)redrawImageWithIsHorizontal:(BOOL)isH {
    _isHorizontal = isH;
    [self setNeedsDisplay];
}

@end
