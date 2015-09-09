//
//  HUDLayer.m
//  CocoHunt
//
//  Created by Bobby Lei on 10/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HUDLayer.h"

#define kFontName @"Noteworthy-Bold"
#define kFontSize 14

@interface HUDLayer()

@property CCLabelTTF *score;
@property CCLabelTTF *birdsLeft;
@property CCLabelTTF *lives;

@end

@implementation HUDLayer

-(instancetype)init {
    if (self = [super init]) {
        self.score = [CCLabelTTF labelWithString:@"Score: 99999" fontName:kFontName fontSize:kFontSize];
        self.birdsLeft = [CCLabelTTF labelWithString:@"Birds Left: 99" fontName:kFontName fontSize:kFontSize];
        self.lives = [CCLabelTTF labelWithString:@"Lives: 99" fontName:kFontName fontSize:kFontSize];
        
        self.score.color = [CCColor colorWithRed:0 green:0.42f blue:0.03f];
        self.birdsLeft.color = [CCColor colorWithRed:0.84f green:0.49f blue:0.08f];
        self.lives.color = [CCColor colorWithRed:0.64f green:0.06f blue:0.06f];
        
        CGSize viewSize = [CCDirector sharedDirector].viewSize;
        float labelsY = viewSize.height * 0.95f;
        float labelsPaddingX = viewSize.width * 0.01f;
        
        self.score.anchorPoint = ccp(0, 0.5f);
        self.score.position = ccp(labelsPaddingX, labelsY);
        
        self.birdsLeft.anchorPoint = ccp(0.5f, 0.5f);
        self.birdsLeft.position = ccp(viewSize.width * 0.5f, labelsY);
        
        self.lives.anchorPoint = ccp(1, 0.5f);
        self.lives.position = ccp(viewSize.width - labelsPaddingX, labelsY);
        
        [self addChild:self.score];
        [self addChild:self.birdsLeft];
        [self addChild:self.lives];
    }
    return self;
}

-(void)updateStats:(GameStats *)stats {
    self.score.string = [NSString stringWithFormat:@"Score: %d", stats.score];
    self.birdsLeft.string = [NSString stringWithFormat:@"Birds Left: %d", stats.birdsLeft];
    self.lives.string = [NSString stringWithFormat:@"Lives: %d", stats.lives];
}

@end
