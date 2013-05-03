//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.theMainView = [[BackgroundView alloc]initWithFrame:self.view.bounds];
    self.theMainView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.theMainView];
    
    self.difficultyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 17)];
    self.difficultyLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.difficultyLabel.font = [UIFont boldSystemFontOfSize:17];
    self.difficultyLabel.textAlignment = UITextAlignmentCenter;
    self.difficultyLabel.textColor = [UIColor whiteColor];
    self.difficultyLabel.backgroundColor = [UIColor clearColor];
    self.difficultyLabel.hidden = YES;
    [self.view addSubview:self.difficultyLabel];
    
    self.themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 363, 320, 31)];
    self.themeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.themeLabel.font = [UIFont boldSystemFontOfSize:19];
    self.themeLabel.textAlignment = UITextAlignmentCenter;
    self.themeLabel.textColor = [UIColor whiteColor];
    self.themeLabel.backgroundColor = [UIColor clearColor];
    self.themeLabel.text = @"Theme";
    [self.view addSubview:self.themeLabel];
    
    self.gameOverLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 80)];
    self.gameOverLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.gameOverLabel.font = [UIFont boldSystemFontOfSize:34];
    self.gameOverLabel.textAlignment = UITextAlignmentCenter;
    self.gameOverLabel.textColor = [UIColor redColor];
    self.gameOverLabel.backgroundColor = [UIColor clearColor];
    self.gameOverLabel.text = @"Game Over";
    self.gameOverLabel.hidden = YES;
    [self.view addSubview:self.gameOverLabel];
    
    self.score = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 320, 30)];
    self.score.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.score.font = [UIFont systemFontOfSize:26];
    self.score.textAlignment = UITextAlignmentCenter;
    self.score.textColor = [UIColor whiteColor];
    self.score.backgroundColor = [UIColor clearColor];
    self.score.hidden = YES;
    self.score.text = @"0";
    [self.view addSubview:self.score];
    
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pauseButton.frame = CGRectMake(112, 76, 96, 37);
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    self.pauseButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.pauseButton.titleLabel.textColor = [UIColor whiteColor];
    self.pauseButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.pauseButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.pauseButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.pauseButton addTarget:self action:@selector(togglePause) forControlEvents:UIControlEventTouchDown];
    self.pauseButton.hidden = YES;
    [self.view addSubview:self.pauseButton];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    self.startButton.frame = CGRectMake(124, 228, 72, 37);
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.startButton.titleLabel.textColor = [UIColor whiteColor];
    self.startButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.startButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.startButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"startretry"] forState:UIControlStateNormal];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startOrRetry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    self.leaderboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leaderboardButton.frame = CGRectMake(102, 273, 113, 37);
    self.leaderboardButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    self.leaderboardButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.leaderboardButton.titleLabel.textColor = [UIColor whiteColor];
    self.leaderboardButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.leaderboardButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.leaderboardButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.leaderboardButton setBackgroundImage:[UIImage imageNamed:@"leaderboard"] forState:UIControlStateNormal];
    [self.leaderboardButton setTitle:@"Leaderboard" forState:UIControlStateNormal];
    [self.leaderboardButton addTarget:self action:@selector(showLeaderboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leaderboardButton];
    
    self.theme = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Modern", @"Classic", nil]];
    self.theme.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.theme.frame = CGRectMake(77, 402, 166, 30);
    self.theme.segmentedControlStyle = UISegmentedControlStyleBar;
    self.theme.tintColor = [UIColor lightGrayColor];
    [self.theme setSelectedSegmentIndex:0];
    [self.theme addTarget:self action:@selector(themeChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.theme];
    
    self.difficulty = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Easy", @"Medium", @"Hard", @"Insane", nil]];
    self.difficulty.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.difficulty.frame = CGRectMake(42, 326, 237, 30);
    self.difficulty.segmentedControlStyle = UISegmentedControlStyleBar;
    self.difficulty.tintColor = [UIColor lightGrayColor];
    [self.difficulty setSelectedSegmentIndex:0];
    [self.difficulty addTarget:self action:@selector(difficultyChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.difficulty];
    
    self.target = [[TargetView alloc]init];
    [self.view addSubview:self.target];
    
    self.ball = [[BallView alloc]initWithFrame:CGRectMake(141, 172, 38, 38)];
    self.ball.center = self.view.center;
    self.ball.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ball.layer.shadowOpacity = 0.7f;
    self.ball.layer.shadowOffset = CGSizeZero;
    self.ball.layer.shadowRadius = 5.0f;
    self.ball.layer.masksToBounds = NO;
    self.ball.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)].CGPath;
    self.ball.hidden = YES;
    [self.view addSubview:self.ball];
    
    [self createMotionManager];
    [self loginUser];
    
    [self submitOfflineScore];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        NSString *savedScore = [[NSUserDefaults standardUserDefaults]objectForKey:savedScoreKey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
        if (savedScore.length > 0) {
            [self.score setText:savedScore];
            [self.score setHidden:NO];
            [self.difficulty setHidden:YES];
            [self.difficultyLabel setHidden:NO];
            [self.startButton setTitle:@"Resume" forState:UIControlStateNormal];
        } else {
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        }
    }
    
    int diff = [[NSUserDefaults standardUserDefaults]floatForKey:difficultyIndexKey];
    int themey = [[NSUserDefaults standardUserDefaults]floatForKey:themeIndexKey];
    
    [self.difficulty setSelectedSegmentIndex:diff];
    [self.theme setSelectedSegmentIndex:themey];
    
    [self.leaderboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.difficultyLabel setTextColor:[UIColor whiteColor]];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.score setTextColor:[UIColor whiteColor]];
    [self.themeLabel setTextColor:[UIColor whiteColor]];
    [self.pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self difficultyChanged];
    [self themeChanged];
}

