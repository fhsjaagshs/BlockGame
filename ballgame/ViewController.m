//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize timer, isAnimating, blackHole, blackHoleTwo, bonusHole, bhTimerIsRunning, score, gameOverLabel, highscore;

- (void)randomizePosition {
    CGRect screenBounds = [[UIScreen mainScreen]applicationFrame];
    TargetView *target = nil;
    
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
    
    target.frame = CGRectMake(x, y, 26, 90);
    
    if (self.theme.selectedSegmentIndex == 0) {
        
        NSArray *images = [NSArray arrayWithObjects:@"", nil];
        int randomColorIndex = (arc4random()%images.count)-1;
        
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:randomColorIndex]];
        
        if (whichSide > 2) {
            [target redrawHorizontallyWithImage:image];
        } else {
            [target redrawVerticallyWithImage:image];
        }
    } else {
        [target redrawWithBackgroundColor:nil];
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
        if (leaderboardController != nil) {
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
    
    int diff = self.difficulty.selectedSegmentIndex;

    NSString *savedPref = [NSString stringWithFormat:@"%d",diff];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"difficultyIndex"];
    
    if (diff == 0)  {
        [self.difficultyLabel setText:@"Easy"];
        [self.blackHoleTwo removeFromSuperview];
        [self.blackHole removeFromSuperview];
    } else if (diff == 1) {
        [self.difficultyLabel setText:@"Medium"];
    } else if (diff == 2) {
        [self.difficultyLabel setText:@"Hard"];
    } else if (diff == 3) {
        [self.difficultyLabel setText:@"Insane"];
    }
}

- (void)hideImageViews:(BOOL)hide {
    [self.a setHidden:hide];
    [self.b setHidden:hide];
    [self.c setHidden:hide];
    [self.d setHidden:hide];
    [self.e setHidden:hide];
    [self.f setHidden:hide];
    [self.g setHidden:hide];
    [self.h setHidden:hide];
    [self.i setHidden:hide];
    [self.j setHidden:hide];
    [self.k setHidden:hide];
    [self.l setHidden:hide];
    [self.m setHidden:hide];
    [self.n setHidden:hide];
    [self.o setHidden:hide];
    [self.p setHidden:hide];
}

- (IBAction)themeChanged {
    int value = self.theme.selectedSegmentIndex;
    NSString *savedPref = [NSString stringWithFormat:@"%d",value];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"themeIndex"];
    
    NSArray *targets = [NSArray arrayWithObjects:self.one, self.two, self.three, self.four, self.five, self.six, self.seven, self.eight, self.nine, self.ten, self.eleven, self.twelve, self.thirteen, self.fourteen, self.fifteen, self.sixteen, nil];
    
    BOOL isSelectedIndexOne = (self.theme.selectedSegmentIndex == 1);
    UIColor *titleColor = isSelectedIndexOne?[UIColor blackColor]:[UIColor whiteColor];
    
    [self.showGameCenterButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.difficultyLabel setTextColor:titleColor];
    [self.startButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.score setTextColor:titleColor];
    [self.themeLabel setTextColor:titleColor];
    [self.pauseButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.ballImage setHidden:isSelectedIndexOne];
    [self.BGImageView setHidden:isSelectedIndexOne];
    [self hideImageViews:isSelectedIndexOne];
    
    if (self.theme.selectedSegmentIndex == 1) {
        for (UIView *view in targets) {
            [view setBackgroundColor:[UIColor cyanColor]];
            view.layer.cornerRadius = 5;
        }
    } else {
        for (UIView *view in targets) {
            [view setBackgroundColor:[UIColor clearColor]];
            view.layer.cornerRadius = 0;
        }
    }
}

- (void)hideEmAll {
    [self.one setHidden:YES];
    [self.two setHidden:YES];
    [self.three setHidden:YES];
    [self.four setHidden:YES];
    [self.five setHidden:YES];
    [self.six setHidden:YES];
    [self.seven setHidden:YES];
    [self.eight setHidden:YES];
    [self.nine setHidden:YES];
    [self.ten setHidden:YES];
    [self.eleven setHidden:YES];
    [self.twelve setHidden:YES];
    [self.thirteen setHidden:YES];
    [self.fourteen setHidden:YES];
    [self.fifteen setHidden:YES];
    [self.sixteen setHidden:YES];
}

