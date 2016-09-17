//
//  WinLoseDialog.m
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "WinLoseDialog.h"

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MenuScene.h"
#import "LoadingScene.h"

#define kKeyFont            @"HelveticaNeue"
#define kKeyFontSize        12
#define kKeyX               0.2f

#define kValueFont          @"HelveticaNeue-Bold"
#define kValueFontSize      12
#define kValueX             0.8f

#define kLine1Y             0.7f
#define kMarginBetweenLines 0.08f

@implementation WinLoseDialog

GameStats * _currentStats;

-(instancetype)initWithGameStats:(GameStats *)stats {
    if (self = [super init]) {
        _currentStats = stats;
        [self setupModalDialog];
        [self createDialogLayout];
    }
    
    return self;
}

-(void)setupModalDialog {
    self.contentSizeType = CCSizeTypeNormalized;
    self.contentSize = CGSizeMake(1,1);
    self.userInteractionEnabled = YES;
}

-(void)createDialogLayout {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"win_lose_dialog_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    [self addChild:bg];
    
    NSDictionary *stats = @{ @"Score" : [NSString stringWithFormat:@"%d", _currentStats.score],
                             @"Lives Left" : [NSString stringWithFormat:@"%d", _currentStats.lives],
                             @"Time Spent" : [NSString stringWithFormat:@"%.1f s", _currentStats.timeSpent],
                             };
    
    float margin = 0;
    CCColor *fontColor = [CCColor orangeColor];
    
    for (NSString *key in stats.allKeys) {
        CCLabelTTF *lblKey = [CCLabelTTF labelWithString:key fontName:kKeyFont fontSize:kKeyFontSize];
        lblKey.color = fontColor;
        lblKey.anchorPoint = ccp(0.0f, 0.5f);
        lblKey.positionType = CCPositionTypeNormalized;
        lblKey.position = ccp(kKeyX, kLine1Y - margin);
        [bg addChild:lblKey];
        
        CCLabelTTF *lblValue = [CCLabelTTF labelWithString:[stats objectForKey:key] fontName:kValueFont fontSize:kValueFontSize];
        lblValue.color = fontColor;
        lblValue.anchorPoint = ccp(1.0f, 0.5f);
        lblValue.positionType = CCPositionTypeNormalized;
        lblValue.position = ccp(kValueX, kLine1Y - margin);
        [bg addChild:lblValue];
        
        margin += kMarginBetweenLines;
    }
    
    CCSpriteFrame *restartNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_restart.png"];
    CCSpriteFrame *restartHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_restart_pressed.png"];
    CCButton *btnRestart = [CCButton buttonWithTitle:nil spriteFrame:restartNormalImage highlightedSpriteFrame:restartHighlightedImage disabledSpriteFrame:nil];
    btnRestart.positionType = CCPositionTypeNormalized;
    btnRestart.position = ccp(0.25f,0.2f);
    [btnRestart setTarget:self selector:@selector(btnRestartTapped:)];
    [bg addChild:btnRestart];
    
    CCSpriteFrame *exitNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_exit.png"];
    CCSpriteFrame *exitHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_exit_pressed.png"];
    CCButton *btnExit = [CCButton buttonWithTitle:nil spriteFrame:exitNormalImage highlightedSpriteFrame:exitHighlightedImage disabledSpriteFrame:nil];
    btnExit.positionType = CCPositionTypeNormalized;
    btnExit.position = ccp(0.75f,0.2f);
    [btnExit setTarget:self selector:@selector(btnExitTapped:)];
    [bg addChild:btnExit];
}

-(void)btnRestartTapped:(id)sender {
    LoadingScene *loadingScene = [[LoadingScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:loadingScene];
}

-(void)btnExitTapped:(id)sender {
    MenuScene *menuScene = [[MenuScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:menuScene];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    //do nothing, swallow touch
}

@end
