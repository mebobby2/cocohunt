//
//  Hunter.m
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Hunter.h"

@interface Hunter()

@property (nonatomic) CCSprite *torso;

@end

@implementation Hunter

-(instancetype)init {
    if (self = [super initWithImageNamed:@"hunter_bottom.png"]) {
        self.torso = [CCSprite spriteWithImageNamed:@"hunter_top_0.png"];
        self.torso.anchorPoint = ccp(0.5f, 10.0f/44.0f);
        self.torso.position = ccp(self.boundingBox.size.width / 2.0f, self.boundingBox.size.height);
        [self addChild:self.torso z:-1];
    }
    
    return self;
}

-(CGPoint)torsoCenterInWorldCoordinates {
    CGPoint torsoCenterLocal = ccp(self.torso.contentSize.width / 2.0f, self.torso.contentSize.height / 2.0f);
    CGPoint torsoCenterWorld = [self.torso convertToWorldSpace:torsoCenterLocal];
    return torsoCenterWorld;
}

-(float)calculateTorsoRotationToLookAtPoint:(CGPoint)targetPoint {
    CGPoint torsoCenterWorld = [self torsoCenterInWorldCoordinates];
    CGPoint pointStraightAhead = ccp(torsoCenterWorld.x + 1.0f, torsoCenterWorld.y);
    CGPoint forwardVector = ccpSub(pointStraightAhead, torsoCenterWorld);
    CGPoint targetVector = ccpSub(targetPoint, torsoCenterWorld);
    float angleRadians = ccpAngleSigned(forwardVector, targetVector);
    float angleDegrees = -1 * CC_RADIANS_TO_DEGREES(angleRadians);
    angleDegrees = clampf(angleDegrees, -60, 25);
    return angleDegrees;
}

-(void)aimAtPoint:(CGPoint)point {
    self.torso.rotation = [self calculateTorsoRotationToLookAtPoint:point];
}

-(CCSprite*)shootAtPoint:(CGPoint)point {
    [self aimAtPoint:point];
    CCSprite *arrow = [CCSprite spriteWithImageNamed:@"arrow.png"];
    arrow.anchorPoint = ccp(0, 0.5f);
    
    CGPoint torsoCenterGlobal = [self torsoCenterInWorldCoordinates];
    arrow.position = torsoCenterGlobal;
    arrow.rotation = self.torso.rotation;
    
    [self.parent addChild:arrow];
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    CGPoint forwardVector = ccp(1.0f, 0);
    float angleRadians = -1 * CC_DEGREES_TO_RADIANS(self.torso.rotation);
    CGPoint arrowMovementVector = ccpRotateByAngle(forwardVector, CGPointZero, angleRadians);
    arrowMovementVector = ccpNormalize(arrowMovementVector);
    arrowMovementVector = ccpMult(arrowMovementVector, viewSize.width * 2.0f);
    
    CCActionMoveBy *moveAction = [CCActionMoveBy actionWithDuration:2.0f position:arrowMovementVector];
    [arrow runAction:moveAction];
    
    return arrow;
    
    
}


@end
