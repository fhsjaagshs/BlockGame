
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

@implementation GameCenterManager

@synthesize earnedAchievementCache;
@synthesize delegate;

- (id)init {
	self = [super init];
	if (self) {
		self.earnedAchievementCache = nil;
	}
	return self;
}

- (void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError *)err {
    assert(selector != nil);
	assert([NSThread isMainThread]);
	if ([delegate respondsToSelector:selector]) { // exception bad access here when black hole appears (odd much?)
        if (selector != nil) {
            if ([delegate respondsToSelector:selector]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                
                if (arg != nil) {
                    [delegate performSelector:selector withObject:arg withObject:err];
                } else {
                    [delegate performSelector:selector withObject:err];
                    
                }
                
                #pragma clang diagnostic pop
            }
        }
	}
}

- (void)callDelegateOnMainThread:(SEL)selector withArg:(id)arg error:(NSError *)err {
	dispatch_async(dispatch_get_main_queue(), ^(void) {
	   [self callDelegate: selector withArg: arg error: err];
	});
}

- (void)authenticateLocalUser {
	if([GKLocalPlayer localPlayer].authenticated == NO) {
		[[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:^(NSError *error) {
			[self callDelegateOnMainThread:@selector(processGameCenterAuth:) withArg:nil error:error];
		}];
	}
}

- (void)reloadHighScoresForCategory:(NSString *)category {
	GKLeaderboard *leaderBoard = [[GKLeaderboard alloc]init];
	leaderBoard.category = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range = NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		[self callDelegateOnMainThread:@selector(reloadScoresComplete:error:) withArg:leaderBoard error:error];
	}];
}

- (void)reportScore:(int64_t)score forCategory:(NSString *)category {
	GKScore *scoreReporter = [[GKScore alloc]initWithCategory:category];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        [self callDelegateOnMainThread: @selector(scoreReported:) withArg: NULL error: error];
    }];
}

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete {
	if (self.earnedAchievementCache == nil) {
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *scores, NSError *error) {
			if (error == nil) { // dafuq?
				NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:scores.count];
				for (GKAchievement *score in scores) {
                    [tempCache setObject: score forKey: score.identifier];
				}
				self.earnedAchievementCache = tempCache;
				[self submitAchievement:identifier percentComplete:percentComplete];
			} else {
				[self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:nil error:error];
			}
		}];
        
	} else {
		GKAchievement *achievement = [self.earnedAchievementCache objectForKey:identifier];
        
		if (achievement != nil) {
			if((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
				achievement = nil;
			}
			achievement.percentComplete = percentComplete;
		} else {
			achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
			achievement.percentComplete = percentComplete;
			[self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
		}
        
		if (achievement != nil) {
			[achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                [self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:achievement error:error];
			}];
		}
	}
}

- (void)resetAchievements {
	self.earnedAchievementCache = nil;
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        [self callDelegateOnMainThread:@selector(achievementResetResult:) withArg:nil error:error];
	}];
}

- (void)mapPlayerIDtoPlayer:(NSString *)playerID {
    
	[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObjects:playerID, nil] withCompletionHandler:^(NSArray *playerArray, NSError *error) {
		GKPlayer *player = nil;
		for (GKPlayer *tempPlayer in playerArray) {
			if ([tempPlayer.playerID isEqualToString:playerID]) {
				player = tempPlayer;
				break;
			}
		}
		[self callDelegateOnMainThread:@selector(mappedPlayerIDToPlayer:error:) withArg:player error:error];
	}];
}

@end
