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

@property (strong, nonatomic) UISegmentedControl *difficulty;
@property (strong, nonatomic) UISegmentedControl *theme;
@property (strong, nonatomic) UILabel *score;
@property (strong, nonatomic) UILabel *gameOverLabel;
@property (strong, nonatomic) BackgroundView *theMainView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UILabel *difficultyLabel;
@property (strong, nonatomic) UIButton *leaderboardButton;

@property (strong, nonatomic) BonusHole *bonusHole;
/*@property (nonatomic, strong) BlackHole *blackHoleOne;
@property (nonatomic, strong) BlackHole *blackHoleTwo;
@property (nonatomic, strong) BlackHole *blackHoleThree;
@property (nonatomic, strong) BlackHole *blackHoleFour;
@property (nonatomic, strong) BlackHole *blackHoleFive;*/

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *blackHoles;

@property (assign, nonatomic) int highscore;

- (void)gameOver;
- (void)togglePause;

- (BOOL)checkStuff;

@end
