//
//  BonusHole.m
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BonusHole.h"

int numberOfTimes = 0;

@implementation BonusHole

- (void)animateImageView:(UIImageView *)imageView {
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = CGRectMake(-12.5, -12.5, self.frame.size.width+5+20, self.frame.size.width+5+20);
    } completion:^(BOOL finished) {
        if (finished) {
            imageView.frame = self.bounds;
            numberOfTimes += 1;
            if (numberOfTimes < 3) {
                [self animateImageView:imageView];
            } else {
                numberOfTimes = 0;
                [imageView removeFromSuperview];
            }
        }
    }];
}

- (void)animateCircles {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width+25, self.frame.size.width+25), NO, [[UIScreen mainScreen]scale]);

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 2.5);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    
    for (int i = 0; i < 5; i++) {
        float width = self.frame.size.width+5+1.5*(i+1);
        float x = (self.frame.size.width+25-width)/2;
        float y = (self.frame.size.height+25-width)/2;
        CGContextStrokeEllipseInRect(context, CGRectMake(x, y, width, width));
    }
    
    CGContextRestoreGState(context);
    
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    imageView.image = outputImage;
    [self animateImageView:imageView];
}

- (void)muckWithFrame:(CGRect)ballframe {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    int adjustedWidth = (int)floor(screenBounds.size.width-60);
    int adjustedHeight = (int)floor(screenBounds.size.height-60);
    int x = (arc4random()%adjustedWidth)+30;
    int y = (arc4random()%adjustedHeight)+30;
    
    CGRect adjustedFrame = CGRectMake(x-75, y-75, self.frame.size.width+150, self.frame.size.height+150);
    
    if (CGRectIntersectsRect(adjustedFrame, ballframe)) {
        [self muckWithFrame:ballframe];
    } else {
        self.frame = CGRectMake(x, y, 33, 33);
    }
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    self.backgroundColor = [UIColor clearColor];
    [self muckWithFrame:ballFrame];
    [self setNeedsDisplay];
    [self animateCircles];
}

- (id)initWithBallframe:(CGRect)ballframe {
    self = [super initWithFrame:ballframe];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self muckWithFrame:ballframe];
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
    
    CGFloat colorsOne[] = { 0, 1, 0, 1, 0, 0, 0, 1 };
    CGFloat colorsTwo[] = { 0, 0, 0, 1, 0.65625, 0.8046875, 0.9453125, 1 };

    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientOne = CGGradientCreateWithColorComponents(rgb, colorsOne, nil, 2);
    CGGradientRef gradientTwo = CGGradientCreateWithColorComponents(rgb, colorsTwo, nil, sizeof(colorsTwo)/(sizeof(colorsTwo[0])*4));
    CGColorSpaceRelease(rgb);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height);
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientOne, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextConcatCTM(context, transform);
    CGContextBeginPath(context);
    CGContextAddArc(context, 0.5, 0.5, 0.3, 0, 6.28318531, 0);
    CGContextClosePath(context);  
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientTwo, CGPointMake(0.5, 0), CGPointMake(0.5, 1), 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradientTwo);
    CGGradientRelease(gradientOne);
}

@end
