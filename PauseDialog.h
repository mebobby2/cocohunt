//
//  PauseDialog.h
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface PauseDialog : CCNode

@property (nonatomic, copy) void(^onCloseBlock)(void);

@end
