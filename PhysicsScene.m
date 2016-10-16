//
//  PhysicsScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 20/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "PhysicsScene.h"

#define kBackgroundZ 10
#define kObjectsZ 20

@implementation PhysicsScene

CCPhysicsNode *_physicsNode;

-(void)onEnter {
    [super onEnter];
    
    [self createPhysicsNode];
    [self cacheSprite];
    [self addBackground];
}

-(void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    [self spawnStone];
}

-(void)createPhysicsNode {
    _physicsNode = [CCPhysicsNode node];
    _physicsNode.gravity = ccp(0, -250);
    //_physicsNode.debugDraw = YES; //debugDraw does not work for this version of cocos2d and xcode, some shader files are missing
    [self addChild:_physicsNode z:kObjectsZ];
}

-(void)cacheSprite {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"physics_level.plist"];
}

-(void)addBackground {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"physics_level_bg.png"];
    bg.position = ccp(viewSize.width * 0.5f, viewSize.height * 0.5f);
    bg.scaleX = viewSize.width / [bg boundingBox].size.width;
    bg.scaleY = viewSize.height / [bg boundingBox].size.height;
    [self addChild:bg z:kBackgroundZ];
}

-(void)spawnStone {
    CCSprite *stone = [CCSprite spriteWithImageNamed:@"stone.png"];
    float radius = stone.contentSizeInPoints.width * 0.5f;
    
    CCPhysicsBody *stoneBody = [CCPhysicsBody bodyWithCircleOfRadius:radius andCenter:stone.anchorPointInPoints];
    stoneBody.mass = 10.0f;
    stoneBody.type = CCPhysicsBodyTypeDynamic;
    stone.physicsBody = stoneBody;
    [_physicsNode addChild:stone];
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    stone.position = ccp(viewSize.width * 0.5f, viewSize.height * 0.9f);
}

@end
