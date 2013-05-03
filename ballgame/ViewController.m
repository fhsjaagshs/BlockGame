//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

CGRect screenBounds;

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    screenBounds = [[UIScreen mainScreen]bounds];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.theMainView = [[BackgroundView alloc]initWithFrame:self.view.bounds];
    _theMainView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_theMainView];
    
    self.difficultyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 17)];
    _difficultyLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _difficultyLabel.font = [UIFont boldSystemFontOfSize:17];
    _difficultyLabel.textAlignment = UITextAlignmentCenter;
    _difficultyLabel.textColor = [UIColor whiteColor];
    _difficultyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_difficultyLabel];
    
    self.themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 363, 320, 31)];
    _themeLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _themeLabel.font = [UIFont boldSystemFontOfSize:19];
    _themeLabel.textAlignment = UITextAlignmentCenter;
    _themeLabel.textColor = [UIColor whiteColor];
    _themeLabel.backgroundColor = [UIColor clearColor];
    _themeLabel.text = @"Theme";
    [self.view addSubview:_themeLabel];
    
    self.gameOverLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 80)];
    _gameOverLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _gameOverLabel.font = [UIFont boldSystemFontOfSize:34];
    _gameOverLabel.textAlignment = UITextAlignmentCenter;
    _gameOverLabel.textColor = [UIColor redColor];
    _gameOverLabel.backgroundColor = [UIColor clearColor];
    _gameOverLabel.text = @"Game Over";
    _gameOverLabel.hidden = YES;
    [self.view addSubview:_gameOverLabel];
    
    self.score = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 320, 30)];
    _score.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _score.font = [UIFont systemFontOfSize:26];
    _score.textAlignment = UITextAlignmentCenter;
    _score.textColor = [UIColor whiteColor];
    _score.backgroundColor = [UIColor clearColor];
    _score.text = @"0";
    [self.view addSubview:_score];
    
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseButton.frame = CGRectMake(112, 76, 96, 37);
    [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    _pauseButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _pauseButton.titleLabel.textColor = [UIColor whiteColor];
    _pauseButton.titleLabel.textAlignment = UITextAlignmentCenter;
    _pauseButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    _pauseButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    _pauseButton.hidden = YES;
    [_pauseButton addTarget:self action:@selector(togglePause) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_pauseButton];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    _startButton.frame = CGRectMake(124, 228, 72, 37);
    _startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _startButton.titleLabel.textColor = [UIColor whiteColor];
    _startButton.titleLabel.textAlignment = UITextAlignmentCenter;
    _startButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    _startButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [_startButton setBackgroundImage:[UIImage imageNamed:@"startretry"] forState:UIControlStateNormal];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startOrRetry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    self.leaderboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leaderboardButton.frame = CGRectMake(102, 273, 113, 37);
    _leaderboardButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    _leaderboardButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _leaderboardButton.titleLabel.textColor = [UIColor whiteColor];
    _leaderboardButton.titleLabel.textAlignment = UITextAlignmentCenter;
    _leaderboardButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    _leaderboardButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [_leaderboardButton setBackgroundImage:[UIImage imageNamed:@"leaderboard"] forState:UIControlStateNormal];
    [_leaderboardButton setTitle:@"Leaderboard" forState:UIControlStateNormal];
    [_leaderboardButton addTarget:self action:@selector(showLeaderboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leaderboardButton];
    
    self.theme = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Modern", @"Classic", nil]];
    _theme.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _theme.frame = CGRectMake(77, 402, 166, 30);
    _theme.segmentedControlStyle = UISegmentedControlStyleBar;
    _theme.tintColor = [UIColor lightGrayColor];
    [_theme setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults]floatForKey:themeIndexKey]];
    [_theme addTarget:self action:@selector(themeChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_theme];
    
    self.difficulty = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Easy", @"Medium", @"Hard", @"Insane", nil]];
    _difficulty.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _difficulty.frame = CGRectMake(42, 326, 237, 30);
    _difficulty.segmentedControlStyle = UISegmentedControlStyleBar;
    _difficulty.tintColor = [UIColor lightGrayColor];
    [_difficulty setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults]floatForKey:difficultyIndexKey]];
    [_difficulty addTarget:self action:@selector(difficultyChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_difficulty];
    
    self.target = [[TargetView alloc]init];
    [self.view addSubview:_target];
    
    self.ball = [[BallView alloc]initWithFrame:CGRectMake(141, 172, 38, 38)];
    _ball.center = self.view.center;
    _ball.layer.shouldRasterize = YES;
    _ball.layer.shadowColor = [[UIColor blackColor]CGColor];
    _ball.layer.shadowOpacity = 0.7f;
    _ball.layer.shadowOffset = CGSizeZero;
    _ball.layer.shadowRadius = 5.0f;
    _ball.layer.masksToBounds = NO;
    _ball.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)].CGPath;
    _ball.hidden = YES;
    [self.view addSubview:_ball];
    
    [self createMotionManager];
    [self loginUser];
    
    [self submitOfflineScore];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        NSString *savedScore = [[NSUserDefaults standardUserDefaults]objectForKey:savedScoreKey];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
        if (savedScore.length > 0) {
            [_score setText:savedScore];
            [_score setHidden:NO];
            [_difficulty setHidden:YES];
            [_startButton setTitle:@"Resume" forState:UIControlStateNormal];
        } else {
            [_score setHidden:YES];
            [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        }
    }
    
    [self difficultyChanged];
    [self themeChanged];
}

