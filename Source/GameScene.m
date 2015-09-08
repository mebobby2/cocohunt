#import "GameScene.h"
#import "Hunter.h"
#import "Bird.h"

@interface GameScene()

@property (nonatomic) Hunter *hunter;
@property (nonatomic) float timeUntilNextBird;
@property (nonatomic) NSMutableArray *birds;

@end

@implementation GameScene

-(instancetype)init {
    if (self = [super init]) {
        [self loadSpriteSheet];
        [self addBackground];
        [self addHunter];
        self.timeUntilNextBird = 0;
        self.birds = [NSMutableArray array];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)loadSpriteSheet {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
}

-(void)update:(CCTime)delta {
    self.timeUntilNextBird -= delta;
    
    if (self.timeUntilNextBird <= 0) {
        [self spawnBird];
        
        int nextBirdTimeMax = 5;
        int nextBirdTimeMin = 2;
        int nextBirdTime = nextBirdTimeMin + arc4random_uniform(nextBirdTimeMax - nextBirdTimeMin);
        self.timeUntilNextBird = nextBirdTime;
    }
}

-(void)spawnBird {
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    
    int maxY = viewSize.height * 0.9f;
    int minY = viewSize.height * 0.6f;
    int birdY = minY + arc4random_uniform(maxY - minY);
    int birdX = viewSize.width * 1.3f;
    CGPoint birdStart = ccp(birdX, birdY);
    
    BirdType birdType = (BirdType)(arc4random_uniform(3));
    
    Bird *bird = [[Bird alloc] initWithBirdType:birdType];
    bird.position = birdStart;
    
    [self addChild:bird];
    
    [self.birds addObject:bird];
    
    int maxTime = 20;
    int minTime = 10;
    int birdTime = minTime + (arc4random() % (maxTime - minTime));
    
    CGPoint screenLeft = ccp(0, birdY);
    
    CCActionMoveTo *moveToLeftEdge = [CCActionMoveTo actionWithDuration:birdTime position:screenLeft];
    CCActionFlipX * turnaround = [CCActionFlipX actionWithFlipX:YES];
    CCActionMoveTo *moveBackOffScreen = [CCActionMoveTo actionWithDuration:birdTime position:birdStart];
    
    CCActionSequence *moveLeftThenBack = [CCActionSequence actions:moveToLeftEdge, turnaround, moveBackOffScreen, nil];
    
    [bird runAction:moveLeftThenBack];
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
    CGPoint touchLocation = [touch locationInNode:self];
    [self.hunter shootAtPoint:touchLocation];
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
