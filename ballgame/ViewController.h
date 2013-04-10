//
//  ViewController.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate, GKLeaderboardViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *ball;
@property (strong, nonatomic) TargetView *target;

// Targets (16 count)
@property (strong, nonatomic) IBOutlet UIView *one;
@property (strong, nonatomic) IBOutlet UIView *two;
@property (strong, nonatomic) IBOutlet UIView *three;
@property (strong, nonatomic) IBOutlet UIView *four;
@property (strong, nonatomic) IBOutlet UIView *five;
@property (strong, nonatomic) IBOutlet UIView *six;
@property (strong, nonatomic) IBOutlet UIView *seven;
@property (strong, nonatomic) IBOutlet UIView *eight;
@property (strong, nonatomic) IBOutlet UIView *nine;
@property (strong, nonatomic) IBOutlet UIView *ten;
@property (strong, nonatomic) IBOutlet UIView *eleven;
@property (strong, nonatomic) IBOutlet UIView *twelve;
@property (strong, nonatomic) IBOutlet UIView *thirteen;
@property (strong, nonatomic) IBOutlet UIView *fourteen;
@property (strong, nonatomic) IBOutlet UIView *fifteen;
@property (strong, nonatomic) IBOutlet UIView *sixteen;


// UIImageViews
// left
@property (strong, nonatomic) IBOutlet UIImageView *a;
@property (strong, nonatomic) IBOutlet UIImageView *b;
@property (strong, nonatomic) IBOutlet UIImageView *c;
@property (strong, nonatomic) IBOutlet UIImageView *d;
@property (strong, nonatomic) IBOutlet UIImageView *e;

// right
@property (strong, nonatomic) IBOutlet UIImageView *f;
@property (strong, nonatomic) IBOutlet UIImageView *g;
@property (strong, nonatomic) IBOutlet UIImageView *h;
@property (strong, nonatomic) IBOutlet UIImageView *i;
@property (strong, nonatomic) IBOutlet UIImageView *j;

// top
@property (strong, nonatomic) IBOutlet UIImageView *k;
@property (strong, nonatomic) IBOutlet UIImageView *l;
@property (strong, nonatomic) IBOutlet UIImageView *m;

// bottom
@property (strong, nonatomic) IBOutlet UIImageView *n;
@property (strong, nonatomic) IBOutlet UIImageView *o;
@property (strong, nonatomic) IBOutlet UIImageView *p;


@property (strong, nonatomic) IBOutlet UISegmentedControl *theme;
@property (strong, nonatomic) IBOutlet UIImageView *BGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ballImage;
@property (strong, nonatomic) IBOutlet UIView *theMainView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *themeLabel;
@property (strong, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (strong, nonatomic) IBOutlet UIButton *showGameCenterButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *difficulty;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *gameOverLabel;

@property (strong, nonatomic) BlackHole *blackHole;
@property (strong, nonatomic) BlackHole *blackHoleTwo;
@property (strong, nonatomic) BonusHole *bonusHole;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *highscore;
@property (assign) BOOL isAnimating;
@property (assign) BOOL bhTimerIsRunning;

- (void)gameOver;
- (IBAction)togglePause;
- (void)setStartButtonTitle:(NSString *)string;

@end
