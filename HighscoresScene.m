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

#define kHighscoreRowHeight 32
#define kHighscoreFontName @"Helvetica"
#define kHighscoreFontSize 12

@implementation HighscoresScene

-(instancetype)init
{
    if (self = [super init])
    {
        [self addBackground];
        [self addBackButton];
        [self addHighscoresTable];
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

-(void)addHighscoresTable {
    CCTableView *highscoresTable = [[CCTableView alloc] init];
    highscoresTable.rowHeight = kHighscoreRowHeight;
    highscoresTable.anchorPoint = ccp(0.5, 1.0f);
    highscoresTable.positionType = CCPositionTypeNormalized;
    highscoresTable.position = ccp(0.5f, 0.65f);
    highscoresTable.contentSizeType = CCSizeTypeNormalized;
    highscoresTable.contentSize = CGSizeMake(1, 0.4f);
    
    highscoresTable.userInteractionEnabled = NO;
    
    [self addChild:highscoresTable];
    
    highscoresTable.dataSource = self;
}

-(CCTableViewCell*)tableView:(CCTableView *)tableView nodeForRowAtIndex:(NSUInteger)index {
    NSString *playerName = [NSString stringWithFormat:@"Player #%d", index];
    int score = 100 - index;
    
    CCTableViewCell* cell = [[CCTableViewCell alloc] init];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
    cell.contentSize = CGSizeMake(1, kHighscoreRowHeight);
    
    CCSprite *bg = [CCSprite spriteWithImageNamed:@"table_cell_bg.png"];
    bg.positionType = CCPositionTypeNormalized;
    bg.position = ccp(0.5f, 0.5f);
    [cell addChild:bg];
    
    CCLabelTTF *lblPlayerName = [CCLabelTTF labelWithString:playerName fontName:kHighscoreFontName fontSize:kHighscoreFontSize];
    lblPlayerName.positionType = CCPositionTypeNormalized;
    lblPlayerName.position = ccp(0.05f, 0.5f);
    lblPlayerName.anchorPoint = ccp(0, 0.5f);
    [bg addChild:lblPlayerName];
    
    NSString *scoreString = [NSString stringWithFormat:@"%d pts.", score];
    CCLabelTTF *lblScore = [CCLabelTTF labelWithString:scoreString fontName:kHighscoreFontName fontSize:kHighscoreFontSize];
    lblScore.positionType = CCPositionTypeNormalized;
    lblScore.position = ccp(0.95f, 0.5f);
    lblScore.anchorPoint = ccp(1, 0.5f);
    [bg addChild:lblScore];
    
    return cell;
}

-(NSUInteger)tableViewNumberOfRows:(CCTableView *)tableView {
    return 5;
}

@end
