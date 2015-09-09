//
//  GameStats.m
//  CocoHunt
//
//  Created by Bobby Lei on 10/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameStats.h"

@implementation GameStats

-(instancetype)init {
    if (self = [super init]) {
        self.score = 0;
        self.birdsLeft = 0;
        self.lives = 0;
    }
    
    return self;
}

@end
