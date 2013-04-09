//
//  TargetView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//

#import "TargetView.h"

@interface TargetView ()

@property (nonatomic, assign) BOOL redrawVertically;
@property (nonatomic, strong) UIImage *image;

@end

@implementation TargetView

- (void)redrawWithBackgroundColor:(UIColor *)color {
    [self setNeedsDisplay];
    self.backgroundColor = color;
}

- (void)redrawVerticallyWithImage:(UIImage *)image {
    self.backgroundColor = [UIColor clearColor];
    self.redrawVertically = YES;
    self.image = image;
    [self setNeedsDisplay];
}

- (void)redrawHorizontallyWithImage:(UIImage *)image {
    self.backgroundColor = [UIColor clearColor];
    self.redrawVertically = NO;
    self.image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.image) {
        if (self.redrawVertically) {
            [self.image drawInRect:self.bounds];
        } else {
            
        }
    } else {
        
    }
}

@end
