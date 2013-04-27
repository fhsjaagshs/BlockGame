//
//  AppDelegate.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.idleTimerDisabled = YES;
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _viewController = [[ViewController alloc]init];
    _window.rootViewController = _viewController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (_viewController.motionManager.isAccelerometerActive) {
        [_viewController togglePause];
    }
}

@end
