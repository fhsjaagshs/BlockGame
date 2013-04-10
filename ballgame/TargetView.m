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

- (UIImage *)imageRotatedNinety:(UIImage *)image {
    CGSize rotatedSize = CGSizeMake(image.size.height, image.size.width);
    
    UIGraphicsBeginImageContext(rotatedSize);
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, M_PI/2);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width/2, -image.size.height/2, image.size.width, image.size.height), image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)drawRect:(CGRect)rect {
    if (self.image) {
        if (self.redrawVertically) {
            [[self imageRotatedNinety:self.image]drawInRect:self.bounds];
        } else {
            [self.image drawInRect:self.bounds];
        }
    }
}

@end
