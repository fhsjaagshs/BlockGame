//
//  BlackHole.m
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BlackHole.h"

@interface BlackHole ()

@property (nonatomic, assign) CGSize directionVector;
@property (nonatomic, assign) CGRect screenBounds;

@end

@implementation BlackHole

- (void)moveWithDuration:(NSNumber *)duration {
    CGPoint center = self.center;
    
    float divisor = duration.floatValue*30;
    
    CGPoint perspectiveCenter = CGPointMake(center.x+(_directionVector.width/divisor), center.y+_directionVector.height/divisor);
    
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    
    CGRect newFrame = CGRectMake(perspectiveCenter.x-(width/2), perspectiveCenter.y-(height/2), width, height);
    
    float maxX = CGRectGetMaxX(newFrame);
    float maxY = CGRectGetMaxY(newFrame);
    
    BOOL originOutOfBounds = !CGRectContainsPoint(_screenBounds, newFrame.origin);
    BOOL otherPointOutOfBounds = !CGRectContainsPoint(_screenBounds, CGPointMake(maxX, maxY));
    
    if (originOutOfBounds || otherPointOutOfBounds) {
        BOOL xTooHigh = (maxX > _screenBounds.size.width || newFrame.origin.x <= 0);
        BOOL yTooHigh = (maxY > _screenBounds.size.height || newFrame.origin.y <= 0);
        _directionVector.width = (xTooHigh?-1*_directionVector.width:_directionVector.width);
        _directionVector.height = (yTooHigh?-1*_directionVector.height:_directionVector.height);
        perspectiveCenter = CGPointMake(center.x+(_directionVector.width/35), center.y+(_directionVector.height/35));
    }
    
    self.center = perspectiveCenter;
}

- (void)redrawWithNSValueCGRect:(NSValue *)value {
    [self muckWithFrame:[value CGRectValue]];
}

- (void)muckWithFrame:(CGRect)ballframe {
    int adjustedWidth = (int)floor(_screenBounds.size.width-60);
    int adjustedHeight = (int)floor(_screenBounds.size.height-60);
    int x = (arc4random()%adjustedWidth)+30;
    int y = (arc4random()%adjustedHeight)+30;

    CGSize size = self.frame.size;
    
    CGRect adjustedFrame = CGRectMake(x-75, y-75, size.width+150, size.height+150);
    
    if (CGRectIntersectsRect(adjustedFrame, ballframe)) {
        [self muckWithFrame:ballframe];
    } else {
        self.frame = CGRectMake(x, y, 33, 33);
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.screenBounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.directionVector = CGSizeMake(1, 1);
    }
    return self;
}

- (id)initWithBallframe:(CGRect)ballframe {
    self = [super initWithFrame:self.frame];
    if (self) {
        self.screenBounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        [self muckWithFrame:ballframe];
        self.directionVector = CGSizeMake(1, 1);
    }
    return self;
}

- (void)redrawRectWithBallFrame:(CGRect)ballFrame {
    [self muckWithFrame:ballFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shouldRasterize = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -5, 44, 44)]CGPath];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat colorsOne[] = { 1, 0, 0, 1, 0, 0, 0, 1 };

    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientOne = CGGradientCreateWithColorComponents(rgb, colorsOne, nil, 2);
    CGColorSpaceRelease(rgb);

    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradientOne, CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradientOne);
}

@end
