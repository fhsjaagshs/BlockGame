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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.9f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 5.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = nil;
        self.directionVector = CGSizeMake(1, 1);
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.9f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowRadius = 5.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = nil;
        self.directionVector = CGSizeMake(1, 1);
    }
    return self;
}

- (void)moveWithDuration:(NSNumber *)duration {
    CGPoint center = self.center;
    
    float divisor = [duration floatValue]*30;
    
    float xMovement = _isVerticle?0:(_directionVector.width/divisor);
    float yMovement = _isVerticle?(_directionVector.height/divisor):0;
    
    CGPoint perspectiveCenter = CGPointMake(center.x+xMovement, center.y+yMovement);
    
    CGRect _screenBounds = [[UIScreen mainScreen]bounds];
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    CGRect newFrame = CGRectMake(perspectiveCenter.x-(width/2), perspectiveCenter.y-(height/2), width, height);

    NSLog(@"newFrame: %@",NSStringFromCGRect(newFrame));
    
    if (!CGRectContainsRect(_screenBounds, newFrame)) {
    
//    if (!CGRectContainsPoint(_screenBounds, perspectiveCenter) || !CGRectContainsPoint(_screenBounds, CGPointMake(perspectiveCenter.x+width, perspectiveCenter.y+height))) {
    
 //   if (!CGRectContainsPoint(_screenBounds, perspectiveCenter)) {
        BOOL xTooHigh = (perspectiveCenter.x > _screenBounds.size.width || perspectiveCenter.x <= 0);
        BOOL yTooHigh = (perspectiveCenter.y > _screenBounds.size.height || perspectiveCenter.y <= 0);
        _directionVector.width = (xTooHigh?-1*_directionVector.width:_directionVector.width);
        _directionVector.height = (yTooHigh?-1*_directionVector.height:_directionVector.height);
        
        float XnewMovement = _isVerticle?0:(_directionVector.width/divisor);
        float YnewMovement = _isVerticle?(_directionVector.height/divisor):0;
        
        perspectiveCenter = CGPointMake(center.x+XnewMovement, center.y+YnewMovement);
    }
    
    self.center = perspectiveCenter;
}

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
        CGSize size = self.bounds.size;
        UIImage *image = [UIImage uncachedImageNamed:(size.width > size.height)?@"target-hor":@"target-ver"];
        [image drawInRect:self.bounds];
    }
}

- (void)redrawWithImage {
    [self setNeedsDisplay];
}

@end
