//
//  BlackHole.m
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BlackHole.h"

@implementation BlackHole

- (void)muckWithFrame:(CGRect)ballframe {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    int adjustedWidth = (int)floor(screenBounds.size.width-26);
    int adjustedHeight = (int)floor(screenBounds.size.height-26);
    int x = (arc4random()%adjustedWidth)+26;
    int y = (arc4random()%adjustedHeight)+26;

    CGRect adjustedFrame = CGRectMake(x-75, y-75, self.frame.size.width+150, self.frame.size.height+150);
    
    if (CGRectIntersectsRect(adjustedFrame, ballframe)) {
        
        CGPoint ballCenter = CGPointMake(ballframe.origin.x+(ballframe.size.width/2), ballframe.origin.y+(ballframe.size.height/2));
        CGPoint proposedCenter = CGPointMake(x+(33/2), y+(33/2));
        
        float xDistFromBall = ballCenter.x-proposedCenter.x;
        float yDistFromBall = ballCenter.y-proposedCenter.y;
        
        // direction of ball
        float xDirection = xDistFromBall/fabsf(xDistFromBall);
        float yDirection = yDistFromBall/fabsf(yDistFromBall);
        
        self.frame = CGRectMake(x+(75*xDirection*-1), y+(75*yDirection*-1), 33, 33);
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
    }
    return self;
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    self.backgroundColor = [UIColor clearColor];
    [self muckWithFrame:ballFrame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat colorsOne[] = { 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0 };
    CGFloat colorsTwo[] = { 0, 0, 0, 1.00, 0.65625, 0.8046875, 0.9453125, 1.00 };
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientOne = CGGradientCreateWithColorComponents(rgb, colorsOne, nil, 2);
    CGGradientRef gradientTwo = CGGradientCreateWithColorComponents(rgb, colorsTwo, nil, sizeof(colorsTwo)/(sizeof(colorsTwo[0])*4));
    
    CGAffineTransform myTransform = CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height);
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientOne, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextConcatCTM(context, myTransform);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0.5, 0.5, 0.3, 0, 6.28318531, 0);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientTwo, CGPointMake(0.5, 0), CGPointMake(0.5, 1), 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradientOne);
    CGGradientRelease(gradientTwo);
    CGColorSpaceRelease(rgb);
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 44, 44)].CGPath;
}

@end
