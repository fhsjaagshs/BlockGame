//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "TargetView.h"

@interface TargetView ()

@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, assign) BOOL isClassicMode;

@end

@implementation TargetView

- (void)setClassicMode:(BOOL)cm {
    self.isClassicMode = cm;
    
    if (!self.isClassicMode) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.cornerRadius = 0;
    } else {
        [self setBackgroundColor:[UIColor cyanColor]];
        self.layer.cornerRadius = 5;
    }
    
    [self setNeedsDisplay];
}

- (void)redrawWithBackgroundColor:(UIColor *)color vertically:(BOOL)vertically {
    self.backgroundColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.isClassicMode) {
        UIImage *image = nil;
        if (self.isHorizontal) {
            // caps -> left: 15 Right: 0
            image = [UIImage imageNamed:@"target-hor"];
        } else {
            // caps -> left: 0 Right: 15
            image = [UIImage imageNamed:@"target-ver"];
        }
        [image drawInRect:self.bounds];
    } else {
        [super drawRect:rect];
    }
}

- (void)redrawImageWithIsHorizontal:(BOOL)isH {
    self.isHorizontal = isH;
    [self setNeedsDisplay];
}

@end
