//
//  HighscoreManager.m
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "HighscoreManager.h"

@implementation HighscoreManager

NSMutableArray *_highScores;

-(instancetype)init {
    if (self = [super init]) {
        _highScores = [NSMutableArray arrayWithCapacity:kMaxHighscores];
    }
    
    return self;
}

-(BOOL)isHighscore:(int)score {
    return (score > 0) && ((_highScores.count < kMaxHighscores) || (score > [_highScores.lastObject score]));
}

-(void)addHighScore:(GameStats *)newHighscore {
    NSAssert([newHighscore.playerName length] > 0, @"You must specify player name for the highscore!");
    
    for (int i = 0; i < _highScores.count; i++) {
        GameStats *gs = [_highScores objectAtIndex:i];
        if (newHighscore.score > gs.score) {
            [_highScores insertObject:newHighscore atIndex:i];
            if (_highScores.count > kMaxHighscores)
                [_highScores removeLastObject];
            
            return;
        }
    }
    if (_highScores.count < kMaxHighscores) {
        [_highScores addObject:newHighscore];
        return;
    }
}

-(NSArray*)getHighScores {
    return _highScores;
}

+(HighscoreManager*)sharedHighscoreManager {
    static dispatch_once_t pred;
    static HighscoreManager *_sharedInstance;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
