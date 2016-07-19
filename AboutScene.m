//
//  AboutScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 28/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AboutScene.h"

@implementation AboutScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
        [self addText];
        [self addBackButton];
        [self addVisitWebsiteButton];
    }
    return self;
}

-(void)addBackground {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"about_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    bg.scaleX = 1.2f;
    [self addChild:bg];
}

-(void)addText {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    NSString* aboutText = @"Put some long text here!";
    NSString * aboutFont = @"AppleSDGothicNeo-Medium";
    float aboutFontSize = 14;
    CGSize aboutTextRect = CGSizeMake(viewSize.width * 0.8f, viewSize.height * 0.6f);
    
    CCLabelTTF *aboutLabel = [CCLabelTTF labelWithString:aboutText fontName:aboutFont fontSize:aboutFontSize dimensions:aboutTextRect];
    aboutLabel.positionType  = CCPositionTypeNormalized;
    aboutLabel.position = ccp(0.5f, 0.3f);
    
    aboutLabel.color = [CCColor orangeColor];
    aboutLabel.shadowColor = [CCColor grayColor];
    aboutLabel.shadowBlurRadius = 1.0f;
    aboutLabel.shadowOffset  =ccp(1.0f, -1.0f);
    [self addChild:aboutLabel];
}

-(void)addBackButton {
    CCSpriteFrame *backNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_back.png"];
    CCSpriteFrame *backHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_back_pressed.png"];
    
    CCButton *btnBack = [CCButton buttonWithTitle:nil spriteFrame:backNormalImage highlightedSpriteFrame:backHighlightedImage disabledSpriteFrame:nil];
    btnBack.positionType = CCPositionTypeNormalized;
    btnBack.position = ccp(0.1f, 0.9f);
    
    [btnBack setTarget:self selector:@selector(backTapped:)];
    [self addChild:btnBack];
}

-(void)backTapped:(id) sender {
    //CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.0f];
    //[[CCDirector sharedDirector] popSceneWithTransition:transition];
    [[CCDirector sharedDirector] popScene];
}

-(void)addVisitWebsiteButton {
    CCSpriteFrame *normal = [CCSpriteFrame frameWithImageNamed:@"btn_9slice.png"];
    CCSpriteFrame *pressed = [CCSpriteFrame frameWithImageNamed:@"btn_9slice_pressed.png"];
    
    CCButton *btnVisitWebsite = [CCButton buttonWithTitle:@"Visit Web Site" spriteFrame:normal highlightedSpriteFrame:pressed disabledSpriteFrame:nil];
    btnVisitWebsite.positionType = CCPositionTypeNormalized;
    btnVisitWebsite.position = ccp(0.5f, 0.1f);
    
    btnVisitWebsite.horizontalPadding = 12.0f;
    btnVisitWebsite.verticalPadding = 4.0f;
    btnVisitWebsite.label.fontName = @"HelveticaNueu-Bold";
    btnVisitWebsite.label.fontSize = 10.0f;
    
    btnVisitWebsite.block = ^(id sender) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://packtpub.com"]];
    };
    
    [self addChild:btnVisitWebsite];
}

@end
