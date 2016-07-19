//
//  HighscoresScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 16/7/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "HighscoresScene.h"

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MenuScene.h"

@implementation HighscoresScene

-(instancetype)init
{
    if (self = [super init])
    {
        [self addBackground];
        [self addBackButton];
    }
    
    return self;
}

-(void)addBackground
{
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"highscores_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    bg.scaleX = 1.2f;
    [self addChild:bg];
}

-(void)addBackButton
{
    CCSpriteFrame *backNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_back.png"];
    CCSpriteFrame *backHighlighedImage = [CCSpriteFrame frameWithImageNamed:@"btn_back_pressed.png"];
    CCButton *btnBack = [CCButton buttonWithTitle: nil spriteFrame:backNormalImage highlightedSpriteFrame:backHighlighedImage disabledSpriteFrame:nil];
    
    btnBack.positionType = CCPositionTypeNormalized;
    btnBack.position = ccp(0.1f, 0.9f);
    
    [btnBack setTarget:self selector:@selector(backTapped:)];
    [self addChild:btnBack];
    
}

-(void)backTapped:(id)sender
{
//    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:1.0f];
    MenuScene *scene = [[MenuScene alloc] init];
    //[[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
