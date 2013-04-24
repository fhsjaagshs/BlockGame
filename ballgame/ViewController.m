//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize ball, target, difficulty, theme, score, gameOverLabel, theMainView, themeLabel, startButton, pauseButton, difficultyLabel, leaderboardButton, bonusHole, timer, highscore, blackholes, isAnimatingBlackHoles, motionManager, currentNumber;

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
    
    self.isAnimatingBlackHoles = NO;
    
    [self createMotionManager];
    [self loginUser];
    
    if ([networkTest isConnectedToInternet]) {
        [self submitOfflineScore];
    }
    
    NSString *savedScore = [[NSUserDefaults standardUserDefaults]objectForKey:@"savedScore"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"gameOver"]) {
        if (savedScore.length > 0) {
            [self.score setText:savedScore];
            [self.score setHidden:NO];
            [self.difficulty setHidden:YES];
            [self.difficultyLabel setHidden:NO];
            [self.startButton setTitle:@"Resume" forState:UIControlStateNormal];
        }
    }
    
    int diff = [[[NSUserDefaults standardUserDefaults]objectForKey:@"difficultyIndex"]intValue];
    int themey = [[[NSUserDefaults standardUserDefaults]objectForKey:@"themeIndex"]intValue];
    
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
    
    self.currentNumber = 5;
}

- (void)updateNumber {
    self.currentNumber += 2;
    [[NSUserDefaults standardUserDefaults]setFloat:self.currentNumber forKey:@"bonusholecurrentnumber"];
}

- (BOOL)shouldShowBonusHole {
    return (fmod(self.score.text.intValue+17, 20) == 0);
}

- (void)createMotionManager {
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 1/180;
}

- (void)handleAcceleration:(CMAcceleration)acceleration {
    
    if (!self.motionManager.isAccelerometerActive) {
        return;
    }
    
    float speed = 1;
    
    if (self.difficulty.selectedSegmentIndex == 0) {
        speed = 0.5;
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        speed = 1;
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        speed = 1.5;
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        speed = 2;
    }
    
    int rateX = (10*speed)*acceleration.x;
    int rateY = -1*(10*speed)*acceleration.y;
    
    CGPoint newCenterPoint = CGPointMake(self.ball.center.x+rateX, self.ball.center.y+rateY);
    
    if (CGRectContainsPoint([UIScreen mainScreen].bounds, newCenterPoint)) {
        self.ball.center = newCenterPoint;
    } else {
        [self gameOverWithoutBlackholeStoppage];
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.target.frame)) {
        [self randomizePosition];
        [self addOneToScore];
    }
    
    if (!self.isAnimatingBlackHoles) {
        CGRect frame = self.ball.frame;
        
        UIView *origin = [self.view hitTest:frame.origin withEvent:nil];
        UIView *maxX = [self.view hitTest:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y) withEvent:nil];
        UIView *maxY = [self.view hitTest:CGPointMake(frame.origin.x, frame.origin.y+frame.size.height) withEvent:nil];
        UIView *maxXY = [self.view hitTest:CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height) withEvent:nil];
        
        Class bhC = [BlackHole class];
        Class bonusHC = [BonusHole class];
        
        if ([origin isKindOfClass:bhC]) {
            [self gameOver];
        } else if ([maxX isKindOfClass:bhC]) {
            [self gameOver];
        } else if ([maxY isKindOfClass:bhC]) {
            [self gameOver];
        } else if ([maxXY isKindOfClass:bhC]) {
            [self gameOver];
        }
        
        if ([origin isKindOfClass:bonusHC]) {
            self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
            [self flashScoreLabelToGreen];
            [self.bonusHole setHidden:YES];
        } else if ([maxX isKindOfClass:bonusHC]) {
            self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
            [self flashScoreLabelToGreen];
            [self.bonusHole setHidden:YES];
        } else if ([maxY isKindOfClass:bonusHC]) {
            self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
            [self flashScoreLabelToGreen];
            [self.bonusHole setHidden:YES];
        } else if ([maxXY isKindOfClass:bonusHC]) {
            self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
            [self flashScoreLabelToGreen];
            [self.bonusHole setHidden:YES];
        }
    } else {
        if (CGRectIntersectsRect(self.ball.frame, self.bonusHole.frame) && !self.bonusHole.hidden) {
            self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
            [self flashScoreLabelToGreen];
            [self.bonusHole setHidden:YES];
        }
    }
}

