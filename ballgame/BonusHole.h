//
//  BonusHole.h
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BonusHole : UIView {
    CGRect frame;
    NSTimer *timer;
}

- (id)initWithBallframe:(CGRect)ballframe;

- (void)redrawRectWithNewFrame:(CGRect)rect andBallFrame:(CGRect)ballFrame;

@end
