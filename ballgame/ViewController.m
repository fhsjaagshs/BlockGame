//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize timer, blackHole, blackHoleTwo, bonusHole, score, gameOverLabel, highscore;

- (void)loadView {
    self.theMainView = [[BackgroundView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view addSubview:self.theMainView];
}

- (void)createMotionManager {
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 0.2;
    self.motionManager.gyroUpdateInterval = 0.2;
}

- (void)setStartPosition:(CMAcceleration)acceleration {
    NSString *saveString = [NSString stringWithFormat:@"%f,%f,%f", acceleration.x, acceleration.y, acceleration.z];
    [[NSUserDefaults standardUserDefaults]setObject:saveString forKey:@"saved_position"];
}

- (CMAcceleration)getStartPosition {
    NSString *savedString = [[NSUserDefaults standardUserDefaults]objectForKey:@"saved_position"];
    NSArray *array = [savedString componentsSeparatedByString:@","];
    CMAcceleration acceleration;
    acceleration.x = [[array objectAtIndex:0]doubleValue];
    acceleration.y = [[array objectAtIndex:1]doubleValue];
    acceleration.x = [[array objectAtIndex:2]doubleValue];
    return acceleration;
}

- (void)handleAcceleration:(CMAcceleration)acceleration {
    double xValNonAbs = acceleration.x;
    double yValNonAbs = acceleration.y;
    
    CMAcceleration positionAcceleration = [self getStartPosition];
    
    double xVal = fabs(xValNonAbs)-positionAcceleration.x;
    double yVal = fabs(yValNonAbs)-positionAcceleration.y;
    
    CGRect screenBounds = CGRectMake(0, 0, 320, 480);
    CGRect ballRect = self.ball.frame;
    
    int speed = 7;
    
    if (self.difficulty.selectedSegmentIndex == 0) {
        speed = 5;
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        speed = 7;
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        speed = 11;
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        speed = 20;
    }
    
    int rateX = 10*acceleration.x;
    int rateY = -1*10*acceleration.y;
    float currentX = self.ball.center.x;
    float currentY = self.ball.center.y;
    
    CGPoint newCenterPoint = CGPointZero;
    
    if (rateX > 0 && rateY == 0) {
        newCenterPoint = CGPointMake(currentX+(xVal*speed), self.ball.center.y);
    } else if (rateX == 0 && rateY > 0) {
        newCenterPoint = CGPointMake(self.ball.center.x, currentY+(yVal*speed));
    } else if (rateX > 0 && rateY > 0) {
        newCenterPoint = CGPointMake(currentX+(xVal*speed), currentY+(yVal*speed));
    } else if (rateX < 0 && rateY == 0) {
        newCenterPoint = CGPointMake(currentX-(xVal*speed), self.ball.center.y);
    } else if (rateX == 0 && rateY < 0) {
        newCenterPoint = CGPointMake(self.ball.center.x, currentY-(yVal*speed));
    } else if (rateX > 0 && rateY < 0) {
        newCenterPoint = CGPointMake(currentX+(xVal*speed), currentY-(yVal*speed));
    } else if (rateX < 0 && rateY > 0) {
        newCenterPoint = CGPointMake(currentX-(xVal*speed), currentY+(yVal*speed));
    } else if (rateX < 0 && rateY < 0) {
        newCenterPoint = CGPointMake(currentX-(xVal*speed), currentY-(yVal*speed));
    }
    
    if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
        self.ball.center = newCenterPoint;
    } else {
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(ballRect, self.target.frame)) {
        [self randomizePosition];
        [self addOneToScore];
    }
    
    if ((CGRectIntersectsRect(ballRect, self.blackHole.frame) || CGRectIntersectsRect(ballRect, self.blackHoleTwo.frame)) && !self.isAnimating) {
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(ballRect, self.bonusHole.frame)) {
        [self countFive];
        [self.bonusHole removeFromSuperview];
        self.bonusHole = nil;
    }
}

