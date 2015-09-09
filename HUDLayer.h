//
//  HUDLayer.h
//  CocoHunt
//
//  Created by Bobby Lei on 10/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameStats.h"

@interface HUDLayer : CCNode

-(void)updateStats:(GameStats*)stats;

@end
