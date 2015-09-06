#import "GameScene.h"
#import "cocos2d.h"

@implementation GameScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
    }
    
    return self;
}

-(void)addBackground {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CCSprite *background = [CCSprite spriteWithImageNamed:@"game_scene_bg.png"];
    
    background.position  = ccp(viewSize.width * 0.5f, viewSize.height * 0.5f);
    [self addChild:background];
}

@end
