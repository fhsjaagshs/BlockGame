//
//  GameCenterManager.m
//  blockgame
//
//  Created by Nathaniel Symer on 11/7/11.
//

#import "GameCenterManager.h"

@implementation GameCenterManager

@synthesize earnedAchievementCache;
@synthesize delegate;
@synthesize easyScore, medScore, hardScore, insaneScore;

- (id)init {
    
	self = [super init];
	if (self != NULL) {
		earnedAchievementCache = NULL;
	}
	return self;
}

- (void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError*)err
{
    assert(selector != NULL);
	assert([NSThread isMainThread]);
	if ([delegate respondsToSelector: selector]) {
        if (selector != NULL) {
            if ([delegate respondsToSelector:selector]) {
                if (arg != NULL) {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [delegate performSelector:selector withObject:arg withObject:err];
                    #pragma clang diagnostic pop
                } else {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [delegate performSelector:selector withObject:err];
                    #pragma clang diagnostic pop
                }
            }
        }
	}
}


- (void)callDelegateOnMainThread:(SEL)selector withArg:(id)arg error:(NSError*)err
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
	   [self callDelegate: selector withArg: arg error: err];
	});
}

- (void)authenticateLocalUser {
    
	if ([GKLocalPlayer localPlayer].authenticated == NO) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
			[self callDelegateOnMainThread:@selector(processGameCenterAuth:) withArg:NULL error:error];
		}];
	}
   /* [self doscores:kEasyScore];
    [self doscores:kMedScore];
    [self doscores:kHardScore];
    [self doscores:kInsaneScore];
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithLongLong:self.easyScore], [NSNumber numberWithLongLong:self.medScore], [NSNumber numberWithLongLong:self.hardScore], [NSNumber numberWithLongLong:self.insaneScore], nil];
    
    NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"scores.plist"];
    
    BOOL isThere = [[NSFileManager defaultManager]fileExistsAtPath:savePath];
    
    if (isThere) {
        [[NSFileManager defaultManager]removeItemAtPath:savePath error:nil];
    }
    
    [[NSFileManager defaultManager]createFileAtPath:savePath contents:nil attributes:nil];
    [array writeToFile:savePath atomically:YES];*/
}

- (void)reloadHighScoresForCategory:(NSString*)category {
    
	GKLeaderboard *leaderBoard = [[GKLeaderboard alloc]init];
	leaderBoard.category = category;
	leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
	leaderBoard.range = NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		[self callDelegateOnMainThread:@selector(reloadScoresComplete:error:) withArg:leaderBoard error:error];
	}];
}

- (void)reportScore:(int64_t)score forCategory:(NSString*)category  {
    
	GKScore *scoreReporter = [[GKScore alloc]initWithCategory:category];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
		 [self callDelegateOnMainThread:@selector(scoreReported:) withArg:NULL error:error];
	 }];
}

- (void)submitAchievement:(NSString*)identifier percentComplete:(double)percentComplete {
    
	if (self.earnedAchievementCache == NULL) {
		[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *scores, NSError *error) {
			if(error == NULL) {
				NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity: [scores count]];
				for (GKAchievement *score in scores)
				{
					[tempCache setObject:score forKey:score.identifier];
				}
				self.earnedAchievementCache = tempCache;
				[self submitAchievement:identifier percentComplete:percentComplete];
                
			} else {
				[self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:NULL error:error];
			}
        }];
	} else {
		GKAchievement *achievement = [self.earnedAchievementCache objectForKey:identifier];
		if(achievement != NULL) {
            
			if ((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
				achievement = NULL;
			}
			achievement.percentComplete = percentComplete;
        } else {
			achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
			achievement.percentComplete = percentComplete;
			[self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
		}
		
        if (achievement != NULL) {
            
			[achievement reportAchievementWithCompletionHandler: ^(NSError *error) {
				 [self callDelegateOnMainThread: @selector(achievementSubmitted:error:) withArg: achievement error: error];
			}];
		}
	}
}

- (void)resetAchievements {
    
	self.earnedAchievementCache= NULL;
	[GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) {
		 [self callDelegateOnMainThread: @selector(achievementResetResult:) withArg: NULL error: error];
	}];
}

- (void)mapPlayerIDtoPlayer:(NSString*)playerID {
    
	[GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *playerArray, NSError *error) {
        
		GKPlayer *player = NULL;
		for (GKPlayer *tempPlayer in playerArray)
		{
			if([tempPlayer.playerID isEqualToString:playerID])
			{
				player = tempPlayer;
				break;
			}
		}
		[self callDelegateOnMainThread:@selector(mappedPlayerIDToPlayer:error:) withArg:player error:error];
	}];
}

/*- (void)doscores:(NSString *)boardName {
    if ([GKLocalPlayer localPlayer].authenticated) {
        NSArray *arr = [NSArray arrayWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
        GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
        if(board != nil) {
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.category = boardName;
            [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                if (error == nil) {
                    GKScore *retrievedScore = ((GKScore*)[scores objectAtIndex:0]);
                    double score = retrievedScore.value;
                    double time = CFAbsoluteTimeGetCurrent();
                    NSLog(@"PreScore: %f time:%f", score, time);
                    
                    if (boardName == kEasyScore) {
                        easyScore = retrievedScore.value;
                    } else if (boardName == kMedScore) {
                        medScore = retrievedScore.value;
                    } else if (boardName == kHardScore) {
                        hardScore = retrievedScore.value;
                    } else if (boardName == kInsaneScore) {
                        insaneScore = retrievedScore.value;
                    }
            }
            }];
        }
    }
}*/

- (int64_t)getScoreForLocalPlayerWithLeaderboard:(NSString *)category {
    
    if ([GKLocalPlayer localPlayer].authenticated) {
        NSArray *arr = [NSArray arrayWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
        GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
        if(board != nil) {
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.category = category;
            
            [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                if (error == nil) {
                    GKScore *retrievedScore = ((GKScore*)[scores objectAtIndex:0]);
                    int64_t score = retrievedScore.value;
                    double time = CFAbsoluteTimeGetCurrent();
                    NSLog(@"PreSCore: %lld time:%f", score, time);
                    [[NSUserDefaults standardUserDefaults]setObject:scoreString forKey:@"scorey"];
                }
            }];
        //    [board loadScoresWithCompletionHandler:nil];
           // GKScore *retrievedScore = ((GKScore*)[board.scores objectAtIndex:0]);
      //      score = retrievedScore.value;
            int64_t returnValueNSUD = [[[NSUserDefaults standardUserDefaults]objectForKey:@"scorey"] longLongValue];
           // scoreString = nil;
            return returnValueNSUD;
          //  [self performSelectorOnMainThread:@selector(doscores:) withObject:board waitUntilDone:YES];
          /*  double time = CFAbsoluteTimeGetCurrent();
            GKScore *retrievedScore = ((GKScore*)[board.scores objectAtIndex:0]);
            int64_t scorey = retrievedScore.value;
            NSLog(@"Retrieved Score:%lld time:%f",scorey, time);
            return scorey;*/
        }
        return 0;
    } else {
        [self authenticateLocalUser];
    }
    return 0;
}

@end