- (void)stopMovingBlackHolemans {
    [self.blackholes makeObjectsPerformSelector:@selector(stopMoving) withObject:nil];
}

- (void)startMovingBlackHolmans {
    [self.blackholes makeObjectsPerformSelector:@selector(startMoving) withObject:nil];
}

- (void)destroyBlackHolemans {
    [self.blackholes makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [self.blackholes removeAllObjects];
}

- (void)redraw {
    [self updateBlackHolesArray];
    self.isAnimatingBlackHoles = YES;
    for (BlackHole *blackHoleman in self.blackholes) {
        [UIView animateWithDuration:0.1 animations:^{
            [blackHoleman redrawRectWithBallFrame:self.ball.frame];
        } completion:^(BOOL finished) {
            if (finished) {
                [blackHoleman startMoving];
                
                if ([self.blackholes indexOfObject:blackHoleman] == self.blackholes.count-1) {
                    self.isAnimatingBlackHoles = NO;
                }
            }
        }];
    }
}

- (int)getNumberHolesToCreate {
    if (self.blackholes.count == 0) {
        self.blackholes = [NSMutableArray arrayWithCapacity:7];
    }
    
    int max = (self.difficulty.selectedSegmentIndex > 0)?2+(self.difficulty.selectedSegmentIndex):0;
    
    int blackHolesC = floorf(self.score.text.intValue/10);
    
    if (blackHolesC > max) {
        blackHolesC = max;
    }
    
    return blackHolesC-self.blackholes.count;
}

- (void)updateBlackHolesArrayWithRedrawing {
    int remainder = [self getNumberHolesToCreate];
    
    for (int i = 0; i < remainder; i++) {
        BlackHole *blackHoleman = [[BlackHole alloc]init];
        [self.view addSubview:blackHoleman];
        [self.blackholes addObject:blackHoleman];
        [blackHoleman redrawRectWithBallFrame:self.ball.frame];
        [blackHoleman startMoving];
    }
}

- (void)updateBlackHolesArray {
    int remainder = [self getNumberHolesToCreate];
    
    for (int i = 0; i < remainder; i++) {
        BlackHole *blackHoleman = [[BlackHole alloc]init];
        [self.view addSubview:blackHoleman];
        [self.blackholes addObject:blackHoleman];
    }
}

- (void)startMotionManager {
    [self startMovingBlackHolmans];
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
    
    [self.target setClassicMode:!(self.theme.selectedSegmentIndex == 0)];
    
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
    self.target.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, self.target.frame.size.width+3, self.target.frame.size.height+3)].CGPath;
    
    if (self.theme.selectedSegmentIndex == 0) {
        [self.target redrawImageWithIsHorizontal:(whichSide > 2)];
    } else {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [self.target redrawWithBackgroundColor:[colors objectAtIndex:arc4random()%(8)] vertically:(whichSide < 3)];
    }
    
    self.target.hidden = NO;
}

- (NSString *)getCurrentLeaderboard {
    if (self.difficulty.selectedSegmentIndex == 0) {
        return @"com.fhsjaagshs.blockgamehs";
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        return @"com.fhsjaagshs.blockgameMedium";
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        return @"com.fhsjaagshs.blockGameHard";
    } else if (self.difficulty.selectedSegmentIndex == 3) {
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
            self.highscore = [NSString stringWithFormat:@"%lld",leaderboard.localPlayerScore.value];
            if (block) {
                block(nil);
            }
        } else {
            self.highscore = @"-1";
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
    if ([networkTest isConnectedToInternet] && [[NSUserDefaults standardUserDefaults]objectForKey:@"scoretosubmit"]) {
        int64_t ff = (int64_t)[[[NSUserDefaults standardUserDefaults]objectForKey:@"scoretosubmit"]intValue];
        [self submitScore:ff];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"scoretosubmit"];
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
    [self startMotionManager];
}

- (void)difficultyChanged {

    [self reloadHighscoresWithBlock:nil];

    NSString *savedPref = [NSString stringWithFormat:@"%d",self.difficulty.selectedSegmentIndex];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"difficultyIndex"];
    
    if (self.difficulty.selectedSegmentIndex == 0)  {
        [self.difficultyLabel setText:@"Easy"];
        [self destroyBlackHolemans];
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        [self.difficultyLabel setText:@"Medium"];
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        [self.difficultyLabel setText:@"Hard"];
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        [self.difficultyLabel setText:@"Insane"];
    }
}

