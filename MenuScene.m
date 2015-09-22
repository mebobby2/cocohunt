//
//  MenuScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 22/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@interface MenuScene()

@property (nonatomic) CCLayoutBox *menu;

@end

@implementation MenuScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
        [self addMenuButtons];
    }
    return self;
}

-(void)addBackground {
    //CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"menu_bg.png"];
    bg.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    bg.position = ccp(0.5f, 0.5f);
    //bg.scaleX = 1.2f;
    [self addChild:bg];
}

-(void)addMenuButtons {
    CCSpriteFrame *startNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_start.png"];
    CCSpriteFrame *startHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_start_pressed.png"];
    
    CCButton *btnStart = [CCButton buttonWithTitle:nil spriteFrame:startNormalImage highlightedSpriteFrame:startHighlightedImage disabledSpriteFrame:nil];
    
    [btnStart setTarget:self selector:@selector(btnStartTapped:)];
    
    CCSpriteFrame *aboutNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_about.png"];
    CCSpriteFrame *aboutHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_about_pressed.png"];
    
    CCButton *btnAbout = [CCButton buttonWithTitle:nil spriteFrame:aboutNormalImage highlightedSpriteFrame:aboutHighlightedImage disabledSpriteFrame:nil];
    
    [btnAbout setTarget:self selector:@selector(btnAboutTapped:)];
    
    CCSpriteFrame *highscoresNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_highscores.png"];
    CCSpriteFrame *highscoresHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_highscores_pressed.png"];
    
    CCButton *btnHighscores = [CCButton buttonWithTitle:nil spriteFrame:highscoresNormalImage highlightedSpriteFrame:highscoresHighlightedImage disabledSpriteFrame:nil];
    
    [btnHighscores setTarget:self selector:@selector(btnHighscoresTapped:)];
    
    self.menu = [[CCLayoutBox alloc] init];
    self.menu.direction = CCLayoutBoxDirectionVertical;
    self.menu.spacing = 40.0f;
    
    [self.menu addChild:btnHighscores];
    [self.menu addChild:btnAbout];
    [self.menu addChild:btnStart];
    
    [self.menu layout];
    
    self.menu.anchorPoint = ccp(0.5f, 0.5f);
    self.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    self.menu.position = ccp(0.5f, 0.5f);
    
    [self addChild:self.menu];
}

-(void)btnStartTapped:(id)sender {
    CCLOG(@"Start Tapped");
    [[CCDirector sharedDirector] replaceScene:[[GameScene alloc] init] ];
}

-(void)btnAboutTapped:(id)sender {
    CCLOG(@"About Tapped");
}

-(void)btnHighscoresTapped:(id)sender {
    CCLOG(@"Highscores Tapped");
}

@end
