//
//  TargetView.h
//  ballgame
//
//  Created by Nathaniel Symer on 4/9/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetView : UIView

- (void)redrawWithBackgroundColor:(UIColor *)color;
- (void)setClassicMode:(BOOL)cm;
- (void)redrawWithImage;

@property (nonatomic, assign) BOOL isClassicMode;
@property (nonatomic, assign) BOOL isVerticle;

@property (nonatomic) CGSize directionVector;
- (void)moveWithDuration:(NSNumber *)duration;

@end