- (void)gameOver {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gameOver"];
    
    int64_t gameOverScore = [self.score.text intValue];
    [self submitScore:gameOverScore];

    NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    if ([networkTest isConnectedToInternet]) {
        int64_t personalBest = [self.highscore intValue];
        
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
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    [self.startButton setHidden:NO];
    [self.gameOverLabel setHidden:NO];
    [self.showGameCenterButton setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.startButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)randomUnhide {
    int randomNumber = arc4random()%16;
    
    NSArray *targets = [NSArray arrayWithObjects:self.one, self.two, self.three, self.four, self.five, self.six, self.seven, self.eight, self.nine, self.ten, self.eleven, self.twelve, self.thirteen, self.fourteen, self.fifteen, self.sixteen, nil];
    
    [[targets objectAtIndex:randomNumber]setHidden:NO];
    
    if (self.theme.selectedSegmentIndex == 1) {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [[targets objectAtIndex:randomNumber] setBackgroundColor:[colors objectAtIndex:arc4random()%(8)]];
        colors = nil;
    }

    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",randomNumber] forKey:@"randomNumber"];
}

- (IBAction)togglePause {
    if ([UIAccelerometer sharedAccelerometer].delegate == self) {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [self.theme setHidden:NO];
        [self.themeLabel setHidden:NO];
        [self.timer invalidate];
        self.timer = nil;
        self.bhTimerIsRunning = NO;
    } else {
        [UIAccelerometer sharedAccelerometer].delegate = self;
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.themeLabel setHidden:YES];
        [self.theme setHidden:YES];
        
        if (!self.bhTimerIsRunning) {

            if (self.difficulty.selectedSegmentIndex == 1) {
                timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (self.difficulty.selectedSegmentIndex == 2) {
                timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (self.difficulty.selectedSegmentIndex == 3) {
                timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else {
                timer = nil;
            }
            
            [self.timer fire];
            self.bhTimerIsRunning = YES;
            
            if (self.blackHole) {
                [self.blackHole redrawRectWithNewFrame:blackHole.frame andBallFrame:self.ball.frame];
            }
            
            if (self.blackHoleTwo != nil) {
                [self.blackHoleTwo redrawRectWithNewFrame:blackHoleTwo.frame andBallFrame:self.ball.frame];
            }
            
            if (self.bonusHole != nil) {
                [self.bonusHole redrawRectWithNewFrame:bonusHole.frame andBallFrame:self.ball.frame];
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
    [score setHidden:NO];
    
    // where the bonus and black holes get hidden...
    [self.blackHole removeFromSuperview];
    [self.blackHoleTwo removeFromSuperview];
    [self.bonusHole removeFromSuperview];
    self.blackHoleTwo = nil;
    self.blackHole = nil;
    self.bonusHole = nil;
    
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
    [UIAccelerometer sharedAccelerometer].delegate = self;
    
    // Stuff that should happen to restart the game
    if (!gameOverLabel.isHidden) { // if the gameover label is showing
        [self.score setText:@"0"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];
        [self.ball setCenter:self.theMainView.center];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self hideEmAll];
        self.bonusHole = nil;
        self.blackHole = nil;
        self.blackHoleTwo = nil;
    } 

    [self randomUnhide];
    [self.gameOverLabel setHidden:YES];
    [self.startButton setHidden:YES];
    [self.pauseButton setHidden:NO];
    self.bhTimerIsRunning = NO;
    
    [self submitOfflineScore];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isAnimating = NO;
    self.bhTimerIsRunning = NO;
    
    [self loginUser];
    
    [UIAccelerometer sharedAccelerometer].updateInterval = 1/180;
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    
    NSArray *targets = [NSArray arrayWithObjects:self.one, self.two, self.three, self.four, self.five, self.six, self.seven, self.eight, self.nine, self.ten, self.eleven, self.twelve, self.thirteen, self.fourteen, self.fifteen, self.sixteen, nil];
    
    for (UIView *view in targets) {
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.9f;
        view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        view.layer.shadowRadius = 5.0f;
        view.layer.masksToBounds = NO;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -2, view.frame.size.width+2, view.frame.size.height+2)];
        view.layer.shadowPath = path.CGPath;
    }

    self.a.transform = CGAffineTransformRotate(self.a.transform, 270/180*M_PI);
    self.b.transform = CGAffineTransformRotate(self.b.transform, 270/180*M_PI);
    self.c.transform = CGAffineTransformRotate(self.c.transform, 270/180*M_PI);
    self.d.transform = CGAffineTransformRotate(self.d.transform, 270/180*M_PI);
    self.e.transform = CGAffineTransformRotate(self.e.transform, 270/180*M_PI);
    self.f.transform = CGAffineTransformRotate(self.f.transform, 270/180*M_PI);
    self.g.transform = CGAffineTransformRotate(self.g.transform, 270/180*M_PI);
    self.h.transform = CGAffineTransformRotate(self.h.transform, 270/180*M_PI);
    self.i.transform = CGAffineTransformRotate(self.i.transform, 270/180*M_PI);
    self.j.transform = CGAffineTransformRotate(self.j.transform, 270/180*M_PI);
    
    
    self.ball.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ball.layer.shadowOpacity = 0.7f;
    self.ball.layer.shadowOffset = CGSizeZero;
    self.ball.layer.shadowRadius = 5.0f;
    self.ball.layer.masksToBounds = NO;
    self.ball.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)].CGPath;
}

- (void)setBoolToNo {
    self.isAnimating = NO;
}

- (void)animationDidStopMe {
    [self performSelector:@selector(setBoolToNo) withObject:nil afterDelay:1.0f];
}

- (void)redraw {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    CGRect frame = CGRectMake(x, y, 33, 33);
    CGRect adjustedFrame = CGRectMake(x-50, y-50, 133, 133);
    
    if (((CGRectIntersectsRect(adjustedFrame, self.ball.frame)) || (CGRectContainsRect(adjustedFrame, self.ball.frame))) || ((CGRectIntersectsRect(adjustedFrame, self.ball.frame)) && (CGRectContainsRect(adjustedFrame, self.ball.frame)))) {
        NSLog(@"Too close one");
        frame = CGRectMake(x-100, y-100, 33, 33);
    }
    
    self.isAnimating = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopMe)];
    [self.blackHole setFrame:frame];
    [UIView commitAnimations];
}

