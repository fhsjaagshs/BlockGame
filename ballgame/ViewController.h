//
//  ViewController.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate, GKLeaderboardViewControllerDelegate>

@property (strong, nonatomic) BallView *ball;
@property (strong, nonatomic) TargetView *target;

@property (strong, nonatomic) IBOutlet UISegmentedControl *theme;
@property (strong, nonatomic) IBOutlet UIImageView *BGImageView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (strong, nonatomic) IBOutlet UIButton *showGameCenterButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *difficulty;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *gameOverLabel;

@property (strong, nonatomic) BackgroundView *theMainView;
@property (strong, nonatomic) UILabel *themeLabel;

@property (strong, nonatomic) BlackHole *blackHole;
@property (strong, nonatomic) BlackHole *blackHoleTwo;
@property (strong, nonatomic) BonusHole *bonusHole;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *highscore;
@property (assign, nonatomic) BOOL isAnimatingBHOne;
@property (assign, nonatomic) BOOL isAnimatingBHTwo;
@property (assign, nonatomic) BOOL motionManagerIsRunning;

@property (strong, nonatomic) CMMotionManager *motionManager;

- (void)gameOver;
- (IBAction)togglePause;
- (void)setStartButtonTitle:(NSString *)string;

@end