- (void)createMotionManager {
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 1/60; // used to be 1/180
}

- (void)handleAcceleration:(CMAcceleration)acceleration {
    
    float speed = 1;
    int index = _difficulty.selectedSegmentIndex;
    
    if (index == 0) {
        speed = 0.5;
    } else if (index == 1) {
        speed = 1;
    } else if (index == 2) {
        speed = 1.5;
    } else if (index == 3) {
        speed = 2;
    }
    
    float rateX = (10*speed)*acceleration.x;
    float rateY = -1*(10*speed)*acceleration.y;
    
    CGPoint newCenterPoint = CGPointMake(_ball.center.x+rateX, _ball.center.y+rateY);
    
    if (CGRectContainsPoint([UIScreen mainScreen].bounds, newCenterPoint)) {
        self.ball.center = newCenterPoint;
    } else {
        [self gameOverWithoutBlackholeStoppage];
    }
    
    if (CGRectIntersectsRect(_ball.frame, _target.frame)) {
        [self randomizePosition];
        [self addOneToScore];
    }
    
    if (CGRectIntersectsRect(_ball.frame, _bonusHole.frame) && !_bonusHole.hidden) {
        self.score.text = [NSString stringWithFormat:@"%d",_score.text.intValue+5];
        [self flashScoreLabelToGreen];
        [self.bonusHole setHidden:YES];
    }
    
    if ([self checkIfHitBlackHole]) {
        [self gameOver];
    }
}

- (void)stopMovingBlackHoles {
    [self.blackHoleOne stopMoving];
    [self.blackHoleTwo stopMoving];
    [self.blackHoleThree stopMoving];
    [self.blackHoleFour stopMoving];
    [self.blackHoleFive stopMoving];
}

- (void)startMovingBlackHoles {
    [self.blackHoleOne startMoving];
    [self.blackHoleTwo startMoving];
    [self.blackHoleThree startMoving];
    [self.blackHoleFour startMoving];
    [self.blackHoleFive startMoving];
}

- (void)hideBlackHoles {
    self.blackHoleOne.hidden = YES;
    self.blackHoleTwo.hidden = YES;
    self.blackHoleThree.hidden = YES;
    self.blackHoleFour.hidden = YES;
    self.blackHoleFive.hidden = YES;
}

- (BOOL)checkIfHitBlackHole {
    CGRect frame = _ball.frame;
    
    if (CGRectIntersectsRect(frame, _blackHoleOne.frame) && !_blackHoleOne.hidden) {
        return YES;
    }
    
    if (CGRectIntersectsRect(frame, _blackHoleTwo.frame) && !_blackHoleTwo.hidden) {
        return YES;
    }
    
    if (CGRectIntersectsRect(frame, _blackHoleThree.frame) && !_blackHoleThree.hidden) {
        return YES;
    }
    
    if (CGRectIntersectsRect(frame, _blackHoleFour.frame) && !_blackHoleFour.hidden) {
        return YES;
    }
    
    if (CGRectIntersectsRect(frame, _blackHoleFive.frame) && !_blackHoleFive.hidden) {
        return YES;
    }
    
    return NO;
}

