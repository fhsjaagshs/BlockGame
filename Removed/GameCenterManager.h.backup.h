//
//  GameCenterManager.h
//  blockgame
//
//  Created by Nathaniel Symer on 11/7/11.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#define kEasyScore @"com.fhsjaagshs.blockgamehs"
#define kMedScore @"com.fhsjaagshs.blockgameMedium"
#define kHardScore @"com.fhsjaagshs.blockGameHard"
#define kInsaneScore @"com.fhsjaagshs.blockGameInsane"

@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol GameCenterManagerDelegate <NSObject>
@optional
- (void)processGameCenterAuth: (NSError*) error;
- (void)scoreReported: (NSError*) error;
- (void)reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void)achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void)achievementResetResult: (NSError*) error;
- (void)mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface GameCenterManager : NSObject
{
	NSMutableDictionary* earnedAchievementCache;
	
	id <GameCenterManagerDelegate, NSObject> __unsafe_unretained delegate;
    
    NSString *scoreString;
}

//This property must be atomic to ensure that the cache is always in a viable state...
@property (strong) NSMutableDictionary* earnedAchievementCache;

@property (nonatomic, unsafe_unretained)  id <GameCenterManagerDelegate> delegate;

//@property (strong) NSString *scoreString;

@property (assign) int64_t easyScore;
@property (assign) int64_t medScore;
@property (assign) int64_t hardScore;
@property (assign) int64_t insaneScore;

- (void)authenticateLocalUser;

- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)reloadHighScoresForCategory: (NSString*) category;

- (void)submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void)resetAchievements;

- (void)mapPlayerIDtoPlayer: (NSString*) playerID;

- (int64_t)getScoreForLocalPlayerWithLeaderboard:(NSString *)category;

//- (void)doscores:(NSString *)boardName;

@end
