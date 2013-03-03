//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "NSCustomAlertView.h"
#import "networkTest.h"
#include <netinet/in.h>
#import <CFNetwork/CFNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation ViewController

@synthesize targets, timer, isAnimating, blackHole, blackHoleTwo, bonusHole, bhTimerIsRunning, score, gameOverLabel, highscore;

- (void)setStartButtonTitle:(NSString *)string {
    [startButton setTitle:string forState:UIControlStateNormal];
    
    if (string == @"Resume") {
        [score setHidden:NO];
        [difficulty setHidden:YES];
        [difficultyLabel setHidden:NO];
    }
}

- (void)submitOfflineScore {
    
    BOOL connectedToANetwork = [networkTest connectedToNetwork];
    
    BOOL isThere = ([[NSUserDefaults standardUserDefaults]objectForKey:@"scoretosubmit"] != nil);
    
    if (connectedToANetwork && isThere) {
        int64_t ff = (int64_t)[[[NSUserDefaults standardUserDefaults]objectForKey:@"scoretosubmit"]intValue];
        
        if (difficulty.selectedSegmentIndex == 0) {
            /// easy
            [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockgamehs"];
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgamehs"];
        } else if (difficulty.selectedSegmentIndex == 1) {
            //medium
            [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockgameMedium"];
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgameMedium"];
        } else if (difficulty.selectedSegmentIndex == 2) {
            // hard
            [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockGameHard"];
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameHard"];
        } else if (difficulty.selectedSegmentIndex == 3) {
            // insane
            [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockGameInsane"];
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameInsane"];
        }
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"scoretosubmit"];
    }
}

- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error {
	if (error == nil) {
		int64_t personalBest = leaderBoard.localPlayerScore.value;
		self.highscore = [NSString stringWithFormat:@"%lld",personalBest];
    } else {
        highscore = @"-1";
	}
}

- (int64_t)submitScore {
    
    int64_t ff = [self.score.text intValue];
    if (difficulty.selectedSegmentIndex == 0) {
        /// easy
        [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockgamehs"];
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgamehs"];
    } else if (difficulty.selectedSegmentIndex == 1) {
        //medium
        [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockgameMedium"];
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgameMedium"];
    } else if (difficulty.selectedSegmentIndex == 2) {
        // hard
        [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockGameHard"];
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameHard"];
    } else if (difficulty.selectedSegmentIndex == 3) {
        // insane
        [gameCenterManager reportScore:ff forCategory:@"com.fhsjaagshs.blockGameInsane"];
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameInsane"];
    }
    return ff;
}

- (void)processGameCenterAuth:(NSError *)error {
	if(error == nil) {
        if (difficulty.selectedSegmentIndex == 0) {
            /// easy
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgamehs"];
        } else if (difficulty.selectedSegmentIndex == 1) {
            //medium
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgameMedium"];
        } else if (difficulty.selectedSegmentIndex == 2) {
            // hard
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameHard"];
        } else if (difficulty.selectedSegmentIndex == 3) {
            // insane
            [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameInsane"];
        }
	}
}

- (IBAction)showLeaderboard:(id)sender {
    if ([networkTest connectedToNetwork]) {
        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc]init];
        if (leaderboardController != nil) {
            if (difficulty.selectedSegmentIndex == 0) {
                /// easy
                [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgamehs"];
                leaderboardController.category = @"com.fhsjaagshs.blockgamehs";
            } else if (difficulty.selectedSegmentIndex == 1) {
                //medium
                [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgameMedium"];
                leaderboardController.category = @"com.fhsjaagshs.blockgameMedium";
            } else if (difficulty.selectedSegmentIndex == 2) {
                // hard
                [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameHard"];
                leaderboardController.category = @"com.fhsjaagshs.blockGameHard";
            } else if (difficulty.selectedSegmentIndex == 3) {
                // insane
                [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameInsane"];
                leaderboardController.category = @"com.fhsjaagshs.blockGameInsane";
            }
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
            [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            [self presentModalViewController:leaderboardController animated:YES];
        }
    } else {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"GameCenter Unavailable" message:@"Connect to 3G or WiFi to view leaderboards" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[gameCenterManager authenticateLocalUser];
}

- (void)scoreReported:(NSError *)error {
    if (difficulty.selectedSegmentIndex == 0) {
        /// easy
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgamehs"];
    } else if (difficulty.selectedSegmentIndex == 1) {
        //medium
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockgameMedium"];
    } else if (difficulty.selectedSegmentIndex == 2) {
        // hard
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameHard"];
    } else if (difficulty.selectedSegmentIndex == 3) {
        // insane
        [gameCenterManager reloadHighScoresForCategory:@"com.fhsjaagshs.blockGameInsane"];
    }
}

- (IBAction)difficultyChanged:(id)sender {
    
    NSString *leaderboard;
    if (difficulty.selectedSegmentIndex == 0) {
        leaderboard = @"com.fhsjaagshs.blockgamehs";
    } else if (difficulty.selectedSegmentIndex == 1) {
        leaderboard = @"com.fhsjaagshs.blockgameMedium";
    } else if (difficulty.selectedSegmentIndex == 2) {
        leaderboard = @"com.fhsjaagshs.blockGameHard";
    } else if (difficulty.selectedSegmentIndex == 3) {
        leaderboard = @"com.fhsjaagshs.blockGameInsane";
    }
    
    [gameCenterManager reloadHighScoresForCategory:leaderboard];
    
    int diff = difficulty.selectedSegmentIndex;

    NSString *savedPref = [NSString stringWithFormat:@"%d",diff];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"difficultyIndex"];
    
    if (diff == 0)  {
        [difficultyLabel setText:@"Easy"];
        [blackHoleTwo removeFromSuperview];
        [blackHole removeFromSuperview];
    } else if (diff == 1) {
        [difficultyLabel setText:@"Medium"];
    } else if (diff == 2) {
        [difficultyLabel setText:@"Hard"];
    } else if (diff == 3) {
        [difficultyLabel setText:@"Insane"];
    }
}

- (void)hideImageViews:(BOOL)hide {
    [a setHidden:hide];
    [b setHidden:hide];
    [c setHidden:hide];
    [d setHidden:hide];
    [e setHidden:hide];
    [f setHidden:hide];
    [g setHidden:hide];
    [h setHidden:hide];
    [i setHidden:hide];
    [j setHidden:hide];
    [k setHidden:hide];
    [l setHidden:hide];
    [m setHidden:hide];
    [n setHidden:hide];
    [o setHidden:hide];
    [p setHidden:hide];
}

- (IBAction)themeChanged:(id)sender {
    int value = theme.selectedSegmentIndex;
    NSString *savedPref = [NSString stringWithFormat:@"%d",value];
    
    [[NSUserDefaults standardUserDefaults]setObject:savedPref forKey:@"themeIndex"];
    
    if (targets == nil) {
        targets = [[NSArray alloc]initWithObjects:one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, nil];
    }
    
    if (theme.selectedSegmentIndex == 1) {
        [showGameCenterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [difficultyLabel setTextColor:[UIColor blackColor]];
        [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.score setTextColor:[UIColor blackColor]];
        [themeLabel setTextColor:[UIColor blackColor]];
        [pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ballImage setHidden:YES];
        [BGImageView setHidden:YES];
        [self hideImageViews:YES];
        
        for (UIView *view in targets) {
            [view setBackgroundColor:[UIColor cyanColor]];
            view.layer.cornerRadius = 5;
        }
    
    } else {
        [showGameCenterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [difficultyLabel setTextColor:[UIColor whiteColor]];
        [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.score setTextColor:[UIColor whiteColor]];
        [themeLabel setTextColor:[UIColor whiteColor]];
        [pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ballImage setHidden:NO];
        [BGImageView setHidden:NO];
        [self hideImageViews:NO];
        
        for (UIView *view in targets) {
            [view setBackgroundColor:[UIColor clearColor]];
            view.layer.cornerRadius = 0;
        }
    }
}

- (void)hideEmAll {
    [one setHidden:YES];
    [two setHidden:YES];
    [three setHidden:YES];
    [four setHidden:YES];
    [five setHidden:YES];
    [six setHidden:YES];
    [seven setHidden:YES];
    [eight setHidden:YES];
    [nine setHidden:YES];
    [ten setHidden:YES];
    [eleven setHidden:YES];
    [twelve setHidden:YES];
    [thirteen setHidden:YES];
    [fourteen setHidden:YES];
    [fifteen setHidden:YES];
    [sixteen setHidden:YES];
}

- (void)gameOver {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gameOver"];
    
    int64_t gameOverScore = [self submitScore];
    
    BOOL connectedToTheNetwork = [networkTest connectedToNetwork];
    
    if (connectedToTheNetwork) {
        int64_t personalBest = [highscore intValue];
        NSLog(@"HighScore when game ended: %lld",personalBest);
        
        [self submitOfflineScore];
        
        if (gameOverScore > personalBest && personalBest != -1) {
            NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
            NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:@"Congrats, you beat your high score!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        } else if (gameOverScore < personalBest && personalBest != -1) {
            NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
            NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:@"You did not beat your high score :(" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        } else {
            NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
            NSString *message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
            NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    } else {
        
        NSString *title = [NSString stringWithFormat:@"You scored %lli!",gameOverScore];
        NSString *message = [NSString stringWithFormat:@"%lli is good, but you can do better :D",gameOverScore];
        NSCustomAlertView *alert = [[NSCustomAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        NSString *saveString = [NSString stringWithFormat:@"%lli",gameOverScore];
        [[NSUserDefaults standardUserDefaults]setObject:saveString forKey:@"scoretosubmit"];
    }
    
    [themeLabel setHidden:NO];
    [difficulty setHidden:NO];
    [theme setHidden:NO];
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    [startButton setHidden:NO];
    [gameOverLabel setHidden:NO];
    [showGameCenterButton setHidden:NO];
    [pauseButton setHidden:YES];
    [startButton setTitle:@"Retry" forState:UIControlStateNormal];
    [timer invalidate];
    timer = nil;
}

- (void)randomUnhide {
    int randomNumber = arc4random() % (16);
    
    if (targets == nil) {
        targets = [[NSArray alloc]initWithObjects:one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, nil];
    }
    
    [[targets objectAtIndex:randomNumber]setHidden:NO];
    
    if (theme.selectedSegmentIndex == 1) {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [[targets objectAtIndex:randomNumber] setBackgroundColor:[colors objectAtIndex:arc4random() % (8)]];
        colors = nil;
    }
    
    NSString *randomNumberString = [NSString stringWithFormat:@"%d",randomNumber];
    [[NSUserDefaults standardUserDefaults]setObject:randomNumberString forKey:@"randomNumber"];
}

- (IBAction)togglePause:(id)sender {
    if ([UIAccelerometer sharedAccelerometer].delegate == self) {
        [UIAccelerometer sharedAccelerometer].delegate = nil;
        [pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [theme setHidden:NO];
        [themeLabel setHidden:NO];
        [timer invalidate];
        timer = nil;
        bhTimerIsRunning = NO;
    } else {
        [UIAccelerometer sharedAccelerometer].delegate = self;
        [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [themeLabel setHidden:YES];
        [theme setHidden:YES];
        if (!bhTimerIsRunning) {
            
            // get the rects of the black holes and the bonus block
            CGRect bhOneRect = blackHole.frame;
            CGRect bhTwoRect = blackHoleTwo.frame;
            CGRect bonusHoleRect = bonusHole.frame;
            
            int difficultyIndex = difficulty.selectedSegmentIndex;
            
            if (difficultyIndex == 0) {
                timer = nil;
            } else if (difficultyIndex == 1) {
                timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (difficultyIndex == 2) {
                timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else if (difficultyIndex == 3) {
                timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
            } else {
                timer = nil;
            }
            
            [timer fire];
            bhTimerIsRunning = YES;
            
            if (blackHole != nil) {
                [blackHole redrawRectWithNewFrame:bhOneRect andBallFrame:ball.frame];
            }
            
            if (blackHoleTwo != nil) {
                [blackHoleTwo redrawRectWithNewFrame:bhTwoRect andBallFrame:ball.frame];
            }
            
            if (bonusHole != nil) {
                [bonusHole redrawRectWithNewFrame:bonusHoleRect andBallFrame:ball.frame];
            }
        }
    }
}

- (IBAction)startOrRetry:(id)sender {
    // Set the gameOver boolean, used for restoring to the previous state after a terminate
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gameOver"];
    
    NSString *leaderboard;
    if (difficulty.selectedSegmentIndex == 0) {
        leaderboard = @"com.fhsjaagshs.blockgamehs";
    } else if (difficulty.selectedSegmentIndex == 1) {
        leaderboard = @"com.fhsjaagshs.blockgameMedium";
    } else if (difficulty.selectedSegmentIndex == 2) {
        leaderboard = @"com.fhsjaagshs.blockGameHard";
    } else if (difficulty.selectedSegmentIndex == 3) {
        leaderboard = @"com.fhsjaagshs.blockGameInsane";
    }
    
    [gameCenterManager reloadHighScoresForCategory:leaderboard];

    
    [difficultyLabel setHidden:NO];
    [ball setHidden:NO];
    [score setHidden:NO];
    
    // where the bonus and black holes get hidden...
    [blackHole removeFromSuperview];
    [blackHoleTwo removeFromSuperview];
    [bonusHole removeFromSuperview];
    blackHoleTwo = nil;
    blackHole = nil;
    bonusHole = nil;
    
    
    // reset titles
    if (startButton.titleLabel.text == @"Start") {
        startButton.titleLabel.text = @"Retry";
    }
    
    // hide controls
    [difficulty setHidden:YES];
    [theme setHidden:YES];
    [themeLabel setHidden:YES];
    [showGameCenterButton setHidden:YES];
    
    // make the ball respond to the accelerotemer
    [UIAccelerometer sharedAccelerometer].delegate = self;
    
    // Stuff that should happen to restart the game
    if (![gameOverLabel isHidden]) { // if the gameover label is showing
        [self.score setText:@"0"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];
        [ball setCenter:theMainView.center];
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self hideEmAll];
        bonusHole = nil;
        blackHole = nil;
        blackHoleTwo = nil;
    } 

    [self randomUnhide];
    [gameOverLabel setHidden:YES];
    [startButton setHidden:YES];
    [pauseButton setHidden:NO];
    bhTimerIsRunning = NO;
    
    [self submitOfflineScore];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isAnimating = NO;
    bhTimerIsRunning = NO;
    
    gameCenterManager= [[GameCenterManager alloc]init];
    [gameCenterManager setDelegate:self];
    [gameCenterManager authenticateLocalUser];
    
    NSString *leaderboard;
    if (difficulty.selectedSegmentIndex == 0) {
        leaderboard = @"com.fhsjaagshs.blockgamehs";
    } else if (difficulty.selectedSegmentIndex == 1) {
        leaderboard = @"com.fhsjaagshs.blockgameMedium";
    } else if (difficulty.selectedSegmentIndex == 2) {
        leaderboard = @"com.fhsjaagshs.blockGameHard";
    } else if (difficulty.selectedSegmentIndex == 3) {
        leaderboard = @"com.fhsjaagshs.blockGameInsane";
    }
    
    [gameCenterManager reloadHighScoresForCategory:leaderboard];
    
    [UIAccelerometer sharedAccelerometer].updateInterval = 1 / 180.0; // original speed: 1/30 
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    
    if (targets == nil) {
        targets = [[NSArray alloc]initWithObjects:one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, nil];
    }
    
    for (UIView *view in targets) {
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.9f;
        view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        view.layer.shadowRadius = 5.0f;
        view.layer.masksToBounds = NO;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -2, view.frame.size.width+2, view.frame.size.height+2)];
        view.layer.shadowPath = path.CGPath;
    }

    a.transform = CGAffineTransformRotate(a.transform, 270.0/180*M_PI);
    b.transform = CGAffineTransformRotate(b.transform, 270.0/180*M_PI);
    c.transform = CGAffineTransformRotate(c.transform, 270.0/180*M_PI);
    d.transform = CGAffineTransformRotate(d.transform, 270.0/180*M_PI);
    e.transform = CGAffineTransformRotate(e.transform, 270.0/180*M_PI);
    f.transform = CGAffineTransformRotate(f.transform, 270.0/180*M_PI);
    g.transform = CGAffineTransformRotate(g.transform, 270.0/180*M_PI);
    h.transform = CGAffineTransformRotate(h.transform, 270.0/180*M_PI);
    i.transform = CGAffineTransformRotate(i.transform, 270.0/180*M_PI);
    j.transform = CGAffineTransformRotate(j.transform, 270.0/180*M_PI);
    
    
    ball.layer.shadowColor = [UIColor blackColor].CGColor;
    ball.layer.shadowOpacity = 0.7f;
    ball.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    ball.layer.shadowRadius = 5.0f;
    ball.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)];
    ball.layer.shadowPath = path.CGPath;
}

- (void)setBoolToNo {
    isAnimating = NO;
}

- (void)animationDidStopMe {
    NSLog(@"Animation did Stop");
    [self performSelector:@selector(setBoolToNo) withObject:nil afterDelay:1.0f];
}

- (void)redraw {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    CGRect frame = CGRectMake(x, y, 33, 33);
    
    CGRect adjustedFrame = CGRectMake(x-50, y-50, 133, 133);
    
    BOOL tooClose = ((CGRectIntersectsRect(adjustedFrame, ball.frame)) || (CGRectContainsRect(adjustedFrame, ball.frame))) || ((CGRectIntersectsRect(adjustedFrame, ball.frame)) && (CGRectContainsRect(adjustedFrame, ball.frame)));
    
    if (tooClose) {
        NSLog(@"Too close one");
        frame = CGRectMake(x-100, y-100, 33, 33);
    }
    
    isAnimating = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopMe)];
    [blackHole setFrame:frame];
    [UIView commitAnimations];
}

- (void)redrawTwo {
    int x = (arc4random()%264)+26;
    int y = (arc4random()%424)+26;
    CGRect frame = CGRectMake(x, y, 33, 33);
    
    CGRect adjustedFrame = CGRectMake(x-50, y-50, 133, 133);
    
    BOOL tooClose = ((CGRectIntersectsRect(adjustedFrame, ball.frame)) || (CGRectContainsRect(adjustedFrame, ball.frame))) || ((CGRectIntersectsRect(adjustedFrame, ball.frame)) && (CGRectContainsRect(adjustedFrame, ball.frame)));
    
    if (tooClose) {
        NSLog(@"Too close two");
        frame = CGRectMake(x-100, y-100, 33, 33);
    }
    
    isAnimating = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopMe)];
    [blackHoleTwo setFrame:frame];
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
    [bonusHole setFrame:frame];
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
    
    BOOL works = (diff != 0) && ((diff*21) == newScore);
    
    if (works) {
        if (bonusHole == nil) {
            bonusHole = [[BonusHole alloc]initWithBallframe:ball.frame];
            [self.view addSubview:bonusHole];
            [self.view bringSubviewToFront:bonusHole];
        } else {
            [self redrawBonusHole];
        }
    } else {
        [bonusHole removeFromSuperview];
        bonusHole = nil;
    }
    
    if (difficulty.selectedSegmentIndex != 0) {
    
        if (newScore > 2) {
            if (blackHole == nil) {
                blackHole = [[BlackHole alloc]initWithBallframe:ball.frame];
                [self.view addSubview:blackHole];
                [self.view bringSubviewToFront:blackHole];
                if (!bhTimerIsRunning) {
                    int difficultyIndex = difficulty.selectedSegmentIndex;
                    
                    if (difficultyIndex == 0) {
                        timer = nil;
                    } else if (difficultyIndex == 1) {
                        timer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else if (difficultyIndex == 2) {
                        timer = [NSTimer scheduledTimerWithTimeInterval:2.75f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else if (difficultyIndex == 3) {
                        timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawBoth) userInfo:nil repeats:YES];
                    } else {
                        timer = nil;
                    }
                    
                    [timer fire];
                    bhTimerIsRunning = YES;
                }
            } else {
                [self redraw];
            }
        
        } else {
            if (blackHole != nil) {
                [blackHole removeFromSuperview];
                blackHole = nil;
            }
            [timer invalidate];
            timer = nil;
        }
    
        if (newScore > 8) {
            if (blackHoleTwo == nil) {
                blackHoleTwo = [[BlackHole alloc]initWithBallframe:ball.frame];
                [self.view addSubview:blackHoleTwo];
                [self.view bringSubviewToFront:blackHoleTwo];
            } else {
                [self redrawTwo];
            }
        
        } else {
            if (blackHoleTwo != nil) {
                [blackHoleTwo removeFromSuperview];
                blackHoleTwo = nil;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:@"savedScore"];
}

- (void)countFive {
    NSString *prevScoreString = self.score.text;
    int previousScore = [prevScoreString intValue];
    int newScore = previousScore+5;
    NSString *newScoreString = [NSString stringWithFormat:@"%d",newScore];
    [score setText:newScoreString];
}

- (void)flashScoreLabelToGreen {
    [score setTextColor:[UIColor greenColor]];
    sleep(0.5);
    [score setTextColor:[UIColor whiteColor]];
}

- (void)setBallNewCenter:(CGPoint)point {
    [ball setCenter:point];
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
    CGRect ballRect = ball.frame;
    
    int speed = 7;
    
    if (difficulty.selectedSegmentIndex == 0) { 
        // easy
        speed = 5;
    } else if (difficulty.selectedSegmentIndex == 1) {
        //medium
        speed = 7;
    } else if (difficulty.selectedSegmentIndex == 2) {
        // hard
        speed = 11;
    } else if (difficulty.selectedSegmentIndex == 3) {
        // insane
        speed = 20;
    } else {
        speed = 7;
    }
    
    int rateX = 10*x; // for diagonal movement change to a double and remove the *10
    int rateY = -1*10*y; // for diagonal movement change to a double and remove the *10
    float currentX = ball.center.x;
    float currentY = ball.center.y;
    
    if (rateX > 0 && rateY == 0) {
        //positive x movement
        float newX = currentX+(xVal*speed);
        CGPoint newCenterPoint = CGPointMake(newX, ball.center.y);
        
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX == 0 && rateY > 0) {
        //positive y movement
        float newY = currentY+(yVal*speed);
        
        CGPoint newCenterPoint = CGPointMake(ball.center.x, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX > 0 && rateY > 0) {
        // positive x and y movement
        float newX = currentX+(xVal*speed);
        float newY = currentY+(yVal*speed);
        
        CGPoint newCenterPoint = CGPointMake(newX, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX < 0 && rateY == 0) {
        //negative x movement
        float newX = currentX-(xVal*speed);
        CGPoint newCenterPoint = CGPointMake(newX, ball.center.y);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX == 0 && rateY < 0) {
        //negative y movement
        float newY = currentY-(yVal*speed);
        CGPoint newCenterPoint = CGPointMake(ball.center.x, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX > 0 && rateY < 0) {
        //positive x movement and negative y movement
        float newX = currentX+(xVal*speed);
        float newY = currentY-(yVal*speed);
        
        CGPoint newCenterPoint = CGPointMake(newX, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX < 0 && rateY > 0) {
        // opposite of above
        float newX = currentX-(xVal*speed);
        float newY = currentY+(yVal*speed);
        CGPoint newCenterPoint = CGPointMake(newX, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    } else if (rateX < 0 && rateY < 0) {
        // negative x and y movement
        float newX = currentX-(xVal*speed);
        float newY = currentY-(yVal*speed);
        CGPoint newCenterPoint = CGPointMake(newX, newY);
        if (CGRectContainsPoint(screenBounds, newCenterPoint)) {
            [self setBallNewCenter:newCenterPoint];
        } else {
            [self gameOver];
        }
    }
    
    if (targets == nil) {
        targets = [[NSArray alloc]initWithObjects:one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, nil];
    }
    
    // Now determine where the ball is
    int theRandomNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:@"randomNumber"]intValue];
    
    UIView *theView = [targets objectAtIndex:theRandomNumber];
    
    CGRect targetViewBounds = theView.frame;
    
    theView = nil;
    
    BOOL worksFool = CGRectIntersectsRect(ballRect, targetViewBounds);
    
    if (worksFool) {
        [self hideEmAll];
        [self randomUnhide];
        [self addOneToScore];
    } 
    
    BOOL blackHoleHit = CGRectIntersectsRect(ballRect, blackHole.frame) || CGRectIntersectsRect(ballRect, blackHoleTwo.frame);
    
    if ((blackHoleHit == YES) && isAnimating == NO) {
        [self gameOver];
    }
    
    BOOL bonusHoleHit = CGRectIntersectsRect(ballRect, bonusHole.frame);
    
    if (bonusHoleHit) {
        [self countFive];
        [bonusHole removeFromSuperview];
        bonusHole = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    targets = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int diff = [[[NSUserDefaults standardUserDefaults]objectForKey:@"difficultyIndex"]intValue];
    int themey = [[[NSUserDefaults standardUserDefaults]objectForKey:@"themeIndex"]intValue];
    
    [difficulty setSelectedSegmentIndex:diff];
    [theme setSelectedSegmentIndex:themey];
    
    [self difficultyChanged:difficulty];
    [self themeChanged:theme];
    
    [self submitOfflineScore];
    
    if (targets == nil) {
         targets = [[NSArray alloc]initWithObjects:one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, nil];
    }
    
    NSString *leaderboard = nil;
    if (difficulty.selectedSegmentIndex == 0) {
        leaderboard = @"com.fhsjaagshs.blockgamehs";
    } else if (difficulty.selectedSegmentIndex == 1) {
        leaderboard = @"com.fhsjaagshs.blockgameMedium";
    } else if (difficulty.selectedSegmentIndex == 2) {
        leaderboard = @"com.fhsjaagshs.blockGameHard";
    } else if (difficulty.selectedSegmentIndex == 3) {
        leaderboard = @"com.fhsjaagshs.blockGameInsane";
    }
    
    if (gameCenterManager != nil) {
        [gameCenterManager authenticateLocalUser];
        [gameCenterManager reloadHighScoresForCategory:leaderboard];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    targets = nil;
	[super viewWillDisappear:animated];
}

@end
