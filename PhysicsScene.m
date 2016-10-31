//
//  PhysicsScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 20/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "PhysicsScene.h"
#import "PhysicsHunter.h"
#import "PhysicsBird.h"

#define kBackgroundZ 10
#define kPhysicsWorldZ 11
#define kGroundZ 15
#define kObjectsZ 20

@implementation PhysicsScene

CCPhysicsNode *_physicsNode;
CCSprite *_ground;
PhysicsHunter *_hunter;
NSObject * _stoneGroundCollisionGroup;
float _timeUntilNextStone;
NSMutableArray *_stones;

-(void)onEnter {
    [super onEnter];
    
    _stoneGroundCollisionGroup = [[NSObject alloc] init];
    _stones = [NSMutableArray array];
    _timeUntilNextStone = 2.0f;
    
    [self createPhysicsNode];
    [self cacheSprite];
    [self addBackground];
    [self addGround];
}

-(void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    [self createHunter];
    [self spawnStone];
    [self addBoundaries];
}

-(void)fixedUpdate:(CCTime)dt {
    for (CCSprite *stone in [_stones copy]) {
        if (stone.position.y < -10) {
            [_stones removeObject:stone];
            [stone removeFromParentAndCleanup:YES];
        }
    }
    
    if (_hunter.state != PhysicsHunterStateDead) {
        _timeUntilNextStone -= dt;
        if (_timeUntilNextStone < 0) {
            _timeUntilNextStone = 1.0f + arc4random_uniform(1.0f);
            [self spawnStone];
        }
    }
}

-(void)createPhysicsNode {
    _physicsNode = [CCPhysicsNode node];
    _physicsNode.gravity = ccp(0, -250);
    _physicsNode.collisionDelegate = self;
    //_physicsNode.debugDraw = YES; //debugDraw does not work for this version of cocos2d and xcode, some shader files are missing
    [self addChild:_physicsNode z:kPhysicsWorldZ];
}

-(void)cacheSprite {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"physics_level.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
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
    stoneBody.collisionType = @"stone";
    //stoneBody.collisionMask = @[@"hunters"];
    stoneBody.collisionGroup = _stoneGroundCollisionGroup;
    stoneBody.mass = 10.0f;
    stoneBody.type = CCPhysicsBodyTypeDynamic;
    stone.physicsBody = stoneBody;
    [_physicsNode addChild:stone z:kObjectsZ];
    
    [_stones addObject:stone];
    [self launchBirdWithStone: stone];
}

-(void)launchStone:(CCSprite*)stone {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    stone.position = ccp(viewSize.width * 0.5f, viewSize.height * 0.9f);
    
    float xImpulseMin = -1200.0f;
    float xImpulseMax = 1200.0f;
    float yImpulse = 2000.0f;
    float xImpluse = xImpulseMin + 2.0f * arc4random_uniform(xImpulseMax);
    
    [stone.physicsBody applyImpulse: ccp(xImpluse, yImpulse)];
}

-(void)launchBirdWithStone:(CCSprite*)stone {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    PhysicsBird *bird = [[PhysicsBird alloc] initWithBirdType:BirdTypeBig];
    bird.position = ccp(viewSize.width * 1.1f, viewSize.height * 0.9f);
    
    [_physicsNode addChild:bird];
    
    CGPoint targetPosition = _hunter.position;
    
    [bird flyAndDropStoneAt:targetPosition stone:stone];
}

-(void)addGround {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    _ground = [CCSprite spriteWithImageNamed:@"ground.png"];
    _ground.scaleX = viewSize.width / [_ground boundingBox].size.width;
    
    CGRect groundRect;
    groundRect.origin = CGPointZero;
    groundRect.size = _ground.contentSize;
    
    CCPhysicsBody *groundBody = [CCPhysicsBody bodyWithRect:groundRect cornerRadius:0];
    groundBody.collisionType = @"ground";
    //groundBody.collisionCategories = @[@"obstacles"];
    groundBody.collisionGroup = _stoneGroundCollisionGroup;
    groundBody.type = CCPhysicsBodyTypeStatic;
    groundBody.elasticity = 1.5f;
    
    _ground.physicsBody = groundBody;
    
    _ground.anchorPoint = ccp(0.5f, 0);
    _ground.position = ccp(viewSize.width * 0.5f, 0);
    
    [_physicsNode addChild:_ground z:kGroundZ];
}

-(void)createHunter {
    _hunter = [[PhysicsHunter alloc] init];
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    _hunter.anchorPoint = ccp(0.5f, 0);
    _hunter.position = ccp(viewSize.width * 0.5f, _ground.contentSizeInPoints.height + 10);
    
    [_physicsNode addChild:_hunter z:kObjectsZ];
    
    self.userInteractionEnabled = YES;
}

-(void)addBoundaries {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CGRect boundRect = CGRectMake(0, 0, 20, viewSize.height * 0.25f);
    
    CCNode *leftBound = [CCNode node];
    leftBound.position = ccp(0, _ground.contentSize.height + 30);
    leftBound.contentSize = boundRect.size;
    
    CCPhysicsBody *leftBody = [CCPhysicsBody bodyWithRect:boundRect cornerRadius:0];
    leftBody.type = CCPhysicsBodyTypeStatic;
    leftBound.physicsBody = leftBody;
    
    [_physicsNode addChild:leftBound];
    
    CCNode *rightBound = [CCNode node];
    rightBound.contentSize = boundRect.size;
    rightBound.anchorPoint = ccp(1.0f, 0);
    rightBound.position = ccp(viewSize.width, leftBound.position.y);
    
    CCPhysicsBody *rightBody = [CCPhysicsBody bodyWithRect:boundRect cornerRadius:0];
    rightBody.type = CCPhysicsBodyTypeStatic;
    rightBound.physicsBody = rightBody;
    
    [_physicsNode addChild:rightBound];
}

//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair stone:(CCNode *)stone ground:(CCNode *)ground {
//    return NO;
//}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hunter:(CCNode *)hunter stone:(CCNode *)stone {
    [_hunter die];
    return YES;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    if (touchLocation.x >= viewSize.width * 0.5f)
        [_hunter runAtDirection:PhysicsHunterRunDirectionRight];
    else
        [_hunter runAtDirection:PhysicsHunterRunDirectionLeft];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (_hunter.state == PhysicsHunterStateDead) {
        PhysicsScene *scene = [[PhysicsScene alloc] init];
        [[CCDirector sharedDirector] replaceScene:scene];
    } else {
        [_hunter stop];
    }
}

@end
