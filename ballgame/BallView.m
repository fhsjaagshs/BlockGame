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
@property (nonatomic, assign) BOOL shouldGetNumMovements;
@property (nonatomic, assign) CGSize dVector;

@end

@implementation BallView

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"ball"]drawInRect:self.bounds];
}

- (void)moveSexilyCore {
    
    if (_numMovements < 1) {
        
        if (_shouldGetNumMovements) {
            self.numMovements = floorf(0.5/_link.duration);
            self.shouldGetNumMovements = NO;
        }
        
        if (_numMovements < 1) {
            [_link invalidate];
            self.link = nil;
            self.shouldGetNumMovements = YES;
            return;
        }
    }
    
    float movement = log10f(_numMovements)*2;
    
    float x = fabsf(movement*sinf(_theta))*_dVector.width;
    float y = fabsf(movement*cosf(_theta))*_dVector.height;
    
    self.center = CGPointMake(self.center.x+x, self.center.y+y);
    self.numMovements -= 1;
}

- (void)moveSexilyWithTheta:(float)theta andDirectionVector:(CGSize)vector {
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveSexilyCore)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    self.theta = theta;
    self.dVector = vector;
    self.shouldGetNumMovements = YES;
}

@end
