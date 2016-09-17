//
//  PauseDialog.m
//  CocoHunt
//
//  Created by Bobby Lei on 17/9/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "PauseDialog.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "LoadingScene.h"
#import "MenuScene.h"

@implementation PauseDialog

-(instancetype)init
{
    if (self = [super init]) {
        [self setupModalDialog];
        [self createDialogLayout];
    }
    
    return self;
}

-(void)setupModalDialog
{
    self.contentSizeType = CCSizeTypeNormalized;
    self.contentSize = CGSizeMake(1, 1);
    self.userInteractionEnabled = YES;
}

-(void)createDialogLayout {
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"pause_dialog_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    [self addChild:bg];
    
    CCSpriteFrame *closeNormalImage = [CCSpriteFrame frameWithImageNamed:@"btn_close.png"];
    CCSpriteFrame *closeHighlightedImage = [CCSpriteFrame frameWithImageNamed:@"btn_close_pressed.png"];
    CCButton *btnClose = [CCButton buttonWithTitle:nil spriteFrame:closeNormalImage highlightedSpriteFrame:closeHighlightedImage disabledSpriteFrame:nil];
    btnClose.positionType = CCPositionTypeNormalized;
    btnClose.position = ccp(1,1);
    [btnClose setTarget:self selector:@selector(btnCloseTapped:)];
    [bg addChild:btnClose];
    
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

-(void)btnCloseTapped:(id)sender
{
    if (self.onCloseBlock)
        self.onCloseBlock();
    [self removeFromParentAndCleanup:YES];
}

-(void)btnRestartTapped:(id)sender {
    LoadingScene *loadingScene = [[LoadingScene alloc] init];
    //CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.0f];
    [[CCDirector sharedDirector] replaceScene:loadingScene];
}

-(void)btnExitTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit confirmation" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertvView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"sdfsdfsdfsd");
    if (buttonIndex == 1) {
        CCLOG(@"2dsfsdfdsfdsfs221312");
        MenuScene *menuScene = [[MenuScene alloc] init];
        [[CCDirector sharedDirector] replaceScene:menuScene];
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CCLOG(@"Touch swallowed by the pause dialog");
}

@end
