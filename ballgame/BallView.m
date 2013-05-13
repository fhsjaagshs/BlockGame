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

@end

@implementation BallView

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"ball"]drawInRect:self.bounds];
}

- (void)moveSexilyCore {
    float numMovements = floorf(0.5/_link.duration);
    
    if (numMovements < 1) {
        [_link invalidate];
        self.link = nil;
        // we're done here;
        return;
    }
    
    float movement = log10f(numMovements);
}

- (void)moveSexilyWithTheta:(float)theta {
    if (_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveSexilyCore)];
    } else {
        [_link invalidate];
    }
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    NSLog(@"%@",_link.duration);
    self.theta = theta;
}

/*- (void)moveSexilyToPoint:(CGPoint)pointTwo {
    if (_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveSexily)];
    }
    self.sexyPoint = pointTwo;
    float a = self.center.y-_sexyPoint.y;
    float b = self.center.x-_sexyPoint.x;
    self.tangentialDistance = sqrtf((a*a)+(b*b));
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}*/

@end
