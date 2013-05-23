//
//  BlackHole.h
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackHole : UIView

@property (nonatomic) BOOL isMoving;
@property (nonatomic) float dVectorDivisor;

- (id)initWithBallframe:(CGRect)ballframe;

- (void)redrawRectWithBallFrame:(CGRect)ballFrame;
- (void)redrawWithNSValueCGRect:(NSValue *)value;

- (void)moveWithDuration:(NSNumber *)duration;

- (void)setDifficultyWithNSNumber:(NSNumber *)number;

@property (nonatomic, assign) int difficulty;

@end
