//
//  Hunter.h
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

typedef enum HunterState{
    HunterStateIdle,
    HunterStateAiming,
    HunterStateReloading
} HunterState;

@interface Hunter : CCSprite

@property (nonatomic, assign) HunterState hunterState;

-(void)aimAtPoint:(CGPoint)point;
-(CCSprite*)shootAtPoint:(CGPoint)point;
-(void)getReadyToShootAgain;
-(CGPoint)torsoCenterInWorldCoordinates;
-(float)torsoRotation;

@end
