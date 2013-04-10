//
//  BallView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//
//

#import "BallView.h"

@implementation BallView

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"ball"]drawInRect:self.bounds];
}

@end
