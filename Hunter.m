//
//  Hunter.m
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Hunter.h"

@interface Hunter()

@property (nonatomic) CCSprite *torso;

@end

@implementation Hunter

-(instancetype)init {
    if (self = [super initWithImageNamed:@"hunter_bottom.png"]) {
        self.torso = [CCSprite spriteWithImageNamed:@"hunter_top.png"];
        self.torso.anchorPoint = ccp(0.5f, 10.0f/44.0f);
        self.torso.position = ccp(self.boundingBox.size.width / 2.0f, self.boundingBox.size.height);
        [self addChild:self.torso z:-1];
    }
    
    return self;
}


@end