- (void)createMotionManager {
    self.motionManager = [[CMMotionManager alloc]init];
    _motionManager.accelerometerUpdateInterval = 1/60; // used to be 1/180
}

- (void)stopMovingBlackHoles {
    [_blackHoleOne stopMoving];
    [_blackHoleTwo stopMoving];
    [_blackHoleThree stopMoving];
    [_blackHoleFour stopMoving];
    [_blackHoleFive stopMoving];
}

- (void)startMovingBlackHoles {
    [_blackHoleOne startMoving];
    [_blackHoleTwo startMoving];
    [_blackHoleThree startMoving];
    [_blackHoleFour startMoving];
    [_blackHoleFive startMoving];
}

- (void)hideBlackHoles {
    _blackHoleOne.hidden = YES;
    _blackHoleTwo.hidden = YES;
    _blackHoleThree.hidden = YES;
    _blackHoleFour.hidden = YES;
    _blackHoleFive.hidden = YES;
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
        [self.view addSubview:_blackHoleOne];
        [_blackHoleOne redrawRectWithBallFrame:_ball.frame];
    }
    
    if (!_blackHoleTwo) {
        self.blackHoleTwo = [[BlackHole alloc]init];
        [self.view addSubview:_blackHoleTwo];
        [_blackHoleTwo redrawRectWithBallFrame:_ball.frame];
    }
    
    if (!_blackHoleThree) {
        self.blackHoleThree = [[BlackHole alloc]init];
        [self.view addSubview:_blackHoleThree];
        [_blackHoleThree redrawRectWithBallFrame:_ball.frame];
    }
    
    if (!_blackHoleFour) {
        self.blackHoleFour = [[BlackHole alloc]init];
        [self.view addSubview:_blackHoleFour];
        [_blackHoleFour redrawRectWithBallFrame:_ball.frame];
    }
    
    if (!_blackHoleFive) {
        self.blackHoleFive = [[BlackHole alloc]init];
        [self.view addSubview:_blackHoleFive];
        [_blackHoleFive redrawRectWithBallFrame:_ball.frame];
    }
    
    int blackHolesC = [self numberOfBlackHoles];

    if (blackHolesC > 0) {
        _blackHoleOne.hidden = NO;
        [_blackHoleOne startMoving];
    } else {
        _blackHoleOne.hidden = YES;
    }
    
    if (blackHolesC > 1) {
        _blackHoleTwo.hidden = NO;
        [_blackHoleTwo startMoving];
    } else {
        _blackHoleTwo.hidden = YES;
    }
    
    if (blackHolesC > 2) {
        _blackHoleThree.hidden = NO;
        [_blackHoleThree startMoving];
    } else {
        _blackHoleThree.hidden = YES;
    }
    
    if (blackHolesC > 3) {
        _blackHoleFour.hidden = NO;
        [_blackHoleFour startMoving];
    } else {
        _blackHoleFour.hidden = YES;
    }

    if (blackHolesC > 4) {
        _blackHoleFive.hidden = NO;
        [_blackHoleFive startMoving];
    } else {
        _blackHoleFive.hidden = YES;
    }
}

