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

-(void)onEnter {
    [super onEnter];
    
    [self cacheSprites];
    
    [self addBackground];
    [self addTiledmap];
    [self addBird];
}

-(void)update:(CCTime)dt {
    float distance = 75.0f * dt;
    
    CGPoint newTilemapPos = _tileMap.position;
    newTilemapPos.x = newTilemapPos.x - distance;
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    float endX = -1 * _worldSize + viewSize.width;
    
    if (newTilemapPos.x > endX)
        _tileMap.position = newTilemapPos;
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
    [self addChild:_tileMap z:zOrderTilemap];
}

-(void)addBird {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    _bird = [[Bird alloc] initWithBirdType:BirdTypeSmall];
    _bird.flipX = YES;
    _bird.position = ccp(viewSize.width * 0.2f, viewSize.height * 0.2f);
    [self addChild:_bird z: zOrderObjects];
}

@end
