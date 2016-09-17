//
//  WinLoseDialog.h
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameStats.h"

@interface WinLoseDialog : CCNode

-(instancetype)initWithGameStats:(GameStats *) stats;

@end
