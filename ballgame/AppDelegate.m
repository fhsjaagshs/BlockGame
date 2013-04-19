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
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.viewController = [[ViewController alloc]init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.viewController.motionManagerIsRunning) {
        [self.viewController togglePause];
    }
    
    [[NSUserDefaults standardUserDefaults]setFloat:self.viewController.currentNumber forKey:@"bonusholecurrentnumber"];
    
    if (![self.viewController.score.text isEqualToString:@"0"]) {
        [[NSUserDefaults standardUserDefaults]setObject:self.viewController.score.text forKey:@"savedScore"];
    }
}

@end