- (int)numberOfBlackHoles {
    int index = _difficulty.selectedSegmentIndex;
    int max = (index > 0)?2+index:0;
    int blackHolesC = floorf(_score.text.intValue/10);
    
    if (blackHolesC > max) {
        return max;
    }
    
    return blackHolesC;
}

- (void)updateBlackHoles {
    
    if (!_blackHoleOne) {
        self.blackHoleOne = [[BlackHole alloc]init];
        [self.view addSubview:self.blackHoleOne];
        [self.blackHoleOne redrawRectWithBallFrame:_ball.frame];
    }
    
    self.blackHoleOne.hidden = YES;
    
    if (!_blackHoleTwo) {
        self.blackHoleTwo = [[BlackHole alloc]init];
        [self.view addSubview:self.blackHoleTwo];
        [self.blackHoleTwo redrawRectWithBallFrame:_ball.frame];
    }
    
    self.blackHoleTwo.hidden = YES;
    
    if (!_blackHoleThree) {
        self.blackHoleThree = [[BlackHole alloc]init];
        [self.view addSubview:self.blackHoleThree];
        [self.blackHoleThree redrawRectWithBallFrame:_ball.frame];
    }
    
    self.blackHoleThree.hidden = YES;
    
    if (!_blackHoleFour) {
        self.blackHoleFour = [[BlackHole alloc]init];
        [self.view addSubview:self.blackHoleFour];
        [self.blackHoleFour redrawRectWithBallFrame:_ball.frame];
    }
    
    self.blackHoleFour.hidden = YES;
    
    if (!_blackHoleFive) {
        self.blackHoleFive = [[BlackHole alloc]init];
        [self.view addSubview:self.blackHoleFive];
        [self.blackHoleFive redrawRectWithBallFrame:_ball.frame];
    }
    
    self.blackHoleFive.hidden = YES;
    
    int blackHolesC = [self numberOfBlackHoles];

    if (blackHolesC > 0) {
        self.blackHoleOne.hidden = NO;
        [self.blackHoleOne startMoving];
    }
    
    if (blackHolesC > 1) {
        self.blackHoleTwo.hidden = NO;
        [self.blackHoleTwo startMoving];
    }
    
    if (blackHolesC > 2) {
        self.blackHoleThree.hidden = NO;
        [self.blackHoleThree startMoving];
    }
    
    if (blackHolesC > 3) {
        self.blackHoleFour.hidden = NO;
        [self.blackHoleFour startMoving];
    }

    if (blackHolesC > 4) {
        self.blackHoleFive.hidden = NO;
        [self.blackHoleFive startMoving];
    }
}

- (void)startMotionManager {
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self handleAcceleration:accelerometerData.acceleration];
    }];
}

- (void)stopMotionManager {
    [self.motionManager startAccelerometerUpdatesToQueue:nil withHandler:nil];
    [self.motionManager stopAccelerometerUpdates];
}

- (void)randomizePosition {
    CGRect screenBounds = [[UIScreen mainScreen]applicationFrame];
    
    [self.target setClassicMode:!(_theme.selectedSegmentIndex == 0)];
    
    int whichSide = (arc4random()%4)+1;
    
    int x = 0;
    int y = 0;
    int width = 30;
    int height = 90;
    
    if (whichSide == 1) {
        // left
        int limit = (screenBounds.size.height-90);
        y = arc4random()%limit;
    } else if (whichSide == 2) {
        // right
        int limit = (screenBounds.size.height-90);
        y = arc4random()%limit;
        x = screenBounds.size.width-30;
    } else if (whichSide == 3) {
        // top
        int limit = (screenBounds.size.width-90);
        x = arc4random()%limit;
        width = 90;
        height = 30;
    } else if (whichSide == 4) {
        // bottom
        int limit = (screenBounds.size.width-90);
        x = arc4random()%limit;
        y = screenBounds.size.height-30;
        width = 90;
        height = 30;
    }
    
    self.target.frame = CGRectMake(x, y, width, height);
    self.target.layer.shadowColor = [UIColor blackColor].CGColor;
    self.target.layer.shadowOpacity = 0.9f;
    self.target.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.target.layer.shadowRadius = 5.0f;
    self.target.layer.masksToBounds = NO;
    self.target.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, _target.frame.size.width+3, _target.frame.size.height+3)]CGPath];
    
    if (_theme.selectedSegmentIndex == 0) {
        [self.target redrawWithImage];
    } else {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [self.target redrawWithBackgroundColor:[colors objectAtIndex:arc4random()%8]];
    }
    
    self.target.hidden = NO;
}

