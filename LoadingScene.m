//
//  LoadingScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "LoadingScene.h"

#import "cocos2d.h"
#import "GameScene.h"

@implementation LoadingScene

-(instancetype)init {
    if (self = [super init]) {
        CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Loading..." fontName:@"Georgia-BoldItalic" fontSize:24];
        loading.anchorPoint = ccp(0.5f, 0.5f);
        loading.positionType = CCPositionTypeNormalized;
        loading.position = ccp(0.5f, 0.5f);
        [self addChild:loading];
    }
    
    return self;
}

-(void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    GameScene *scene = [[GameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
