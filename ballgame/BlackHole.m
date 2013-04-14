//
//  BlackHole.m
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlackHole.h"

@implementation BlackHole

- (void)muckWithFrame:(CGRect)ballframe {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;

    CGRect adjustedFrame = CGRectMake(x-75, y-75, self.frame.size.width+150, self.frame.size.height+150);
    
    if (CGRectIntersectsRect(adjustedFrame, ballframe)) {
        
        int xSubtracted = x-75;
        int ySubtracted = y-75;

        if (xSubtracted < 0 && ySubtracted < 0) {
            self.frame = CGRectMake(x+75, y+75, 33, 33);
        } else {
            self.frame = CGRectMake(x-75, y-75, 33, 33);
        }
    } else {
        self.frame = CGRectMake(x, y, 33, 33);
    }
}

- (id)initWithBallframe:(CGRect)ballframe {
    self = [super initWithFrame:self.frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self muckWithFrame:ballframe];
        [self setNeedsDisplay];
     //   [self drawRect:self.frame];
    }
    return self;
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    self.backgroundColor = [UIColor clearColor];
    [self muckWithFrame:ballFrame];
    [self setNeedsDisplay];
  //  [self drawRect:self.frame];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat colorsOne[] = { 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0 };

    CGColorSpaceRef rgbOne = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientZ = CGGradientCreateWithColorComponents(rgbOne, colorsOne, nil, 2);
    CGColorSpaceRelease(rgbOne);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradientZ, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    CGGradientRelease(gradientZ);
    
    CGContextRestoreGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
     
    CGFloat colors[] = { 0, 0, 0, 1.00, 0.65625, 0.8046875, 0.9453125, 1.00 };
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, nil, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    CGAffineTransform myTransform = CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height);
    
    CGContextSaveGState(context);
    CGContextConcatCTM(context, myTransform);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0.5, 0.5, 0.3, 0, 6.28318531, 0);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.5, 0), CGPointMake(0.5, 1), 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 44, 44)].CGPath;
}

@end
