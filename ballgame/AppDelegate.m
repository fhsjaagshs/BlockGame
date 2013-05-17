//
//  AppDelegate.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

NSString * const difficultyIndexKey = @"difficultyIndex";
NSString * const themeIndexKey = @"themeIndex";
NSString * const offlineScoreKey = @"offlineScore";
NSString * const gameOverKey = @"gameOver";
NSString * const savedScoreKey = @"savedScore";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.idleTimerDisabled = YES;
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.rootViewController = [[ViewController alloc]init];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [((ViewController *)_window.rootViewController) startTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    ViewController *viewController = ((ViewController *)_window.rootViewController);
    if (viewController.motionManager.isAccelerometerActive) {
        [viewController togglePause];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