- (void)startMotionManager {
    self.motionManagerIsRunning = YES;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
        [self handleAcceleration:accelerometerData.acceleration];
    }];
}

- (void)stopMotionManager {
    self.motionManagerIsRunning = NO;
    [self.motionManager stopAccelerometerUpdates];
}

- (void)randomizePosition {
    CGRect screenBounds = [[UIScreen mainScreen]applicationFrame];
    
    int whichSide = (arc4random()%3)+1;
    
    int x = 0;
    int y = 0;
    
    if (whichSide == 1) {
        // left
        int limit = (screenBounds.size.height-90);
        y = arc4random()%limit;
    } else if (whichSide == 2) {
        // right
        int limit = (screenBounds.size.height-90);
        y = arc4random()%limit;
        x = screenBounds.size.width-26;
    } else if (whichSide == 3) {
        // top
        int limit = (screenBounds.size.width-26);
        x = arc4random()%limit;
    } else if (whichSide == 4) {
        // bottom
        int limit = (screenBounds.size.width-26);
        x = arc4random()%limit;
        y = screenBounds.size.height-26;
    }
    
    self.target.frame = CGRectMake(x, y, 26, 90);
    self.target.hidden = NO;
    
    if (self.theme.selectedSegmentIndex == 0) {
        
        NSArray *images = [NSArray arrayWithObjects:@"black", @"blue", @"green", @"purple", @"red", @"yellow", nil];
        int randomColorIndex = (arc4random()%images.count)-1;
        
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:randomColorIndex]];
        
        if (whichSide > 2) {
            [self.target redrawHorizontallyWithImage:image];
        } else {
            [self.target redrawVerticallyWithImage:image];
        }
    } else {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [self.target redrawWithBackgroundColor:[colors objectAtIndex:arc4random()%(8)]];
    }
}

- (void)setStartButtonTitle:(NSString *)string {
    [self.startButton setTitle:string forState:UIControlStateNormal];
    
    if ([string isEqualToString:@"Resume"]) {
        [score setHidden:NO];
        [self.difficulty setHidden:YES];
        [self.difficultyLabel setHidden:NO];
    }
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
        } else {
            NSCustomAlertView *av = [[NSCustomAlertView alloc]initWithTitle:@"Login failed" message:@"Is your device associated with GameCenter?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }];
}

- (void)reloadHighscoresWithBlock:(void(^)(NSError *error))block {
    [GCManager reloadHighScoresForCategory:[self getCurrentLeaderboard] withCompletionHandler:^(NSArray *scores, GKLeaderboard *leaderboard, NSError *error) {
        if (error == nil) {
            int64_t personalBest = leaderboard.localPlayerScore.value;
            self.highscore = [NSString stringWithFormat:@"%lld",personalBest];
        } else {
            self.highscore = @"-1";
        }
        block(error);
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

- (IBAction)showLeaderboard {
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self loginUser];
}

- (void)scoreReported:(NSError *)error {
    [self reloadHighscoresWithBlock:nil];
}

- (IBAction)difficultyChanged {

    [self reloadHighscoresWithBlock:nil];

    NSString *savedPref = [NSString stringWithFormat:@"%d",self.difficulty.selectedSegmentIndex];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"difficultyIndex"];
    
    if (self.difficulty.selectedSegmentIndex == 0)  {
        [self.difficultyLabel setText:@"Easy"];
        [self.blackHoleTwo removeFromSuperview];
        [self.blackHole removeFromSuperview];
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        [self.difficultyLabel setText:@"Medium"];
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        [self.difficultyLabel setText:@"Hard"];
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        [self.difficultyLabel setText:@"Insane"];
    }
}

- (IBAction)themeChanged {
    int value = self.theme.selectedSegmentIndex;
    NSString *savedPref = [NSString stringWithFormat:@"%d",value];
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"themeIndex"];
    
    BOOL isSelectedIndexOne = (self.theme.selectedSegmentIndex == 1);
    UIColor *titleColor = isSelectedIndexOne?[UIColor blackColor]:[UIColor whiteColor];
    
    [self.showGameCenterButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.difficultyLabel setTextColor:titleColor];
    [self.startButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.score setTextColor:titleColor];
    [self.themeLabel setTextColor:titleColor];
    [self.pauseButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.BGImageView setHidden:isSelectedIndexOne];
    [self.target setImageHidden:!isSelectedIndexOne];
}

- (void)gameOver {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gameOver"];
    
    int64_t gameOverScore = [self.score.text intValue];
    [self submitScore:gameOverScore];

    NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    if ([networkTest isConnectedToInternet]) {
        int64_t personalBest = self.highscore.intValue;
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
    [self.showGameCenterButton setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.startButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)togglePause {
    if (self.motionManagerIsRunning) {
        [self stopMotionManager];
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.theme setHidden:NO];
        [self.themeLabel setHidden:NO];
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self startMotionManager];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.themeLabel setHidden:YES];
        [self.theme setHidden:YES];
        
        if (!self.timer.isValid) {

            if (self.difficulty.selectedSegmentIndex == 1) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (self.difficulty.selectedSegmentIndex == 2) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (self.difficulty.selectedSegmentIndex == 3) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else {
                self.timer = nil;
            }
            
            [self.timer fire];
            
            if (self.blackHole.superview) {
                [self.blackHole redrawRectWithBallFrame:self.ball.frame];
            }
            
            if (self.blackHoleTwo.superview) {
                [self.blackHoleTwo redrawRectWithBallFrame:self.ball.frame];
            }
            
            if (self.bonusHole.superview) {
                [self.bonusHole redrawRectWithBallFrame:self.ball.frame];
            }
        }
    }
}