- (void)redrawTwo {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    CGRect frame = CGRectMake(x, y, 33, 33);
    CGRect adjustedFrame = CGRectMake(x-50, y-50, 133, 133);
    
    if (((CGRectIntersectsRect(adjustedFrame, self.ball.frame)) || (CGRectContainsRect(adjustedFrame, self.ball.frame))) || ((CGRectIntersectsRect(adjustedFrame, self.ball.frame)) && (CGRectContainsRect(adjustedFrame, self.ball.frame)))) {
        NSLog(@"Too close two");
        frame = CGRectMake(x-100, y-100, 33, 33);
    }
    
    self.isAnimating = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopMe)];
    [self.blackHoleTwo setFrame:frame];
    [UIView commitAnimations];
}

- (void)redrawBoth {
    [self redraw];
    NSString *prevScoreString = self.score.text;
    int scoresdf = [prevScoreString intValue];
    if (scoresdf > 8) {
        [self redrawTwo];
    }
}

- (void)redrawBonusHole {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    CGRect frame = CGRectMake(x, y, 33, 33);

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self.bonusHole setFrame:frame];
    [UIView commitAnimations];
}

- (void)addOneToScore {
    NSString *prevScoreString = self.score.text;
    int previousScore = [prevScoreString intValue];
    int newScore = previousScore+1;
    NSString *newScoreString = [NSString stringWithFormat:@"%d",newScore];
    [score setText:newScoreString];
    
    // Bonus hole behavior
    float rounded = [[NSString stringWithFormat:@"%.0f",(float)(newScore/21)]floatValue];
    float diff = (newScore/21)-rounded;

    if ((diff != 0) && ((diff*21) == newScore)) {
        if (!self.bonusHole) {
            self.bonusHole = [[BonusHole alloc]initWithBallframe:self.ball.frame];
            [self.view addSubview:self.bonusHole];
            [self.view bringSubviewToFront:self.bonusHole];
        } else {
            [self redrawBonusHole];
        }
    } else {
        [self.bonusHole removeFromSuperview];
        self.bonusHole = nil;
    }
    
    if (self.difficulty.selectedSegmentIndex != 0) {
    
        if (newScore > 2) {
            if (self.blackHole == nil) {
                self.blackHole = [[BlackHole alloc]initWithBallframe:self.ball.frame];
                [self.view addSubview:self.blackHole];
                [self.view bringSubviewToFront:self.blackHole];
                if (!bhTimerIsRunning) {
                    int difficultyIndex = self.difficulty.selectedSegmentIndex;
                    
                    if (difficultyIndex == 1) {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else if (difficultyIndex == 2) {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else if (difficultyIndex == 3) {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else {
                        self.timer = nil;
                    }
                    
                    [self.timer fire];
                    self.bhTimerIsRunning = YES;
                }
            } else {
                [self redraw];
            }
        
        } else {
            if (self.blackHole != nil) {
                [self.blackHole removeFromSuperview];
                self.blackHole = nil;
            }
            [self.timer invalidate];
            self.timer = nil;
        }
    
        if (newScore > 8) {
            if (self.blackHoleTwo == nil) {
                self.blackHoleTwo = [[BlackHole alloc]initWithBallframe:self.ball.frame];
                [self.view addSubview:self.blackHoleTwo];
                [self.view bringSubviewToFront:self.blackHoleTwo];
            } else {
                [self redrawTwo];
            }
        
        } else {
            if (self.blackHoleTwo != nil) {
                [self.blackHoleTwo removeFromSuperview];
                self.blackHoleTwo = nil;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:@"savedScore"];
}

- (void)countFive {
    int newScore = self.score.text.intValue+5;
    self.score.text = [NSString stringWithFormat:@"%d",newScore];
}

//
// DAFUQ????
//

- (void)flashScoreLabelToGreen {
    [self.score setTextColor:[UIColor greenColor]];
    sleep(0.5);
    [self.score setTextColor:[UIColor whiteColor]];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // maybe use an if statement to get stuff for the set Tilt
    
    UIAccelerationValue x, y;
    x = acceleration.x;
    y = acceleration.y;
    
    // to get the speed, get absolute value and multiply the acceleration by a constant (in this time, its a time)
    
    double xValNonAbs = x;
    double yValNonAbs = y;
    
    double xVal = fabs(xValNonAbs);
    double yVal = fabs(yValNonAbs);
    
    CGRect screenBounds = CGRectMake(0, 0, 320, 480);
    CGRect ballRect = self.ball.frame;
    
    int speed = 7;
    
    if (self.difficulty.selectedSegmentIndex == 0) {
        // easy
        speed = 5;
    } else if (self.difficulty.selectedSegmentIndex == 1) {
        //medium
        speed = 7;
    } else if (self.difficulty.selectedSegmentIndex == 2) {
        // hard
        speed = 11;
    } else if (self.difficulty.selectedSegmentIndex == 3) {
        // insane
        speed = 20;
    } else {
        speed = 7;
    }
    
    int rateX = 10*x; // for diagonal movement change to a double and remove the *10
    int rateY = -1*10*y; // for diagonal movement change to a double and remove the *10
    float currentX = self.ball.center.x;
    float currentY = self.ball.center.y;
    
    CGPoint newCenterPoint = CGPointZero;
    
    if (rateX > 0 && rateY == 0) {
        //positive x movement
        newCenterPoint = CGPointMake(currentX+(xVal*speed), self.ball.center.y);
    } else if (rateX == 0 && rateY > 0) {
        //positive y movement
        newCenterPoint = CGPointMake(self.ball.center.x, currentY+(yVal*speed));
    } else if (rateX > 0 && rateY > 0) {
        // positive x and y movement
        newCenterPoint = CGPointMake(currentX+(xVal*speed), currentY+(yVal*speed));
    } else if (rateX < 0 && rateY == 0) {
        // negative x movement
        newCenterPoint = CGPointMake(currentX-(xVal*speed), self.ball.center.y);
    } else if (rateX == 0 && rateY < 0) {
        // negative y movement
        newCenterPoint = CGPointMake(self.ball.center.x, currentY-(yVal*speed));
    } else if (rateX > 0 && rateY < 0) {
        // positive x movement and negative y movement
        newCenterPoint = CGPointMake(currentX+(xVal*speed), currentY-(yVal*speed));
    } else if (rateX < 0 && rateY > 0) {
        // opposite of above
        newCenterPoint = CGPointMake(currentX-(xVal*speed), currentY+(yVal*speed));
    } else if (rateX < 0 && rateY < 0) {
        // negative x and y movement
        newCenterPoint = CGPointMake(currentX-(xVal*speed), currentY-(yVal*speed));
    }
    
    if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
        self.ball.center = newCenterPoint;
    } else {
        [self gameOver];
    }
    
    NSArray *targets = [NSArray arrayWithObjects:self.one, self.two, self.three, self.four, self.five, self.six, self.seven, self.eight, self.nine, self.ten, self.eleven, self.twelve, self.thirteen, self.fourteen, self.fifteen, self.sixteen, nil];
    
    // Now determine where the ball is
    int theRandomNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:@"randomNumber"]intValue];

    CGRect targetViewBounds = [[targets objectAtIndex:theRandomNumber]frame];
    
    if (CGRectIntersectsRect(ballRect, targetViewBounds)) {
        [self hideEmAll];
        [self randomUnhide];
        [self addOneToScore];
    } 

    if ((CGRectIntersectsRect(ballRect, self.blackHole.frame) || CGRectIntersectsRect(ballRect, self.blackHoleTwo.frame)) && self.isAnimating == NO) {
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(ballRect, self.bonusHole.frame)) {
        [self countFive];
        [self.bonusHole removeFromSuperview];
        self.bonusHole = nil;
    }
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
