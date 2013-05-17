//
//  BackgroundView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "BackgroundView.h"

@interface BackgroundView ()

@property (nonatomic, assign) BOOL isClassicMode;

@end

@implementation BackgroundView

- (void)setClassicMode:(BOOL)classic {
    self.isClassicMode = classic;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (_isClassicMode) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [[UIColor darkGrayColor]CGColor]);
        CGContextFillRect(context, self.bounds);
        CGContextRestoreGState(context);
    } else {
        [[UIImage imageNamed:@"background"]drawInRect:self.bounds];
    }
}

@end