- (IBAction)startOrRetry {
    // Set the gameOver boolean, used for restoring to the previous state after a terminate
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gameOver"];

    [self reloadHighscoresWithBlock:nil];
    
    [self.difficultyLabel setHidden:NO];
    [self.ball setHidden:NO];
    [self.score setHidden:NO];
    
    // where the bonus and black holes get hidden...
    [self.blackHole removeFromSuperview];
    [self.blackHoleTwo removeFromSuperview];
    [self.bonusHole removeFromSuperview];
    
    // reset titles
    if ([self.startButton.titleLabel.text isEqualToString:@"Start"]) {
        self.startButton.titleLabel.text = @"Retry";
    }
    
    // hide controls
    [self.difficulty setHidden:YES];
    [self.theme setHidden:YES];
    [self.themeLabel setHidden:YES];
    [self.showGameCenterButton setHidden:YES];
    
    // make the ball respond to the accelerotemer
    [self startMotionManager];
    
    // Stuff that should happen to restart the game
    if (!gameOverLabel.isHidden) { // if the gameover label is showing
        [self.score setText:@"0"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];
        [self.ball setCenter:self.view.center];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.target setHidden:YES];
    }
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;

    [self randomizePosition];
    [self.gameOverLabel setHidden:YES];
    [self.startButton setHidden:YES];
    [self.pauseButton setHidden:NO];
    
    [self submitOfflineScore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isAnimatingBHOne = NO;
    self.isAnimatingBHTwo = NO;
    
    [self createMotionManager]; // 1/180 update interval
    
    [self loginUser];
    
    self.ball = [[BallView alloc]initWithFrame:CGRectMake(141, 172, 38, 38)];
    [self.view addSubview:self.ball];
    
    self.target = [[TargetView alloc]init];
    self.target.layer.shadowColor = [UIColor blackColor].CGColor;
    self.target.layer.shadowOpacity = 0.9f;
    self.target.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.target.layer.shadowRadius = 5.0f;
    self.target.layer.masksToBounds = NO;
    self.target.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -2, self.target.frame.size.width+2, self.target.frame.size.height+2)].CGPath;
    [self.view addSubview:self.target];
    
    self.ball.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ball.layer.shadowOpacity = 0.7f;
    self.ball.layer.shadowOffset = CGSizeZero;
    self.ball.layer.shadowRadius = 5.0f;
    self.ball.layer.masksToBounds = NO;
    self.ball.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)].CGPath;
}

