//
//  AppDelegate.m
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
    
    NSString *savedScore = [[NSUserDefaults standardUserDefaults]objectForKey:@"savedScore"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"savedScore"];

    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"gameOver"]) {
        [self.viewController.score setText:savedScore];
        [self.viewController setStartButtonTitle:@"Resume"];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([UIAccelerometer sharedAccelerometer].delegate != nil) {
        [self.viewController togglePause];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSString *savedScore = self.viewController.score.text;
    [[NSUserDefaults standardUserDefaults]setObject:savedScore forKey:@"savedScore"];
}

@end
