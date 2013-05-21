//
//  BonusHole.m
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "BonusHole.h"

int numberOfTimes = 0;
void animateImageView(UIImageView *imageView, CGRect bounds);

void animateImageView(UIImageView *imageView, CGRect bounds) {
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = CGRectMake(-12.5, -12.5, bounds.size.width+5+20, bounds.size.width+5+20);
    } completion:^(BOOL finished) {
        if (finished) {
            imageView.frame = bounds;
            numberOfTimes += 1;
            if (numberOfTimes < 3) {
                animateImageView(imageView, bounds);
            } else {
                numberOfTimes = 0;
                [imageView removeFromSuperview];
            }
        }
    }];
}

@interface BonusHole ()

@property (nonatomic) CGSize directionVector;
@property (nonatomic) CGRect screenBounds;

@end

@implementation BonusHole

- (void)animateImageView:(UIImageView *)imageView {
    animateImageView(imageView, self.bounds);
}

- (void)animateCircles {
    
    UIImage *image = [[ImageCache sharedInstance]objectForKey:@"greenRings"];
    
    if (!image) {
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
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[ImageCache sharedInstance]setObject:image forKey:@"greenRings"];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    imageView.image = image;
    [self animateImageView:imageView];
}

- (void)moveWithDuration:(float)duration {
    CGPoint center = self.center;
    
    NSLog(@"%f",duration);
    
    float divisor = duration*15;
    
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
    self = [super initWithFrame:ballframe];
    if (self) {
        self.screenBounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.directionVector = CGSizeMake(1, 1);
        [self muckWithFrame:ballframe];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shouldRasterize = YES;
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
