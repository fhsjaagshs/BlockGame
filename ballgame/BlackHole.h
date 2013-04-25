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
- (void)redrawRectWithBallFrameNSValue:(NSValue *)value;
- (void)startMoving;
- (void)stopMoving;

@end