- (NSString *)getCurrentLeaderboard {
    int index = _difficulty.selectedSegmentIndex;
    if (index == 0) {
        return @"com.fhsjaagshs.blockgamehs";
    } else if (index == 1) {
        return @"com.fhsjaagshs.blockgameMedium";
    } else if (index == 2) {
        return @"com.fhsjaagshs.blockGameHard";
    } else if (index == 3) {
        return @"com.fhsjaagshs.blockGameInsane";
    }
    return nil;
}

- (void)loginUser {
    [GCManager authenticateLocalUserWithCompletionHandler:^(NSError *error) {
        if (!error) {
            [self reloadHighscoresWithBlock:nil];
        }
    }];
}

- (void)reloadHighscoresWithBlock:(void(^)(NSError *error))block {
    [GCManager reloadHighScoresForCategory:[self getCurrentLeaderboard] withCompletionHandler:^(NSArray *scores, GKLeaderboard *leaderboard, NSError *error) {
        if (!error) {
            self.highscore = (int)leaderboard.localPlayerScore.value;
            if (block) {
                block(nil);
            }
        } else {
            self.highscore = -1;
            if (block) {
                block(error);
            }
        }
    }];
}

- (void)submitScore:(int64_t)aScore {
    NSString *leaderboardName = [self getCurrentLeaderboard];
    [GCManager reportScore:aScore forCategory:leaderboardName withCompletionHandler:^(NSError *error) {
        [self reloadHighscoresWithBlock:nil];
    }];
}

- (void)submitOfflineScore {
    if ([networkTest isConnectedToInternet] && ([[NSUserDefaults standardUserDefaults]floatForKey:offlineScoreKey] > 0)) {
        int64_t ff = (int64_t)[[NSUserDefaults standardUserDefaults]floatForKey:offlineScoreKey];
        [self submitScore:ff];
        [[NSUserDefaults standardUserDefaults]setFloat:-1 forKey:offlineScoreKey];
    }
}