- (void)handleAcceleration:(CMAcceleration)acceleration {
    int speed = (_difficulty.selectedSegmentIndex+1)*10;
    
    float rateX = speed*acceleration.x;
    float rateY = -1*speed*acceleration.y;
    
    CGPoint newCenterPoint = CGPointMake(_ball.center.x+rateX, _ball.center.y+rateY);
    
    if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
        _ball.center = newCenterPoint;
    } else {
        [self gameOverWithoutBlackholeStoppage];
    }
    
    if (CGRectIntersectsRect(_ball.frame, _target.frame)) {
        [self randomizePosition];
        [self addOneToScore];
    }
    
    if (CGRectIntersectsRect(_ball.frame, _bonusHole.frame) && !_bonusHole.hidden) {
        _score.text = [NSString stringWithFormat:@"%d",_score.text.intValue+5];
        [self flashScoreLabelToGreen];
        [_bonusHole setHidden:YES];
    }
    
    if ([self checkIfHitBlackHole]) {
        [self gameOver];
    }
}

- (void)startMotionManager {
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self handleAcceleration:accelerometerData.acceleration];
    }];
}

- (void)stopMotionManager {
    [_motionManager startAccelerometerUpdatesToQueue:nil withHandler:nil];
    [_motionManager stopAccelerometerUpdates];
}

