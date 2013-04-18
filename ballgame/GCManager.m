//
//  GCManager.m
//  ballgame
//
//  Created by Nathaniel Symer on 4/8/13.
//  Copyright (c) 2013 Nathaniel Symer. All rights reserved.
//

#import "GCManager.h"
#import <GameKit/GameKit.h>
#import <objc/runtime.h>

@implementation GCManager

+ (id)earnedAcheivementCache {
    return objc_getAssociatedObject(@"eac", "eac");
}

+ (void)setEarnedArcheivementCache:(NSMutableDictionary *)dict {
    objc_setAssociatedObject(@"eac", "eac", dict, OBJC_ASSOCIATION_RETAIN);
}

+ (void)authenticateLocalUserWithCompletionHandler:(void(^)(NSError *error))block {
	if([GKLocalPlayer localPlayer].authenticated == NO) {
		[[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:^(NSError *error) {
			block(error);
		}];
	}
}

+ (void)reloadHighScoresForCategory:(NSString *)category withCompletionHandler:(void(^)(NSArray *scores, GKLeaderboard *leaderboard, NSError *error))block {
	GKLeaderboard *leaderBoard = [[GKLeaderboard alloc]init];
	leaderBoard.category = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range = NSMakeRange(1, 1);
    
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		block(scores, leaderBoard, error);
	}];
}

+ (void)reportScore:(int64_t)score forCategory:(NSString *)category withCompletionHandler:(void(^)(NSError *error))block {
	GKScore *scoreReporter = [[GKScore alloc]initWithCategory:category];
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler:block];
}

+ (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete andCompletionHandler:(void(^)(GKAchievement *acheivement, NSError *error))block {
    
    NSMutableDictionary *tempCache = [GCManager earnedAcheivementCache];
    
	if (!tempCache) {
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *scores, NSError *error) {
			if (!error) {
				NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:scores.count];
				for (GKAchievement *score in scores) {
                    [temp setObject: score forKey: score.identifier];
				}
                [GCManager setEarnedArcheivementCache:temp];
                [self submitAchievement:identifier percentComplete:percentComplete andCompletionHandler:block];
			} else {
                block(nil, error);
			}
		}];
	} else {
		GKAchievement *achievement = [tempCache objectForKey:identifier];
        
		if (achievement != nil) {
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
				achievement = nil;
			}
			achievement.percentComplete = percentComplete;
		} else {
			achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
			achievement.percentComplete = percentComplete;
            
           
			[tempCache setObject:achievement forKey:achievement.identifier];
            [GCManager setEarnedArcheivementCache:tempCache];
		}
        
		if (achievement) {
			[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                block(achievement, error);
			}];
		}
	}
}

+ (void)resetAchievementsWithCompletionHandler:(void(^)(NSError *error))block {
    [GCManager setEarnedArcheivementCache:nil];
	[GKAchievement resetAchievementsWithCompletionHandler:block];
}

+ (void)mapPlayerIDtoPlayer:(NSString *)playerID withCompletionBlock:(void(^)(GKPlayer *player, NSError *error))block {
    
	[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObjects:playerID, nil] withCompletionHandler:^(NSArray *playerArray, NSError *error) {
		GKPlayer *player = nil;
		for (GKPlayer *tempPlayer in playerArray) {
			if ([tempPlayer.playerID isEqualToString:playerID]) {
				player = tempPlayer;
				break;
			}
		}
        if (block) {
            block(player, error);
        }
	}];
}

@end
