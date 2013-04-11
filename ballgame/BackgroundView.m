//
//  BackgroundView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"background"]drawInRect:self.bounds];
}

@end
