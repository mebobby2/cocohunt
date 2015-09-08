#import "GameScene.h"
#import "Hunter.h"
#import "Bird.h"
@import CoreMotion;

@interface GameScene()

@property Hunter *hunter;
@property float timeUntilNextBird;
@property NSMutableArray *birds;
@property NSMutableArray *arrows;
@property int birdsToSpawn;
@property int birdsToLose;
@property int maxAimingRadius;
@property CCSprite* aimingIndicator;

@property BOOL useGyroToAim;
@property CMMotionManager *motionManager;

@end

@implementation GameScene

-(instancetype)init {
    if (self = [super init]) {
        self.useGyroToAim = NO;
        [self loadSpriteSheet];
        [self addBackground];
        [self addHunter];
        self.timeUntilNextBird = 0;
        self.birds = [NSMutableArray array];
        self.arrows = [NSMutableArray array];
        self.gameState = GameStateUninitialized;
        self.birdsToSpawn = 20;
        self.birdsToLose = 3;
        [self setupAimingIndicator];
    }
    
    return self;
}

-(void)initializeControls {
    if (self.useGyroToAim) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 1.0/60;
        [self.motionManager startDeviceMotionUpdates];
    }
    self.userInteractionEnabled = YES;
}

-(CGPoint)getGyroTargetPoint {
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    CMAttitude *attitude = motion.attitude;
    
    float pitch = attitude.pitch;
    float roll = attitude.roll;
    
    if (roll > 0)
        pitch = -1 * pitch;
    
    CCLOG(@"Pitch: %F", pitch);
    
    CGPoint forward = ccp(1.0, 0);
    CGPoint rot = ccpRotateByAngle(forward, CGPointZero, pitch);
    CGPoint targetPoint = ccpAdd([self.hunter torsoCenterInWorldCoordinates], rot);
    return targetPoint;
}

-(void)updateGyroAim {
    if (!self.useGyroToAim)
        return;
    
    CGPoint targetPoint = [self getGyroTargetPoint];
    [self.hunter aimAtPoint:targetPoint];
}

-(void)onEnter {
    [super onEnter];
    self.gameState = GameStatePlaying;
    [self initializeControls];
}

-(void)loadSpriteSheet {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Cocohunt.plist"];
}

-(void)setupAimingIndicator {
    self.maxAimingRadius = 100;
    
    self.aimingIndicator = [CCSprite spriteWithImageNamed:@"power_meter.png"];
    self.aimingIndicator.opacity = 0.3f;
    self.aimingIndicator.anchorPoint = ccp(0, 0.5f);
    self.aimingIndicator.visible = NO;
    
    [self addChild:self.aimingIndicator];
}

-(void)update:(CCTime)delta {
    if (self.gameState != GameStatePlaying)
        return;
    
    [self updateGyroAim];
    
    self.timeUntilNextBird -= delta;
    
    if (self.timeUntilNextBird <= 0 && self.birdsToSpawn > 0) {
        [self spawnBird];
        self.birdsToSpawn--;
        
        int nextBirdTimeMax = 5;
        int nextBirdTimeMin = 2;
        int nextBirdTime = nextBirdTimeMin + arc4random_uniform(nextBirdTimeMax - nextBirdTimeMin);
        self.timeUntilNextBird = nextBirdTime;
    }
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CGRect viewBounds = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    //We iterate the array backgrounds as we might need to remove the birds from the array as we go, which will change the size of the array
    for (int i = self.birds.count - 1; i >= 0; i --) {
        Bird * bird = self.birds[i];
        BOOL birdFlewOffScreen = (bird.position.x + (bird.contentSize.width * 0.5f)) > viewSize.width;
        
        if (bird.birdState == BirdStateFlyingOut && birdFlewOffScreen) {
            [self.birds removeObject:bird];
            [bird removeBird:NO];
            self.birdsToLose--;
            continue;
        }
        
        for (int j = self.arrows.count - 1; j >= 0; j--) {
            CCSprite* arrow = self.arrows[j];
            if (!CGRectContainsPoint(viewBounds, arrow.position)) {
                [arrow removeFromParentAndCleanup:YES];
                [self.arrows removeObject:arrow];
                continue;
            }
            
            if (CGRectIntersectsRect(arrow.boundingBox, bird.boundingBox)) {
                [arrow removeFromParentAndCleanup:YES];
                [self.arrows removeObject:arrow];
                
                [self.birds removeObject:bird];
                [bird removeBird:YES];
                
                break;
            }
        }
        
        [self checkWonLost];
    }
}

