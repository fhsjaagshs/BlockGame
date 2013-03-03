//
//  ViewController.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"
#import "BlackHole.h"
#import "BonusHole.h"

@interface ViewController : UIViewController <UIAccelerometerDelegate, GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate> {
    IBOutlet UIView *ball;
    
    // Targets (16 count)
    IBOutlet UIView *one;
    IBOutlet UIView *two;
    IBOutlet UIView *three;
    IBOutlet UIView *four;
    IBOutlet UIView *five;
    IBOutlet UIView *six;
    IBOutlet UIView *seven;
    IBOutlet UIView *eight;
    IBOutlet UIView *nine;
    IBOutlet UIView *ten;
    IBOutlet UIView *eleven;
    IBOutlet UIView *twelve;
    IBOutlet UIView *thirteen;
    IBOutlet UIView *fourteen;
    IBOutlet UIView *fifteen;
    IBOutlet UIView *sixteen;
    
    
    // UIImageViews
    // left
    IBOutlet UIImageView *a;
    IBOutlet UIImageView *b;
    IBOutlet UIImageView *c;
    IBOutlet UIImageView *d;
    IBOutlet UIImageView *e;
    
    // right
    IBOutlet UIImageView *f;
    IBOutlet UIImageView *g;
    IBOutlet UIImageView *h;
    IBOutlet UIImageView *i;
    IBOutlet UIImageView *j;
    
    // top
    IBOutlet UIImageView *k;
    IBOutlet UIImageView *l;
    IBOutlet UIImageView *m;
    
    // bottom
    IBOutlet UIImageView *n;
    IBOutlet UIImageView *o;
    IBOutlet UIImageView *p;
    
    
    IBOutlet UISegmentedControl *theme;
    IBOutlet UIImageView *BGImageView;
    IBOutlet UIImageView *ballImage;
    IBOutlet UIView *theMainView;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *pauseButton;
    IBOutlet UILabel *themeLabel;
    IBOutlet UILabel *difficultyLabel;
    IBOutlet UIButton *showGameCenterButton;
    IBOutlet UISegmentedControl *difficulty; 
    
    GameCenterManager *gameCenterManager;
}

@property (retain) IBOutlet UILabel *score;

@property (retain) IBOutlet UILabel *gameOverLabel;

@property (retain) BlackHole *blackHole;

@property (retain) BlackHole *blackHoleTwo;

@property (retain) BonusHole *bonusHole;

@property (assign) BOOL isAnimating;

@property (retain) NSTimer *timer;

@property (assign) BOOL bhTimerIsRunning;

@property (retain) NSArray *targets;

@property (retain) NSString *highscore;

- (void)gameOver;

- (void)hideEmAll;

- (void)setStartButtonTitle:(NSString *)string;

- (IBAction)togglePause:(id)sender;

@end
