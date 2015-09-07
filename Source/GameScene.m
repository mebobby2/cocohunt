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
        self.userInteractionEnabled = YES;
        [self addBackground];
        [self loadSpriteSheet];
        [self addHunter];
        [self addBird];
    }
    
    return self;
}

-(void)loadSpriteSheet {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
}

-(void)update:(CCTime)delta {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    if (self.bird.position.x < 0) {
        self.bird.flipX = YES;
    }
    
    if (self.bird.position.x > viewSize.width) {
        self.bird.flipX = NO;
    }
    
    float birdSpeed = 50;
    float distanceToMove = birdSpeed * delta;
    
    float direction = self.bird.flipX ? 1 : -1;
    
    float newX = self.bird.position.x + direction * distanceToMove;
    float newY = self.bird.position.y;
    
    self.bird.position = ccp(newX, newY);
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self.hunter aimAtPoint:touchLocation];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self.hunter aimAtPoint:touchLocation];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"finger up at : (%f, %f)", touch.locationInWorld.x, touch.locationInWorld.y);
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