- (void)showLeaderboard {
    if ([networkTest isConnectedToInternet]) {
        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc]init];
        if (leaderboardController) {
            leaderboardController.category = [self getCurrentLeaderboard];
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            
            [self reloadHighscoresWithBlock:^(NSError *error) {
                [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
                [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                [self presentModalViewController:leaderboardController animated:YES];
            }];
        }
    } else {
        NSCustomAlertView *av = [[NSCustomAlertView alloc]initWithTitle:@"GameCenter Unavailable" message:@"Please connect to the internet to view leaderboards" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)difficultyChanged {

    [self reloadHighscoresWithBlock:nil];
    
    int index = _difficulty.selectedSegmentIndex;
    
    [[NSUserDefaults standardUserDefaults]setFloat:index forKey:difficultyIndexKey];
    
    if (self.difficulty.selectedSegmentIndex == 0)  {
        [self.difficultyLabel setText:@"Easy"];
        [self stopMovingBlackHoles];
        [self hideBlackHoles];
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        [self.difficultyLabel setText:@"Medium"];
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        [self.difficultyLabel setText:@"Hard"];
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        [self.difficultyLabel setText:@"Insane"];
    }
}

- (void)themeChanged {
    [[NSUserDefaults standardUserDefaults]setFloat:_theme.selectedSegmentIndex forKey:themeIndexKey];
    BOOL isSelectedIndexOne = (_theme.selectedSegmentIndex == 1);
    [self.theMainView setHidden:isSelectedIndexOne];
    [self.target setClassicMode:isSelectedIndexOne];
}

- (void)gameOver {
    [self stopMovingBlackHoles];
    [self gameOverWithoutBlackholeStoppage];
}

- (void)gameOverWithoutBlackholeStoppage {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        return;
    }
    
    [self stopMotionManager];
    
    if (_timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
    
    [self.themeLabel setHidden:NO];
    [self.difficulty setHidden:NO];
    [self.theme setHidden:NO];
    [self.startButton setHidden:NO];
    [self.gameOverLabel setHidden:NO];
    [self.leaderboardButton setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.startButton setTitle:@"Retry" forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:gameOverKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
    
    int64_t gameOverScore = _score.text.intValue;
    
    NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    if ([networkTest isConnectedToInternet]) {
        [self submitScore:gameOverScore];
        [self submitOfflineScore];
        
        if (gameOverScore > _highscore && _highscore != -1) {
            alert.message = @"Congrats, you beat your high score!";
        } else if (gameOverScore < _highscore && _highscore != -1) {
            alert.message = @"You did not beat your high score :(";
        } else {
            alert.message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
        }
        
    } else {
        alert.message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
        
        int offlineScore = [[NSUserDefaults standardUserDefaults]floatForKey:offlineScoreKey];
        
        if (gameOverScore > offlineScore) {
            offlineScore = gameOverScore;
        }
        
        [[NSUserDefaults standardUserDefaults]setFloat:offlineScore forKey:offlineScoreKey];
    }
    
    [alert show];
}

- (void)createTimer {
    int index = _difficulty.selectedSegmentIndex;
    if (index == 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else if (index == 2) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else if (index == 3) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else {
        self.timer = nil;
    }
}

- (void)togglePause {
    if (_motionManager.isAccelerometerActive) {
        [self stopMotionManager];
        [self stopMovingBlackHoles];
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.theme setHidden:NO];
        [self.themeLabel setHidden:NO];
        
        if (_timer.isValid) {
            [self.timer invalidate];
        }

        self.timer = nil;
    } else {
        
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.themeLabel setHidden:YES];
        [self.theme setHidden:YES];
        
        if (!_timer.isValid) {
            [self createTimer];
            [self.timer fire];
        }
        
        [self startMotionManager];
        [self updateBlackHoles];
        
        if (_bonusHole.superview) {
            [self.bonusHole redrawRectWithBallFrame:_ball.frame];
        }
    }
}

- (void)startOrRetry {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:gameOverKey];

    [self reloadHighscoresWithBlock:nil];
    
    [self hideBlackHoles];
    [self stopMovingBlackHoles];
    [self hideBlackHoles];
    [self.bonusHole setHidden:YES];
    
    [self startMotionManager];
    
    [self.difficultyLabel setHidden:NO];
    [self.ball setHidden:NO];
    [self.score setHidden:NO];

    [self.difficulty setHidden:YES];
    [self.theme setHidden:YES];
    [self.themeLabel setHidden:YES];
    [self.leaderboardButton setHidden:YES];
    
    [self.score setText:@"0"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
    [self.ball setCenter:self.view.center];
    
    if (_timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;

    [self randomizePosition];
    [self.gameOverLabel setHidden:YES];
    [self.startButton setHidden:YES];
    [self.pauseButton setHidden:NO];
    
    [self submitOfflineScore];
}

- (void)redrawBonusHole {
    
    if (!_bonusHole) {
        self.bonusHole = [[BonusHole alloc]init];
        [self.view addSubview:self.bonusHole];
    }
    
    self.bonusHole.hidden = (fmod(_score.text.intValue+17, 20) > 0);
    
    if (!_bonusHole.hidden) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.bonusHole redrawRectWithBallFrame:_ball.frame];
        }];
    }
}

- (void)redraw {
    [self updateBlackHoles];
    CGRect frame = _ball.frame;
    [self.blackHoleOne redrawRectWithBallFrame:frame];
    [self.blackHoleTwo redrawRectWithBallFrame:frame];
    [self.blackHoleThree redrawRectWithBallFrame:frame];
    [self.blackHoleFour redrawRectWithBallFrame:frame];
    [self.blackHoleFive redrawRectWithBallFrame:frame];
}

- (void)addOneToScore {
    NSString *newScoreString = [NSString stringWithFormat:@"%d",self.score.text.intValue+1];
    [self.score setText:newScoreString];
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:savedScoreKey];
    
    [self updateBlackHoles];
    [self redrawBonusHole];
    
    if (_difficulty.selectedSegmentIndex > 0) {
        if ([self numberOfBlackHoles] > 0) {
            if (!_timer.isValid) {
                [self createTimer];
                [self.timer fire];
            }
        } else {
            if (_timer.isValid) {
                [self.timer invalidate];
            }
            
            self.timer = nil;
        }
    }
}

- (void)flashScoreLabelToGreen {
    [self.score setTextColor:[UIColor greenColor]];
    [self.score performSelector:@selector(setTextColor:) withObject:[UIColor whiteColor] afterDelay:0.5];
}

@end
