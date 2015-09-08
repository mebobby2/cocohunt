//
//  Bird.m
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Bird.h"

@interface Bird()

@property (nonatomic, assign) int timesToVisit;

@end

@implementation Bird

-(instancetype)initWithBirdType:(BirdType)typeOfBird {
    NSString *birdImageName;
    
    switch (typeOfBird) {
        case BirdTypeBig:
            birdImageName = @"bird_big_0.png";
            break;
        case BirdTypeMedium:
            birdImageName = @"bird_middle_0.png";
            break;
        case BirdTypeSmall:
            birdImageName = @"bird_small_0.png";
            break;
        default:
            CCLOG(@"Unknown bird type, using small bird!");
            birdImageName = @"bird_small_0.png";
            break;
    }
    
    if (self = [super initWithImageNamed:birdImageName]) {
        self.birdType = typeOfBird;
        self.timesToVisit = 3;
        self.birdState = BirdStateFlyingIn;
        [self animateFly];
    }
    return self;
}

-(void)animateFly {
    NSString* animFrameNameFormat;
    
    switch (self.birdType) {
        case BirdTypeBig:
            animFrameNameFormat = @"bird_big_%d.png";
            break;
        case BirdTypeMedium:
            animFrameNameFormat = @"bird_middle_%d.png";
            break;
        case BirdTypeSmall:
            animFrameNameFormat = @"bird_small_%d.png";
        default:
            CCLOG(@"Unknown bird type, using small bird anim.!");
            animFrameNameFormat = @"bird_small_%d.png";
            break;
    }
    
    NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        NSString *currentFrameName = [NSString stringWithFormat:animFrameNameFormat, i];
        
        CCSpriteFrame *animationFrame = [CCSpriteFrame frameWithImageNamed:currentFrameName];
        
        [animFrames addObject:animationFrame];
    }
    
    CCAnimation* flyAnimation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.1f];
    
    CCActionAnimate *flyAnimateAction = [CCActionAnimate actionWithAnimation:flyAnimation];
    
    CCActionRepeatForever *flyForever = [CCActionRepeatForever actionWithAction:flyAnimateAction];
    
    [self runAction:flyForever];
}

-(void)removeBird:(BOOL)hitByArrow {
    [self removeFromParentAndCleanup:YES];
    
    if (hitByArrow) {
        self.birdState = BirdStateDead;
    } else {
        self.birdState = BirdStateFlewOut;
    }
}

-(void)turnaround {
    self.flipX = !self.flipX;
    
    if (self.flipX)
        self.timesToVisit--;
    
    if (self.timesToVisit <= 0) {
        self.birdState = BirdStateFlyingOut;
    }
}

@end
