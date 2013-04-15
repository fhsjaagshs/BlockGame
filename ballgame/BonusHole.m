//
//  BonusHole.m
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BonusHole.h"

@implementation BonusHole

- (void)muckWithFrame:(CGRect)ballframe {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    int adjustedWidth = (int)floor(screenBounds.size.width-30);
    int adjustedHeight = (int)floor(screenBounds.size.height-30);
    int x = (arc4random()%adjustedWidth)+30;
    int y = (arc4random()%adjustedHeight)+30;
    
    CGRect adjustedFrame = CGRectMake(x-75, y-75, self.frame.size.width+150, self.frame.size.height+150);
    
    if (CGRectIntersectsRect(adjustedFrame, ballframe)) {
        
        CGPoint ballCenter = CGPointMake(ballframe.origin.x+(ballframe.size.width/2), ballframe.origin.y+(ballframe.size.height/2));
        CGPoint proposedCenter = CGPointMake(x+(33/2), y+(33/2));
        
        float xDistFromBall = ballCenter.x-proposedCenter.x;
        float yDistFromBall = ballCenter.y-proposedCenter.y;
        
        float xDirection = xDistFromBall/fabsf(xDistFromBall);
        float yDirection = yDistFromBall/fabsf(yDistFromBall);
        
        self.frame = CGRectMake(x+(50*xDirection*-1), y+(50*yDirection*-1), 33, 33);
    } else {
        self.frame = CGRectMake(x, y, 33, 33);
    }
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    self.backgroundColor = [UIColor clearColor];
    [self muckWithFrame:ballFrame];
    [self setNeedsDisplay];
}

- (id)initWithBallframe:(CGRect)ballframe {
    self = [super initWithFrame:ballframe];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self muckWithFrame:ballframe];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 44, 44)].CGPath;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorsOne[] = { 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 };
    CGFloat colorsTwo[] = { 0, 0, 0, 1.0, 0.65625, 0.8046875, 0.9453125, 1.00 };

    CGGradientRef gradientOne = CGGradientCreateWithColorComponents(rgb, colorsOne, nil, 2);
    CGGradientRef gradientTwo = CGGradientCreateWithColorComponents(rgb, colorsTwo, nil, sizeof(colorsTwo)/(sizeof(colorsTwo[0])*4));
    
    CGPoint startPointOne = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPointOne = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint startPointTwo = CGPointMake(0.5, 0);
    CGPoint endPointTwo = CGPointMake(0.5, 1);
    
    CGAffineTransform myTransform = CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height);
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientOne, startPointOne, endPointOne, 0);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextConcatCTM(context, myTransform);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0.5, 0.5, 0.3, 0, 6.28318531, 0);
    CGContextClosePath(context);  
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientTwo, startPointTwo, endPointTwo, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradientTwo);
    CGGradientRelease(gradientOne);
    CGColorSpaceRelease(rgb);
}

@end
