//
//  BonusHole.m
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BonusHole.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@implementation BonusHole

- (void)muckWithFrame:(CGRect)ballframe {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    
    self.frame = CGRectMake(x, y, 33, 33);
    
    CGRect adjustedFrame = CGRectMake((self.frame.origin.x-50), (self.frame.origin.y-50), (self.frame.size.width+100), (self.frame.size.height+100));
    
    CGRect pauseScoreAreaRect = CGRectMake(121, 87, 96, 89);
    
    BOOL inScoreArea = ((CGRectIntersectsRect(pauseScoreAreaRect, ballframe)) || (CGRectContainsRect(pauseScoreAreaRect, ballframe))) || ((CGRectIntersectsRect(pauseScoreAreaRect, ballframe)) && (CGRectContainsRect(pauseScoreAreaRect, ballframe)));
    
    if (inScoreArea) {
        self.frame = CGRectMake(x-50, y-50, 33, 33);
    }
    
    BOOL tooClose = ((CGRectIntersectsRect(adjustedFrame, ballframe)) || (CGRectContainsRect(adjustedFrame, ballframe))) || ((CGRectIntersectsRect(adjustedFrame, ballframe)) && (CGRectContainsRect(adjustedFrame, ballframe)));
    
    if (tooClose) {
        
        int xSubtracted = x-50;
        int ySubtracted = y-50;
        
        if (((xSubtracted < 0) && (ySubtracted < 0)) || ((xSubtracted < 0) && (ySubtracted < 0))) {
            if (CGRectContainsRect([UIScreen mainScreen].applicationFrame, CGRectMake(x+50, y+50, 33, 33))) {
                self.frame = CGRectMake(x+50, y+50, 33, 33);
            }
        } else {
            self.frame = CGRectMake(x-50, y-50, 33, 33);
        }
    }
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    self.backgroundColor = [UIColor clearColor];
    [self muckWithFrame:ballFrame];
    [self drawRect:self.frame];
}

- (id)initWithBallframe:(CGRect)ballframe {
    self = [super initWithFrame:ballframe];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self muckWithFrame:ballframe];
        [self drawRect:self.frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorsOne[] = { 
        0.0, 1.0, 0.0, 1.0, 
        0.0, 0.0, 0.0, 1.0
    };
    
    CGColorSpaceRef baseSpace = rgb;
    CGGradientRef gradientZ = CGGradientCreateWithColorComponents(baseSpace, colorsOne, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGPoint startPointS = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPointS = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradientZ, startPointS, endPointS, 0);
    CGGradientRelease(gradientZ), gradientZ = NULL;
    
    CGContextRestoreGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    
    // first three are RGB, fourth is alpha
    CGFloat colors[] = {
        0, 0, 0, 1.0,
        0.65625, 0.8046875, 0.9453125, 1.00,
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    
    CGPoint startPoint = CGPointMake(0.5,0);
    CGPoint endPoint = CGPointMake(0.5,1);
    CGAffineTransform myTransform = CGAffineTransformMakeScale (width, height);
    CGContextConcatCTM (context, myTransform);
    CGContextSaveGState (context);
    CGContextBeginPath (context); 
    CGContextAddArc (context, 0.5, 0.5, 0.3, 0, 6.28318531, 0);
    CGContextClosePath (context);  
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
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
