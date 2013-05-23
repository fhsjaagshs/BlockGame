//
//  ViewController.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

float _bv_theta;
float _bv_numMovements;
BOOL _bv_shouldGetNumMovements;
CGSize _bv_dVector;
BOOL _bv_shouldSexilyMove;
float _bh_timeSinceRedraw;
CGRect _screenBounds;

@implementation ViewController

- (void)loadView {

    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIColor *transparentGrey = [UIColor colorWithWhite:0.666 alpha:0.5];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [transparentGrey CGColor]);
    CGContextFillRect(context, rect);
    UIGraphicsPopContext();
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _screenBounds = [[UIScreen mainScreen]bounds];
    
    BOOL isClassicMode = ([[NSUserDefaults standardUserDefaults]boolForKey:themeIndexKey] == 1);
    
    self.view = [[BackgroundView alloc]initWithFrame:_screenBounds];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [(BackgroundView *)self.view setClassicMode:isClassicMode];
    
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
    _startButton.frame = CGRectMake(124, 230, 72, 30);
    _startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _startButton.titleLabel.textColor = [UIColor whiteColor];
    _startButton.titleLabel.textAlignment = UITextAlignmentCenter;
    _startButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    _startButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startButton setBackgroundImage:transparentImage forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startOrRetry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    self.leaderboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leaderboardButton.frame = CGRectMake(102, 275, 113, 30);
    _leaderboardButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    _leaderboardButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _leaderboardButton.titleLabel.textColor = [UIColor whiteColor];
    _leaderboardButton.titleLabel.textAlignment = UITextAlignmentCenter;
    _leaderboardButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    _leaderboardButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [_leaderboardButton setBackgroundImage:transparentImage forState:UIControlStateNormal];
    [_leaderboardButton setTitle:@"Leaderboard" forState:UIControlStateNormal];
    [_leaderboardButton addTarget:self action:@selector(showLeaderboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leaderboardButton];

    self.theme = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Modern", @"Classic", nil]];
    _theme.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _theme.frame = CGRectMake(77, 402, 166, 30);
    _theme.segmentedControlStyle = UISegmentedControlStyleBar;
    [_theme setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults]floatForKey:themeIndexKey]];
    [_theme addTarget:self action:@selector(themeChanged) forControlEvents:UIControlEventValueChanged];
    [_theme setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_theme setDividerImage:transparentImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.view addSubview:_theme];
    
    self.difficulty = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Easy", @"Medium", @"Hard", @"Insane", nil]];
    _difficulty.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _difficulty.frame = CGRectMake(42, 326, 237, 30);
    _difficulty.segmentedControlStyle = UISegmentedControlStyleBar;
    [_difficulty setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults]floatForKey:difficultyIndexKey]];
    [_difficulty addTarget:self action:@selector(difficultyChanged) forControlEvents:UIControlEventValueChanged];
    [_difficulty setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_difficulty setDividerImage:transparentImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.view addSubview:_difficulty];
    
    self.target = [[TargetView alloc]init];
    [_target setClassicMode:isClassicMode];
    [self.view addSubview:_target];
    
    self.ball = [[BallView alloc]initWithFrame:CGRectMake(141, 172, 38, 38)];
    _ball.center = self.view.center;
    _ball.layer.shouldRasterize = YES;
    _ball.layer.shadowColor = [[UIColor blackColor]CGColor];
    _ball.layer.shadowOpacity = 0.7f;
    _ball.layer.shadowOffset = CGSizeZero;
    _ball.layer.shadowRadius = 5.0f;
    _ball.layer.masksToBounds = NO;
    _ball.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, 46, 46)]CGPath];
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
            [_difficultyLabel setHidden:YES];
            [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        }
    }
    
    [self difficultyChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_motionManager.accelerometerActive && ![[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        [self togglePause];
    }
}

- (void)startTimer {
    if (!_link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameTick)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (_link) {
        [_link invalidate];
    }
    self.link = nil;
}

- (void)gameTick {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        if (_hitSideForGameOver) {
            [_blackHoles makeObjectsPerformSelector:@selector(moveWithDuration:) withObject:[NSNumber numberWithFloat:_link.duration]];
        }
        return;
    }
    
    float duration = _link.duration;
    
    if (_bv_shouldSexilyMove) {
        if (_bv_numMovements < 1) {
            
            if (_bv_shouldGetNumMovements) {
                _bv_numMovements = floorf(0.45/duration);
                _bv_shouldGetNumMovements = NO;
            }
            
            if (_bv_numMovements < 1) {
                _bv_shouldGetNumMovements = NO;
                _bv_numMovements = -1;
                _bv_shouldSexilyMove = NO;
                return;
            }
        }
        
        float movement = log10f(_bv_numMovements)*4;
        
        float x = fabsf(movement*sinf(_bv_theta))*_bv_dVector.width;
        float y = fabsf(movement*cosf(_bv_theta))*_bv_dVector.height;
        
        CGPoint center = _ball.center;
        
        _ball.center = CGPointMake(center.x+x, center.y+y);
        _bv_numMovements -= 1;
    }
    
    [_blackHoles makeObjectsPerformSelector:@selector(moveWithDuration:) withObject:[NSNumber numberWithFloat:duration]];
    [_target moveWithDuration:duration];
    [_bonusHole moveWithDuration:duration];
    
    if (![self checkStuff]) {
        _bv_shouldGetNumMovements = NO;
        _bv_numMovements = -1;
        _bv_shouldSexilyMove = NO;
        return;
    }
    
    int index = _difficulty.selectedSegmentIndex;
    
    if (index > 0) {
        if (_blackHoles.count > 0) {
            _bh_timeSinceRedraw += duration;
            
            if (floorf(_bh_timeSinceRedraw) >= (5-index)) {
                [self redraw];
                _bh_timeSinceRedraw = 0;
            }
            
        } else {
            _bh_timeSinceRedraw = 0;
        }
    }
}

