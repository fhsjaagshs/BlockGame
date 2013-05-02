//
//  AppDelegate.h
//  ballgame
//
//  Created by Nathaniel Symer on 11/7/11.
//  Copyright (c) 2011 Nathaniel Symer. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString * const difficultyIndexKey;
NSString * const themeIndexKey;
NSString * const offlineScoreKey;
NSString * const gameOverKey;
NSString * const savedScoreKey;

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end
