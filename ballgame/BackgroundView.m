//
//  BackgroundView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"background"];
    UIImage *scaled = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen]scale] orientation:UIImageOrientationUp];
    [scaled drawInRect:self.bounds];
}

@end