- (BOOL)isAnimating {
    return (!self.isAnimatingBHOne && !self.isAnimatingBHTwo);
}

- (void)redrawOne {
    if (!self.blackHole) {
        self.blackHole = [[BlackHole alloc]init];
    }
    
    if (!self.blackHole.superview) {
        [self.view addSubview:self.blackHole];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.blackHole redrawRectWithBallFrame:self.ball.frame];
    } completion:^(BOOL finished) {
        if (finished) {
            self.isAnimatingBHOne = NO;
        }
    }];
}

- (void)redrawTwo {
    
    if (!self.blackHoleTwo) {
        self.blackHoleTwo = [[BlackHole alloc]init];
        [self.view addSubview:blackHoleTwo];
    }
    
    if (!self.blackHoleTwo.superview) {
        [self.view addSubview:self.blackHoleTwo];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.blackHoleTwo redrawRectWithBallFrame:self.ball.frame];
    } completion:^(BOOL finished) {
        if (finished) {
            self.isAnimatingBHTwo = NO;
        }
    }];
}

- (void)redraw {
    if (self.score.text.intValue <= 2) {
        [self.blackHole removeFromSuperview];
        [self.blackHoleTwo removeFromSuperview];
        return;
    }
    
    [self redrawOne];
    if (self.score.text.intValue > 8) {
        [self redrawTwo];
    } else {
        [self.blackHoleTwo removeFromSuperview];
    }
}

- (void)redrawBonusHole {
    
    if (!self.bonusHole) {
        self.bonusHole = [[BonusHole alloc]init];
    }
    
    if (fmod(self.score.text.intValue, 5) != 0) {
        if (self.bonusHole.superview) {
            [self.bonusHole removeFromSuperview];
        }
        return;
    }
    
    if (!self.bonusHole.superview) {
        [self.view addSubview:self.bonusHole];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.bonusHole redrawRectWithBallFrame:self.ball.frame];
    }];
}

- (void)addOneToScore {
    int newScore = self.score.text.intValue+1;
    NSString *newScoreString = [NSString stringWithFormat:@"%d",newScore];
    [self.score setText:newScoreString];
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:@"savedScore"];
    
    [self redrawBonusHole];
    
    if (self.difficulty.selectedSegmentIndex > 0) {
        if (newScore > 2) {
            
            [self redraw];
            
            if (!self.timer.isValid) {
                if (self.difficulty.selectedSegmentIndex == 1) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
                } else if (self.difficulty.selectedSegmentIndex == 2) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
                } else if (self.difficulty.selectedSegmentIndex == 3) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redraw) userInfo:nil repeats:YES];
                } else {
                    self.timer = nil;
                }
                
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

- (void)countFive {
    self.score.text = [NSString stringWithFormat:@"%d",self.score.text.intValue+5];
}

- (void)flashScoreLabelToGreen {
    [self.score setTextColor:[UIColor greenColor]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            sleep(0.5);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [self.score setTextColor:[UIColor whiteColor]];
                }
            });
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int diff = [[[NSUserDefaults standardUserDefaults]objectForKey:@"difficultyIndex"]intValue];
    int themey = [[[NSUserDefaults standardUserDefaults]objectForKey:@"themeIndex"]intValue];
    
    [self.difficulty setSelectedSegmentIndex:diff];
    [self.theme setSelectedSegmentIndex:themey];
    
    [self difficultyChanged];
    [self themeChanged];
    
    if ([networkTest isConnectedToInternet]) {
        [self submitOfflineScore];
        [self loginUser];
    }
}

@end
