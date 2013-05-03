//
//  BlackHole.h
//  ballgame
//
//  Created by Nate Symer on 3/31/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackHole : UIView

- (id)initWithBallframe:(CGRect)ballframe;
- (void)redrawRectWithBallFrame:(CGRect)ballFrame;
- (void)startMoving;
- (void)stopMoving;

@property (nonatomic) BOOL isMoving;
@property (nonatomic) CGSize directionVector;
@property (nonatomic) float dVectorDivisor;
@property (nonatomic) CGRect screenBounds;

@end
