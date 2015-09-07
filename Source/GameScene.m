#import "GameScene.h"
#import "Hunter.h"
#import "Bird.h"

@interface GameScene()

@property (nonatomic) Hunter *hunter;
@property (nonatomic) Bird *bird;

@end

@implementation GameScene

-(instancetype)init {
    if (self = [super init]) {
        [self addBackground];
        [self addHunter];
        [self addBird];
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

-(void)addBird {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    self.bird = [[Bird alloc] initWithBirdType:BirdTypeSmall];
    self.bird.position = ccp(viewSize.width * 0.5f, viewSize.height * 0.9f);
    [self addChild:self.bird];
}

@end
