//
//  GameStats.h
//  CocoHunt
//
//  Created by Bobby Lei on 10/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStats : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int birdsLeft;
@property (nonatomic, assign) int lives;
@property (nonatomic, assign) float timeSpent;

@end
