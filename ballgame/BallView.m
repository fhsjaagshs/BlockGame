//
//  BallView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "BallView.h"

@implementation BallView

- (void)drawRect:(CGRect)rect {
    [[UIImage uncachedImageNamed:@"ball"]drawInRect:self.bounds];
}

@end