- (void)themeChanged {
    NSString *savedPref = [NSString stringWithFormat:@"%d",self.theme.selectedSegmentIndex];
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"themeIndex"];
    
    BOOL isSelectedIndexOne = (self.theme.selectedSegmentIndex == 1);
    [self.theMainView setHidden:isSelectedIndexOne];
    [self.target setClassicMode:isSelectedIndexOne];
}

- (void)gameOver {
    [self stopMovingBlackHolemans];
    [self gameOverWithoutBlackholeStoppage];
}

- (void)gameOverWithoutBlackholeStoppage {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gameOver"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"bonusholecurrentnumber"];
    
    int64_t gameOverScore = self.score.text.intValue;
    
    NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    if ([networkTest isConnectedToInternet]) {
        int64_t personalBest = self.highscore.intValue;
        [self submitScore:gameOverScore];
        [self submitOfflineScore];
        
        if (gameOverScore > personalBest && personalBest != -1) {
            alert.message = @"Congrats, you beat your high score!";
        } else if (gameOverScore < personalBest && personalBest != -1) {
            alert.message = @"You did not beat your high score :(";
        } else {
            alert.message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
        }
        
    } else {
        alert.message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lli",gameOverScore] forKey:@"scoretosubmit"];
    }
    
    [alert show];
    
    [self.themeLabel setHidden:NO];
    [self.difficulty setHidden:NO];
    [self.theme setHidden:NO];
    [self stopMotionManager];
    [self.startButton setHidden:NO];
    [self.gameOverLabel setHidden:NO];
    [self.leaderboardButton setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.startButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)createTimer {
    if (self.difficulty.selectedSegmentIndex == 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else {
        self.timer = nil;
    }
}

- (void)togglePause {
    if (self.motionManager.isAccelerometerActive) {
        [self stopMotionManager];
        [self stopMovingBlackHolemans];
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.theme setHidden:NO];
        [self.themeLabel setHidden:NO];
        
        if (self.timer.isValid) {
            [self.timer invalidate];
        }

        self.timer = nil;
    } else {
        [self startMotionManager];
        [self startMovingBlackHolmans];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.themeLabel setHidden:YES];
        [self.theme setHidden:YES];
        
        if (!self.timer.isValid) {
            [self createTimer];
            [self.timer fire];
        }
        
        [self updateBlackHolesArray];
        
        if (self.bonusHole.superview) {
            [self.bonusHole redrawRectWithBallFrame:self.ball.frame];
        }
    }
}

- (void)startOrRetry {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gameOver"];

    [self reloadHighscoresWithBlock:nil];
    
    [self.difficultyLabel setHidden:NO];
    [self.ball setHidden:NO];
    [self.score setHidden:NO];
    
    [self destroyBlackHolemans];
    [self.bonusHole setHidden:YES];
    
    // reset titles
    if ([self.startButton.titleLabel.text isEqualToString:@"Start"]) {
        self.startButton.titleLabel.text = @"Retry";
    }
    
    // hide controls
    [self.difficulty setHidden:YES];
    [self.theme setHidden:YES];
    [self.themeLabel setHidden:YES];
    [self.leaderboardButton setHidden:YES];

    [self startMotionManager];

    if (!self.gameOverLabel.isHidden) {
        [self.score setText:@"0"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];
        [self.ball setCenter:self.view.center];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;

    [self randomizePosition];
    [self.gameOverLabel setHidden:YES];
    [self.startButton setHidden:YES];
    [self.pauseButton setHidden:NO];
    
    if ([networkTest isConnectedToInternet]) {
        [self submitOfflineScore];
    }
}

- (void)redrawBonusHole {
    
    if (!self.bonusHole) {
        self.bonusHole = [[BonusHole alloc]init];
        [self.view addSubview:self.bonusHole];
    }
    
    self.bonusHole.hidden = ![self shouldShowBonusHole];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.bonusHole redrawRectWithBallFrame:self.ball.frame];
    }];
}

- (void)addOneToScore {
    NSString *newScoreString = [NSString stringWithFormat:@"%d",self.score.text.intValue+1];
    [self.score setText:newScoreString];
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:@"savedScore"];

    [self updateNumber];
    
    [self updateBlackHolesArrayWithRedrawing];
    [self redrawBonusHole];
    
    if (self.difficulty.selectedSegmentIndex > 0) {
        if (self.blackholes.count > 0) {
            if (!self.timer.isValid) {
                [self createTimer];
                [self.timer fire];
            }
        } else {
            if (self.timer.isValid) {
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
