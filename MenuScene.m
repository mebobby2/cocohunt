//
//  MenuScene.m
//  CocoHunt
//
//  Created by Bobby Lei on 22/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "AudioManager.h"
#import "AboutScene.h"
#import "LevelSelectScene.h"
#import "HighscoresScene.h"

@interface MenuScene()

@property (nonatomic) CCLayoutBox *menu;
@property (nonatomic) CCButton* btnSoundToggle;
@property (nonatomic) CCButton* btnMusicToggle;

@end

@implementation MenuScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
        [self addMenuButtons];
        [self addAudioButtons];
    }
    return self;
}

-(void)addBackground {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"menu_bg.png"];
    bg.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    bg.position = ccp(0.5f, 0.5f);
    bg.scaleX = 1.2f;
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
    self.menu.positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    self.menu.position = ccp(0.5f, 0.5f);
    
    [self addChild:self.menu];
}

-(void)addAudioButtons {
    CCSpriteFrame *soundOnImage = [CCSpriteFrame frameWithImageNamed:@"btn_sound.png"];
    CCSpriteFrame *soundOffImage =  [CCSpriteFrame frameWithImageNamed:@"btn_sound_pressed.png"];
    self.btnSoundToggle = [CCButton buttonWithTitle:nil spriteFrame:soundOnImage highlightedSpriteFrame:soundOffImage disabledSpriteFrame:nil];
    self.btnSoundToggle.togglesSelectedState = YES;
    self.btnSoundToggle.selected = [AudioManager sharedAudioManager].isSoundEnabled;
    self.btnSoundToggle.block = ^(id sender) {
        [[AudioManager sharedAudioManager] toggleSound];
    };
    self.btnSoundToggle.positionType = CCPositionTypeNormalized;
    self.btnSoundToggle.position = ccp(0.95f, 0.1f);
    [self addChild:self.btnSoundToggle];
    
    CCSpriteFrame *musicOnImage = [CCSpriteFrame frameWithImageNamed:@"btn_music.png"];
    CCSpriteFrame *musicOffImage =  [CCSpriteFrame frameWithImageNamed:@"btn_music_pressed.png"];
    self.btnMusicToggle = [CCButton buttonWithTitle:nil spriteFrame:musicOnImage highlightedSpriteFrame:musicOffImage disabledSpriteFrame:nil];
    self.btnMusicToggle.togglesSelectedState = YES;
    self.btnMusicToggle.selected = [AudioManager sharedAudioManager].isMusicEnabled;
    self.btnMusicToggle.block = ^(id sender) {
        [[AudioManager sharedAudioManager] toggleMusic];
    };
    float musicButtonOffset = self.btnSoundToggle.boundingBox.size.width + 10;
    CGPoint soundButtonPosInPoints = self.btnSoundToggle.positionInPoints;
    
    self.btnMusicToggle.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    self.btnMusicToggle.position = ccp(soundButtonPosInPoints.x - musicButtonOffset, 0.1f);
    [self addChild:self.btnMusicToggle];
    
}

-(void)btnStartTapped:(id)sender {
    LevelSelectScene *levelSelectScene = [[LevelSelectScene alloc] init];
    //CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:1.0f];
    //[[CCDirector sharedDirector] replaceScene: levelSelectScene withTransition:transition ];
    [[CCDirector sharedDirector] replaceScene: levelSelectScene];
}

-(void)btnAboutTapped:(id)sender {
    AboutScene *aboutScene = [[AboutScene alloc] init];
   // CCTransition *aboutTransition = [CCTransition transitionCrossFadeWithDuration:1.0f];
    //[[CCDirector sharedDirector] pushScene:aboutScene withTransition:aboutTransition];
    [[CCDirector sharedDirector] pushScene:aboutScene];
}

-(void)btnHighscoresTapped:(id)sender {
    HighscoresScene *hsScene = [[HighscoresScene alloc] init];
//    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f];
    //[[CCDirector sharedDirector] replaceScene: hsScene withTransition:transition ];
    [[CCDirector sharedDirector] replaceScene: hsScene];
}

@end
