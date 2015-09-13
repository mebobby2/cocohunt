//
//  IntroScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 14/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "IntroScene.h"
#import "GameScene.h"

@interface IntroScene()

@property CCSprite* explodingCoconut;

@end

@implementation IntroScene

-(instancetype)init {
    if (self = [super init]) {
        CGSize viewSize = [CCDirector sharedDirector].viewSize;
        self.explodingCoconut = [CCSprite spriteWithImageNamed:@"Exploding_Coconut_0.png"];
        self.explodingCoconut.position = ccp(viewSize.width*0.5f, viewSize.height*0.5f);
        [self addChild:self.explodingCoconut];
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    [self animateCoconutExplosion];
}

-(void)animateCoconutExplosion {
    NSMutableArray *frames = [NSMutableArray array];
    int lastFrameNumber = 34;
    for (int i = 0; i <= lastFrameNumber; i++) {
        NSString *frameName = [NSString stringWithFormat:@"Exploding_Coconut_%d.png", i];
        CCSpriteFrame *frame = [CCSpriteFrame frameWithImageNamed:frameName];
        [frames addObject:frame];
    }
    
    CCAnimation *explosion = [CCAnimation animationWithSpriteFrames:frames delay:0.15f];
    CCActionAnimate *animateExplosion = [CCActionAnimate actionWithAnimation:explosion];
    CCActionEaseIn *easedExplosion = [CCActionEaseIn actionWithAction:animateExplosion rate:1.5f];
    
    CCActionCallFunc *proceedToGameScene = [CCActionCallFunc actionWithTarget:self selector:@selector(proceedToGameScene)];
    CCActionSequence *sequence = [CCActionSequence actions:easedExplosion, proceedToGameScene, nil];
    [self.explodingCoconut runAction:sequence];
}

-(void)proceedToGameScene {
    [[CCDirector sharedDirector] replaceScene:[[GameScene alloc] init]];
}

@end
