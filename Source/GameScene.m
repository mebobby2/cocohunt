#import "GameScene.h"
#import "Hunter.h"

@interface GameScene()

@property (nonatomic) Hunter *hunter;

@end

@implementation GameScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
        [self addHunter];
    }
    
    return self;
}

-(void)addBackground {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CCSprite *background = [CCSprite spriteWithImageNamed:@"game_scene_bg.png"];
    background.position  = ccp(viewSize.width * 0.5f, viewSize.height * 0.5f);
    background.scaleX = viewSize.width / [background boundingBox].size.width;
    background.scaleY = viewSize.height / [background boundingBox].size.height;
    [self addChild:background];
}

-(void)addHunter {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    self.hunter = [[Hunter alloc] init];
    float hunterPositionX = viewSize.width * 0.5f - 210.0f;
    float hunterPositionY = viewSize.height * 0.3f;
    
    self.hunter.position = ccp(hunterPositionX, hunterPositionY);
    [self addChild:self.hunter];
}

@end
