//
//  BonusHole.h
//  ballgame
//
//  Created by Nate Symer on 4/1/12.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BonusHole : UIView

- (id)initWithBallframe:(CGRect)ballframe;
- (void)redrawRectWithBallFrame:(CGRect)ballFrame;

@end