- (void)moveSexilyWithTheta:(float)theta andDirectionVector:(CGSize)vector {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        _bv_shouldSexilyMove = NO;
        return;
    }
    
    _bv_theta = theta;
    _bv_dVector = vector;
    _bv_shouldGetNumMovements = YES;
    _bv_shouldSexilyMove = YES;
}

- (void)showPurpleShitAtPoint:(CGPoint)point {
    
    CGRect frame = CGRectMake(point.x-50, point.y-50, 100, 100);
    
    UIImage *image = [[ImageCache sharedInstance]objectForKey:@"purpleImage"];
    
    if (!image) {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [[UIScreen mainScreen]scale]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
        CGContextSetLineWidth(context, 5);
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:165.0f/255.0f green:91.0f/255.0f blue:1.0f alpha:1.0f]CGColor]);
        
        for (int i = 0; i < 3; i++) {
            float width = 25*(i+1);
            CGContextStrokeEllipseInRect(context, CGRectMake(((100-width)/2), ((100-width)/2), width, width));
        }
        
        UIGraphicsPopContext();
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[ImageCache sharedInstance]setObject:image forKey:@"purpleImage"];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    imageView.image = image;
    
    [UIView animateWithDuration:0.5 animations:^{
        imageView.frame = CGRectMake(point.x-(50/4), point.y-(50/4), 25, 25);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                [imageView removeFromSuperview];
            }];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        return;
    }
    
    if (!_startButton.hidden) {
        return;
    }
    
    if ([_pauseButton.titleLabel.text isEqualToString:@"Resume"]) {
        return;
    }
    
    CGPoint point = [[touches anyObject]locationInView:self.view];
    
    if (CGRectContainsPoint(_pauseButton.frame, point)) {
        return;
    }

    if (CGRectContainsPoint(CGRectMake(point.x-100, point.y-100, 200, 200), _ball.center)) {
        CGSize vector = CGSizeMake(_ball.center.x-point.x, _ball.center.y-point.y);
        float theta = fabsf(atan(vector.height/vector.width)-M_PI_2);
        CGSize dVector = CGSizeMake(vector.width/fabsf(vector.width), vector.height/fabsf(vector.height));
        [self moveSexilyWithTheta:theta andDirectionVector:dVector];
        [self showPurpleShitAtPoint:point];
    } else if (CGRectContainsPoint(CGRectMake(point.x-200, point.y-200, 400, 400), _ball.center)) {
        CGSize vector = CGSizeMake(_ball.center.x-point.x, _ball.center.y-point.y);
        float theta = fabsf(atan(vector.height/vector.width)-M_PI_2);
        CGSize dVector = CGSizeMake((vector.width/fabsf(vector.width))/3, (vector.height/fabsf(vector.height))/3);
        [self moveSexilyWithTheta:theta andDirectionVector:dVector];
        [self showPurpleShitAtPoint:point];
    } else {
        CGSize vector = CGSizeMake(_ball.center.x-point.x, _ball.center.y-point.y);
        float theta = fabsf(atan(vector.height/vector.width)-M_PI_2);
        CGSize dVector = CGSizeMake((vector.width/fabsf(vector.width))/5, (vector.height/fabsf(vector.height))/5);
        [self moveSexilyWithTheta:theta andDirectionVector:dVector];
        [self showPurpleShitAtPoint:point];
    }
}

