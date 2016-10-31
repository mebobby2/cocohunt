//
//  PhysicsBird.m
//  CocoHunt
//
//  Created by Bobby Lei on 31/10/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "PhysicsBird.h"
#import "cocos2d.h"

typedef NS_ENUM(NSUInteger, PhysicsBirdState)
{
    PhysicsBirdStateIdle,
    PhysicsBirdStateFlyingIn,
    PhysicsBirdStateFlyoutOut
};

@implementation PhysicsBird

PhysicsBirdState _state;
CGPoint _targetPoint;

CCPhysicsJoint *_stoneJoint;

-(instancetype)initWithBirdType:(BirdType)typeOfBird
{
    if (self = [super initWithBirdType:typeOfBird]) {
        _state = PhysicsBirdStateIdle;
        
        CCPhysicsBody *body = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.height*0.3f andCenter:self.anchorPointInPoints];
        body.collisionType = @"bird";
        body.type = CCPhysicsBodyTypeDynamic;
        body.mass = 30.0f;
        self.physicsBody = body;
    }
    
    return self;
}

-(void)flyAndDropStoneAt:(CGPoint)point stone:(CCSprite *)stone {
    _state = PhysicsBirdStateFlyingIn;
    _targetPoint = point;
    self.stoneToDrop = stone;
    
    self.stoneToDrop.physicsBody.collisionMask = @[];
    self.physicsBody.collisionMask = @[];
    
    float distanceToHoldTheStone = self.contentSize.height * 0.5f;
    self.stoneToDrop.position = ccpSub(self.position, ccp(0, distanceToHoldTheStone));
    
    _stoneJoint = [CCPhysicsJoint connectedDistanceJointWithBodyA:self.physicsBody bodyB:stone.physicsBody anchorA:self.anchorPointInPoints anchorB:stone.anchorPointInPoints];
}

-(void)fixedUpdate:(CCTime)dt {
    float forceToHoldBird = -1 * self.physicsBody.mass * self.physicsNode.gravity.y;
    
    if (_state == PhysicsBirdStateFlyingIn) {
        float forceToHoldStone = -1 * self.stoneToDrop.physicsBody.mass * self.physicsNode.gravity.y;
        
        float forceUp = forceToHoldBird + forceToHoldStone;
        
        [self.physicsBody applyForce:ccp(-1500, forceUp)];
        
        if (self.position.x <= _targetPoint.x) {
            _state = PhysicsBirdStateFlyoutOut;
            [self dropStone];
        }
    } else if (_state == PhysicsBirdStateFlyoutOut) {
        float forceUp = forceToHoldBird * 1.5f;
        
        [self.physicsBody applyForce:ccp(0, forceUp)];
        
        CGSize viewSize = [CCDirector sharedDirector].viewSize;
        if (self.position.y > viewSize.height) {
            [self removeFromParentAndCleanup:YES];
        }
    }
}

-(void)dropStone {
    self.stoneToDrop.physicsBody.collisionMask = nil;
    [_stoneJoint invalidate];
}

@end
