//
//  GCManager.h
//  ballgame
//
//  Created by Nathaniel Symer on 4/8/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKAchievement, GKPlayer, GKLeaderboard;

@interface GCManager : NSObject

+ (void)authenticateLocalUserWithCompletionHandler:(void(^)(NSError *error))block;
+ (void)reloadHighScoresForCategory:(NSString *)category withCompletionHandler:(void(^)(NSArray *scores, GKLeaderboard *leaderboard, NSError *error))block;
+ (void)reportScore:(int64_t)score forCategory:(NSString *)category withCompletionHandler:(void(^)(NSError *error))block;
+ (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete andCompletionHandler:(void(^)(GKAchievement *acheivement, NSError *error))block;
+ (void)resetAchievementsWithCompletionHandler:(void(^)(NSError *error))block;
+ (void)mapPlayerIDtoPlayer:(NSString *)playerID withCompletionBlock:(void(^)(GKPlayer *player, NSError *error))block;

@end
