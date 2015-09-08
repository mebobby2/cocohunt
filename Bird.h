//
//  Bird.h
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

typedef enum BirdType {
    BirdTypeBig,
    BirdTypeMedium,
    BirdTypeSmall
} BirdType;

typedef enum BirdState{
    BirdStateFlyingIn,
    BirdStateFlyingOut,
    BirdStateFlewOut,
    BirdStateDead
} BirdState;

@interface Bird : CCSprite

@property (nonatomic, assign) BirdType birdType;
@property (nonatomic, assign) BirdState birdState;

-(instancetype)initWithBirdType:(BirdType)typeOfBird;
-(void)removeBird:(BOOL)hitByArrow;
-(void)turnaround;

@end