- (void)createMotionManager {
    self.motionManager = [[CMMotionManager alloc]init];
    _motionManager.accelerometerUpdateInterval = 1/120; // used to be 1/180, then 1/60
}

- (void)killBlackHoles {
    [_blackHoles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_blackHoles removeAllObjects];
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
    if (_blackHoles.count == 0) {
        _blackHoles = [NSMutableArray array];
    }
    
    int index = _difficulty.selectedSegmentIndex;
    
    if (index == 0) {
        [_blackHoles makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_blackHoles removeAllObjects];
    } else {
        int blackHolesC = [self numberOfBlackHoles];
        
        int remainder = blackHolesC-_blackHoles.count;
        
        if (remainder > 0) {
            for (int i = 0; i < remainder; i++) {
                BlackHole *blackHoleman = [[BlackHole alloc]init];
                [self.view addSubview:blackHoleman];
                [blackHoleman setDifficulty:index];
                [blackHoleman redrawRectWithBallFrame:_ball.frame];
                [_blackHoles addObject:blackHoleman];
            }
        }
    }
}

- (BOOL)checkStuff {
    CGRect frame = _ball.frame;

    if (CGRectIntersectsRect(frame, _target.frame)) {
        [self randomizePosition];
        [self addOneToScore];
    }
    
    if (CGRectIntersectsRect(frame, _bonusHole.frame) && !_bonusHole.hidden) {
        _score.text = [NSString stringWithFormat:@"%d",_score.text.intValue+5];
        [self flashScoreLabelToGreen];
        [_bonusHole setHidden:YES];
    }
    
    for (BlackHole *blackHoleman in _blackHoles) {
        if (CGRectIntersectsRect(frame, blackHoleman.frame)) {
            self.hitSideForGameOver = NO;
            [self gameOver];
            return NO;
        }
    }
    
    if (!CGRectContainsPoint(_screenBounds, _ball.center)) {
        self.hitSideForGameOver = YES;
        [self gameOver];
        return NO;
    }
    
    return YES;
}

