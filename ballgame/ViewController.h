//
//  ViewController.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <GKLeaderboardViewControllerDelegate>

@property (strong, nonatomic) BallView *ball;
@property (strong, nonatomic) TargetView *target;

@property (strong, nonatomic) NSCustomSegmentedControl *difficulty;
@property (strong, nonatomic) NSCustomSegmentedControl *theme;
@property (strong, nonatomic) UILabel *score;
@property (strong, nonatomic) UILabel *gameOverLabel;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UILabel *difficultyLabel;
@property (strong, nonatomic) UIButton *leaderboardButton;

@property (strong, nonatomic) BonusHole *bonusHole;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *blackHoles;
@property (strong, nonatomic) CADisplayLink *link;

@property (assign, nonatomic) int highscore;
@property (assign, nonatomic) BOOL hitSideForGameOver;

- (void)togglePause;

- (void)startTimer;
- (void)stopTimer;

@end