- (void)randomizePosition {
    [_target setClassicMode:!(_theme.selectedSegmentIndex == 0)];
    
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
    
    _target.frame = CGRectMake(x, y, width, height);
    _target.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, width+3, height+3)]CGPath];

    if (_theme.selectedSegmentIndex == 0) {
        [_target redrawWithImage];
    } else {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [_target redrawWithBackgroundColor:[colors objectAtIndex:arc4random()%8]];
    }
    
    _target.hidden = NO;
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
            _highscore = (int)leaderboard.localPlayerScore.value;
            if (block) {
                block(nil);
            }
        } else {
            _highscore = -1;
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
            
            UIView *blockerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
            blockerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            blockerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
            blockerView.clipsToBounds = YES;
            blockerView.layer.cornerRadius = 10;
            
            UIActivityIndicatorView	*spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            spinner.center = CGPointMake(blockerView.bounds.size.width/2, (blockerView.bounds.size.height/2)+10);
            [blockerView addSubview:spinner];
            [self.view addSubview:blockerView];
            [spinner startAnimating];
            
            self.view.userInteractionEnabled = NO;
            
            [self reloadHighscoresWithBlock:^(NSError *error) {
                self.view.userInteractionEnabled = YES;
                [spinner stopAnimating];
                [spinner removeFromSuperview];
                [blockerView removeFromSuperview];
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
    
    if (index == 0)  {
        [_difficultyLabel setText:@"Easy"];
        [self stopMovingBlackHoles];
        [self hideBlackHoles];
    } else if (index == 1) {
        [_difficultyLabel setText:@"Medium"];
    } else if (index == 2) {
        [_difficultyLabel setText:@"Hard"];
    } else if (index == 3) {
        [_difficultyLabel setText:@"Insane"];
    }
}

- (void)themeChanged {
    [[NSUserDefaults standardUserDefaults]setFloat:_theme.selectedSegmentIndex forKey:themeIndexKey];
    BOOL isSelectedIndexOne = (_theme.selectedSegmentIndex == 1);
    [_theMainView setHidden:isSelectedIndexOne];
    [_target setClassicMode:isSelectedIndexOne];
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
        [_timer invalidate];
    }
    
    self.timer = nil;
    
    [_themeLabel setHidden:NO];
    [_difficulty setHidden:NO];
    [_theme setHidden:NO];
    [_startButton setHidden:NO];
    [_gameOverLabel setHidden:NO];
    [_leaderboardButton setHidden:NO];
    [_pauseButton setHidden:YES];
    [_startButton setTitle:@"Retry" forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:gameOverKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
    
    int64_t gameOverScore = _score.text.intValue;
    
    NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    if ([networkTest isConnectedToInternet]) {
        [self submitScore:gameOverScore];
        [self submitOfflineScore];
        
        if (gameOverScore > _highscore && _highscore > -1) {
            alert.message = @"Congrats, you beat your high score!";
        } else if (gameOverScore < _highscore && _highscore > -1) {
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
        [_pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [_theme setHidden:NO];
        [_themeLabel setHidden:NO];
        
        if (_timer.isValid) {
            [_timer invalidate];
        }

        self.timer = nil;
    } else {
        [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [_themeLabel setHidden:YES];
        [_theme setHidden:YES];
        
        if (!_timer.isValid) {
            [self createTimer];
            [_timer fire];
        }
        
        [self startMotionManager];
        [self updateBlackHoles];
        
        if (_bonusHole.superview) {
            [_bonusHole redrawRectWithBallFrame:_ball.frame];
        }
    }
}

- (void)startOrRetry {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:gameOverKey];

    [self reloadHighscoresWithBlock:nil];
    
    [self hideBlackHoles];
    [self stopMovingBlackHoles];
    [_bonusHole setHidden:YES];
    
    [self startMotionManager];
    
    [_difficultyLabel setHidden:NO];
    [_ball setHidden:NO];
    [_score setHidden:NO];
    [_difficulty setHidden:YES];
    [_theme setHidden:YES];
    [_themeLabel setHidden:YES];
    [_leaderboardButton setHidden:YES];
    [_gameOverLabel setHidden:YES];
    [_startButton setHidden:YES];
    [_pauseButton setHidden:NO];
    
    [_score setText:@"0"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
    [_ball setCenter:self.view.center];
    
    if (_timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;

    [self randomizePosition];
    [self submitOfflineScore];
}

- (void)redrawBonusHole {
    
    if (!_bonusHole) {
        self.bonusHole = [[BonusHole alloc]init];
        [self.view addSubview:_bonusHole];
    }
    
    _bonusHole.hidden = (fmod(_score.text.intValue+17, 20) > 0);
    
    if (!_bonusHole.hidden) {
        [UIView animateWithDuration:0.1 animations:^{
            [_bonusHole redrawRectWithBallFrame:_ball.frame];
        }];
    }
}

- (void)redraw {
    [self updateBlackHoles];
    CGRect frame = _ball.frame;
    [_blackHoleOne redrawRectWithBallFrame:frame];
    [_blackHoleTwo redrawRectWithBallFrame:frame];
    [_blackHoleThree redrawRectWithBallFrame:frame];
    [_blackHoleFour redrawRectWithBallFrame:frame];
    [_blackHoleFive redrawRectWithBallFrame:frame];
}

- (void)addOneToScore {
    NSString *newScoreString = [NSString stringWithFormat:@"%d",_score.text.intValue+1];
    [_score setText:newScoreString];
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:savedScoreKey];
    
    [self updateBlackHoles];
    [self redrawBonusHole];
    
    if (_difficulty.selectedSegmentIndex > 0) {
        if ([self numberOfBlackHoles] > 0) {
            if (!_timer.isValid) {
                [self createTimer];
                [_timer fire];
            }
        } else {
            if (_timer.isValid) {
                [_timer invalidate];
            }
            
            self.timer = nil;
        }
    }
}

- (void)flashScoreLabelToGreen {
    [_score setTextColor:[UIColor greenColor]];
    [_score performSelector:@selector(setTextColor:) withObject:[UIColor whiteColor] afterDelay:0.5];
}

@end
