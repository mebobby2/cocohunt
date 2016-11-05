//
//  TilemapScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 3/11/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "TilemapScene.h"
#import "cocos2d.h"
#import "Bird.h"

typedef NS_ENUM(NSUInteger, zOrder)
{
    zOrderBackground,
    zOrderTilemap,
    zOrderObjects
};

@implementation TilemapScene

float _worldSize;
CCTiledMap *_tileMap;
Bird *_bird;
CCParallaxNode *_parallaxNode;

-(void)onEnter {
    [super onEnter];
    
    [self cacheSprites];
    
    [self addBackground];
    [self addTiledmap];
    [self addBird];
}

-(void)update:(CCTime)dt {
    float distance = 75.0f * dt;
    
    CGPoint newPos = _parallaxNode.position;
    newPos.x = newPos.x - distance;
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    float endX = -1 * _worldSize + viewSize.width;
    
    if (newPos.x > endX)
        _parallaxNode.position = newPos;
}

-(void)cacheSprites {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
}

-(void)addBackground {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"tile_level_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    bg.scaleX = 1.2f;
    [self addChild:bg z:zOrderBackground];
}

-(void)addTiledmap {
    _tileMap = [CCTiledMap tiledMapWithFile:@"tilemap.tmx"];
    _worldSize = _tileMap.contentSizeInPoints.width;
   
    CCTiledMapLayer *bushes = [_tileMap layerNamed:@"Bushes"];
    CCTiledMapLayer *trees = [_tileMap layerNamed:@"Trees"];
    CCTiledMapLayer *ground = [_tileMap layerNamed:@"Ground"];
    
    _parallaxNode = [CCParallaxNode node];
    
    [bushes removeFromParentAndCleanup:NO];
    [trees removeFromParentAndCleanup:NO];
    [ground removeFromParentAndCleanup:NO];
    
    [_parallaxNode addChild:bushes z:0 parallaxRatio:ccp(0.2, 0) positionOffset:ccp(0, 0)];
    [_parallaxNode addChild:trees z:1 parallaxRatio:ccp(0.5, 0) positionOffset:ccp(0, 0)];
    [_parallaxNode addChild:ground z:2 parallaxRatio:ccp(1, 0) positionOffset:ccp(0, 0)];
    
    [self addChild:_parallaxNode z:zOrderTilemap];
}

-(void)addBird {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    _bird = [[Bird alloc] initWithBirdType:BirdTypeSmall];
    _bird.flipX = YES;
    _bird.position = ccp(viewSize.width * 0.2f, viewSize.height * 0.2f);
    [self addChild:_bird z: zOrderObjects];
}

@end
