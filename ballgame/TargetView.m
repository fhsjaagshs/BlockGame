//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//

#import "TargetView.h"

@interface TargetView ()

@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, assign) BOOL isClassicMode;

@end

@implementation TargetView

- (void)setClassicMode:(BOOL)cm {
    self.isClassicMode = cm;
    
    if (!self.isClassicMode) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.cornerRadius = 0;
    } else {
        [self setBackgroundColor:[UIColor cyanColor]];
        self.layer.cornerRadius = 5;
    }
    
    [self setNeedsDisplay];
}

- (void)redrawWithBackgroundColor:(UIColor *)color vertically:(BOOL)vertically {
    self.backgroundColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.isClassicMode) {
        UIImage *image = nil;
        if (self.isHorizontal) {
            image = [[UIImage imageNamed:@"target"]stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        } else {
            image = [[UIImage imageNamed:@"target"]stretchableImageWithLeftCapWidth:0 topCapHeight:15];
        }
        [image drawInRect:self.bounds];
    }
}

- (void)redrawImageWithIsHorizontal:(BOOL)isH {
    self.isHorizontal = isH;
    [self setNeedsDisplay];
}

@end
