//
//  HighscoreManager.h
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "GameStats.h"

#define kMaxHighscores 5

@interface HighscoreManager : NSObject
-(NSArray*)getHighScores;
-(BOOL)isHighscore:(int)score;
-(void)addHighScore:(GameStats*)newHighscore;
+(HighscoreManager*)sharedHighscoreManager;
@end
