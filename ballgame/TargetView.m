//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "TargetView.h"

UIColor *oldBGColor;

@interface TargetView ()

@property (nonatomic, assign) CGRect screenBounds;
@property (nonatomic, assign) CGSize directionVector;

@end

@implementation TargetView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 5.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = nil;
        self.directionVector = CGSizeMake(1, 1);
        self.screenBounds = [[UIScreen mainScreen]bounds];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 5.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = nil;
        self.directionVector = CGSizeMake(1, 1);
        self.screenBounds = [[UIScreen mainScreen]bounds];
    }
    return self;
}

- (void)moveWithDuration:(float)duration {
    CGPoint center = self.center;
    
    float metadivisor = (_difficulty > 2)?(30/1.5):30;
    
    float divisor = duration*metadivisor;
    
    float xMovement = _isVerticle?0:(_directionVector.width/divisor);
    float yMovement = _isVerticle?(_directionVector.height/divisor):0;
    
    CGPoint perspectiveCenter = CGPointMake(center.x+xMovement, center.y+yMovement);
    
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
