//
//  BallView.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/10/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "BallView.h"

@interface BallView ()

@property (nonatomic, retain) CADisplayLink *link;
@property (nonatomic, assign) float theta;
@property (nonatomic, assign) float numMovements;

@end

@implementation BallView

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"ball"]drawInRect:self.bounds];
}

- (void)moveSexilyCore {    
    if (_numMovements < 1) {
        
        self.numMovements = floorf(0.5/_link.duration);
        
        if (_numMovements < 1) {
            [_link invalidate];
            self.link = nil;
            return;
        }
    }
    
    float movement = log10f(_numMovements);
    
    float x = movement*sinf(_theta);
    float y = movement*cosf(_theta);
    
    self.center = CGPointMake(self.center.x+x, self.center.y+y);
}

- (void)moveSexilyWithTheta:(float)theta {
    if (_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveSexilyCore)];
    } else {
        [_link invalidate];
    }
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.theta = theta;
}

@end
