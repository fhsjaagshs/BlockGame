//
//  BlackHole.m
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BlackHole.h"

@interface BlackHole ()

@property (assign, nonatomic) CGSize directionVector;
@property (assign, nonatomic) BOOL isMoving;

@end

@implementation BlackHole

- (void)muckWithFrame:(CGRect)ballframe {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    int adjustedWidth = (int)floor(screenBounds.size.width-60);
    int adjustedHeight = (int)floor(screenBounds.size.height-60);
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
        
        CGRect potentialFrame = CGRectMake(x+(50*xDirection*-1), y+(50*yDirection*-1), 33, 33);
        
        CGPoint pfcenter = CGPointMake(potentialFrame.origin.x+33/2, potentialFrame.origin.y+33/2);
        
        CGRect testRect = [UIScreen mainScreen].bounds;
        testRect.size.height += 60;
        testRect.size.width += 60;
        testRect.origin.x -= 30;
        testRect.origin.y -= 30;
        
        if (CGRectContainsPoint(testRect, pfcenter)) {
            self.frame = potentialFrame;
        } else {
            
            x = screenBounds.size.width-potentialFrame.origin.x;
            y = screenBounds.size.height-potentialFrame.origin.y;
            
            proposedCenter = CGPointMake(x+(33/2), y+(33/2));
            
            xDistFromBall = ballCenter.x-proposedCenter.x;
            yDistFromBall = ballCenter.y-proposedCenter.y;
            
            xDirection = xDistFromBall/fabsf(xDistFromBall);
            yDirection = yDistFromBall/fabsf(yDistFromBall);
            
            self.frame = CGRectMake(x+(50*xDirection*-1), y+(50*yDirection*-1), 33, 33);
        }
        
    } else {
        self.frame = CGRectMake(x, y, 33, 33);
    }
}

- (CGPoint)generateCenter {
    return CGPointMake(self.center.x+(self.directionVector.width/50), self.center.y+self.directionVector.height/50);
}

- (void)move {
    CGPoint perspectiveCenter = [self generateCenter];
    
    if (!CGRectContainsPoint([UIScreen mainScreen].bounds, perspectiveCenter)) {
        CGRect testRect = [UIScreen mainScreen].bounds;
        testRect.size.height += 1/12.5;
        testRect.size.width += 1/12.5;
        testRect.origin.x -= 1/25;
        testRect.origin.y -= 1/25;
        
        BOOL xTooHigh = (perspectiveCenter.x >= [UIScreen mainScreen].bounds.size.width || perspectiveCenter.x <= 0) && !CGRectContainsPoint(testRect, perspectiveCenter);
        BOOL yTooHigh = (perspectiveCenter.y >= [UIScreen mainScreen].bounds.size.height || perspectiveCenter.y <= 0) && !CGRectContainsPoint(testRect, perspectiveCenter);
        self.directionVector = CGSizeMake(xTooHigh?-1*self.directionVector.width:self.directionVector.width, yTooHigh?-1*self.directionVector.height:self.directionVector.height);
        perspectiveCenter = [self generateCenter];
    }
    
    self.center = perspectiveCenter;
    
    if (self.isMoving) {
        [self performSelector:@selector(move) withObject:nil afterDelay:1/180];
    }
}

- (void)startMoving {
    self.directionVector = CGSizeMake(1, 1);
    self.isMoving = YES;
    [self move];
}

- (void)stopMoving {
    self.isMoving = NO;
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
}

@end