- (void)handleAcceleration:(CMAcceleration)acceleration {
    int speed = (_difficulty.selectedSegmentIndex+1)*8;
    _ball.center = CGPointMake(_ball.center.x+(speed*acceleration.x), _ball.center.y+(-1*speed*acceleration.y));
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
    
    _target.hidden = NO;
    
    [_target setClassicMode:!(_theme.selectedSegmentIndex == 0)];
    
    int whichSide = (arc4random()%4)+1;
    
    int x = 0;
    int y = 0;
    int width = 30;
    int height = 90;
    
    if (whichSide == 1) {
        // left
        int limit = (_screenBounds.size.height-90);
        y = arc4random()%limit;
        _target.isVerticle = YES;
    } else if (whichSide == 2) {
        // right
        int limit = (_screenBounds.size.height-90);
        y = arc4random()%limit;
        x = _screenBounds.size.width-30;
        _target.isVerticle = YES;
    } else if (whichSide == 3) {
        // top
        int limit = (_screenBounds.size.width-90);
        x = arc4random()%limit;
        width = 90;
        height = 30;
        _target.isVerticle = NO;
    } else if (whichSide == 4) {
        // bottom
        int limit = (_screenBounds.size.width-90);
        x = arc4random()%limit;
        y = _screenBounds.size.height-30;
        width = 90;
        height = 30;
        _target.isVerticle = NO;
    }
    
    _target.frame = CGRectMake(x, y, width, height);
    _target.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, width+3, height+3)]CGPath];
    
    if (_theme.selectedSegmentIndex == 0) {
        [_target redrawWithImage];
    } else {
        NSArray *colors = [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor brownColor], [UIColor blackColor], nil];
        [_target redrawWithBackgroundColor:[colors objectAtIndex:arc4random()%8]];
    }
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
            
            UIView *blockerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
            blockerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            blockerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
            blockerView.clipsToBounds = YES;
            blockerView.layer.cornerRadius = 10;
            
            UIActivityIndicatorView	*spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.center = CGPointMake(blockerView.bounds.size.width/2, (blockerView.bounds.size.height/2));
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
        [self killBlackHoles];
    } else if (index == 1) {
        [_difficultyLabel setText:@"Medium"];
    } else if (index == 2) {
        [_difficultyLabel setText:@"Hard"];
    } else if (index == 3) {
        [_difficultyLabel setText:@"Insane"];
    }
    
    [_blackHoles makeObjectsPerformSelector:@selector(setDifficultyWithNSNumber:) withObject:[NSNumber numberWithInt:index]];
    [_bonusHole setDifficulty:index];
    [_target setDifficulty:index];
}

- (void)themeChanged {
    [[NSUserDefaults standardUserDefaults]setFloat:_theme.selectedSegmentIndex forKey:themeIndexKey];
    BOOL isSelectedIndexOne = (_theme.selectedSegmentIndex == 1);
    [(BackgroundView *)self.view setClassicMode:isSelectedIndexOne];
    [_target setClassicMode:isSelectedIndexOne];
}

- (void)gameOver {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:gameOverKey]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:gameOverKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:savedScoreKey];
    
    [self stopMotionManager];
    
    [_themeLabel setHidden:NO];
    [_difficulty setHidden:NO];
    [_theme setHidden:NO];
    [_startButton setHidden:NO];
    [_gameOverLabel setHidden:NO];
    [_leaderboardButton setHidden:NO];
    [_pauseButton setHidden:YES];
    [_startButton setTitle:@"Retry" forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:_themeLabel];
    [self.view bringSubviewToFront:_difficulty];
    [self.view bringSubviewToFront:_theme];
    [self.view bringSubviewToFront:_startButton];
    [self.view bringSubviewToFront:_leaderboardButton];
    
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

- (void)togglePause {
    if (_motionManager.isAccelerometerActive) {
        [self stopMotionManager];
        [self stopTimer];
        [_pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        [_theme setHidden:NO];
        [_themeLabel setHidden:NO];
    } else {
        [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [_themeLabel setHidden:YES];
        [_theme setHidden:YES];
        
        [self startTimer];
        [self startMotionManager];
        [self updateBlackHoles];
    }
}

- (void)startOrRetry {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:gameOverKey];

    [self reloadHighscoresWithBlock:nil];
    [self killBlackHoles];
    
    [_bonusHole setHidden:YES];
    
    [self startTimer];
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

    [self randomizePosition];
    [self submitOfflineScore];
}

- (void)redrawBonusHole {
    
    if (!_bonusHole) {
        self.bonusHole = [[BonusHole alloc]init];
        _bonusHole.difficulty = _difficulty.selectedSegmentIndex;
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
    [_blackHoles makeObjectsPerformSelector:@selector(redrawWithNSValueCGRect:) withObject:[NSValue valueWithCGRect:_ball.frame]];
}

- (void)addOneToScore {
    NSString *newScoreString = [NSString stringWithFormat:@"%d",_score.text.intValue+1];
    [_score setText:newScoreString];
    [[NSUserDefaults standardUserDefaults]setObject:newScoreString forKey:savedScoreKey];
    
    [self updateBlackHoles];
    [self redrawBonusHole];
}

- (void)flashScoreLabelToGreen {
    [_score setTextColor:[UIColor greenColor]];
    [_score performSelector:@selector(setTextColor:) withObject:[UIColor whiteColor] afterDelay:0.5];
}

@end
