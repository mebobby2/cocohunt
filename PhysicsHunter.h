//
//  PhysicsHunter.h
//  CocoHunt
//
//  Created by Bobby Lei on 16/10/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "cocos2d.h"

typedef NS_ENUM(NSUInteger, PhysicsHunterState)
{
    PhysicsHunterStateIdle,
    PhysicsHunterStateRunning,
    PhysicsHunterStateDead
};

typedef NS_ENUM(NSUInteger, PhysicsHunterRunDirection)
{
    PhysicsHunterRunDirectionLeft,
    PhysicsHunterRunDirectionRight
};

@interface PhysicsHunter : CCSprite

@property (nonatomic, readonly) PhysicsHunterState state;

-(void)runAtDirection:(PhysicsHunterRunDirection)direction;
-(void)stop;
-(void)die;

@end
