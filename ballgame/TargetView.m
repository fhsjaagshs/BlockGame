//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "TargetView.h"

UIColor *oldBGColor;

@implementation TargetView

- (void)setClassicMode:(BOOL)cm {
    self.isClassicMode = cm;
    self.backgroundColor = cm?oldBGColor:[UIColor clearColor];
    self.layer.cornerRadius = 5;
    [self setNeedsDisplay];
}

- (void)redrawWithBackgroundColor:(UIColor *)color {
    self.backgroundColor = color;
    oldBGColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (_isClassicMode) {
        [super drawRect:rect];
    } else {
        UIImage *image = [UIImage imageNamed:(self.bounds.size.width > self.bounds.size.height)?@"target-hor":@"target-ver"];
        [image drawInRect:self.bounds];
    }
}

- (void)redrawWithImage {
    [self setNeedsDisplay];
}

@end
