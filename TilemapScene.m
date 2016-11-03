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

-(void)cacheSprites {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
}

-(void)addBackground {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"tile_level_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
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
    _bird
}

@end
