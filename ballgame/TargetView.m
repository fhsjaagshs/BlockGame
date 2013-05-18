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
    }
    return self;
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