-(void)checkWonLost {
    if (self.birdsToLose <= 0) {
        [self lost];
    } else if (self.birdsToSpawn <= 0 && self.birds.count <= 0) {
        [self won];
    }
}

-(void)lost {
    self.gameState = GameStateLost;
    CCLOG(@"YOU LOST!");
}

-(void)won {
    self.gameState = GameStateWon;
    CCLOG(@"YOU WON!");
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
    CCActionFlipX * turnaround = [CCActionCallFunc actionWithTarget:bird selector:@selector(turnaround)];
    CCActionMoveTo *moveBackOffScreen = [CCActionMoveTo actionWithDuration:birdTime position:birdStart];
    
    CCActionSequence *moveLeftThenBack = [CCActionSequence actions:moveToLeftEdge, turnaround, moveBackOffScreen, turnaround, nil];
    
    CCActionRepeatForever *flyForever = [CCActionRepeatForever actionWithAction:moveLeftThenBack];
    
    [bird runAction:flyForever];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (self.gameState != GameStatePlaying) {
        //By calling the super method, it tells cocos2d to pass it to the
        //underlying node because we do not want to process this particular
        //touch. Consequently, the touchMoved and touchEnded methods will
        //NOT be called for this particular touch as well.
        [super touchBegan:touch withEvent:event];
        return;
    }
    
    if (self.useGyroToAim) {
        if (self.hunter.hunterState != HunterStateReloading) {
            CGPoint targetPoint = [self getGyroTargetPoint];
            CCSprite* arrow = [self.hunter shootAtPoint:targetPoint];
            [self.arrows addObject:arrow];
        }
        [super touchBegan:touch withEvent:event];
    } else {
        if (self.hunter.hunterState != HunterStateIdle) {
            [super touchBegan:touch withEvent:event];
            return;
        }
        
        CGPoint touchLocation = [touch locationInNode:self];
        [self.hunter aimAtPoint:touchLocation];
        
        self.aimingIndicator.visible = YES;
        [self checkAimingIndicatorForPoint:touchLocation];
    }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self.hunter aimAtPoint:touchLocation];
    [self checkAimingIndicatorForPoint:touchLocation];
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (self.gameState != GameStatePlaying)
        return;
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    BOOL canShoot = [self checkAimingIndicatorForPoint:touchLocation];
    if (canShoot) {
        CCSprite *arrow = [self.hunter shootAtPoint:touchLocation];
        [self.arrows addObject:arrow];
    } else {
        [self.hunter getReadyToShootAgain];
    }
    self.aimingIndicator.visible = NO;
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self.hunter getReadyToShootAgain];
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

-(BOOL)checkAimingIndicatorForPoint:(CGPoint)point {
    self.aimingIndicator.position = [self.hunter torsoCenterInWorldCoordinates];
    self.aimingIndicator.rotation = [self.hunter torsoRotation];
    
    float distance = ccpDistance(self.aimingIndicator.position, point);
    BOOL isInRange = distance < self.maxAimingRadius;
    
    float scale = distance/self.aimingIndicator.contentSize.width;
    self.aimingIndicator.scale = scale;
    
    self.aimingIndicator.color = isInRange ? [CCColor greenColor] : [CCColor redColor];
    
    return isInRange;
}

@end
