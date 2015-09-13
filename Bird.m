//
//  Bird.m
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Bird.h"

@interface Bird()

@property (nonatomic, assign) int timesToVisit;

@end

@implementation Bird

-(instancetype)initWithBirdType:(BirdType)typeOfBird {
    NSString *birdImageName;
    
    switch (typeOfBird) {
        case BirdTypeBig:
            birdImageName = @"bird_big_0.png";
            break;
        case BirdTypeMedium:
            birdImageName = @"bird_middle_0.png";
            break;
        case BirdTypeSmall:
            birdImageName = @"bird_small_0.png";
            break;
        default:
            CCLOG(@"Unknown bird type, using small bird!");
            birdImageName = @"bird_small_0.png";
            break;
    }
    
    if (self = [super initWithImageNamed:birdImageName]) {
        self.birdType = typeOfBird;
        self.timesToVisit = 3;
        self.birdState = BirdStateFlyingIn;
        [self animateFly];
    }
    return self;
}

-(void)animateFly {
    NSString* animFrameNameFormat;
    
    switch (self.birdType) {
        case BirdTypeBig:
            animFrameNameFormat = @"bird_big_%d.png";
            break;
        case BirdTypeMedium:
            animFrameNameFormat = @"bird_middle_%d.png";
            break;
        case BirdTypeSmall:
            animFrameNameFormat = @"bird_small_%d.png";
        default:
            CCLOG(@"Unknown bird type, using small bird anim.!");
            animFrameNameFormat = @"bird_small_%d.png";
            break;
    }
    
    NSMutableArray *animFrames = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        NSString *currentFrameName = [NSString stringWithFormat:animFrameNameFormat, i];
        
        CCSpriteFrame *animationFrame = [CCSpriteFrame frameWithImageNamed:currentFrameName];
        
        [animFrames addObject:animationFrame];
    }
    
    CCAnimation* flyAnimation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.1f];
    
    CCActionAnimate *flyAnimateAction = [CCActionAnimate actionWithAnimation:flyAnimation];
    
    CCActionRepeatForever *flyForever = [CCActionRepeatForever actionWithAction:flyAnimateAction];
    
    [self runAction:flyForever];
}

-(void)animateFall {
    CGPoint fallDownOffScreenPoint = ccp(self.position.x, -self.boundingBox.size.height);
    CCActionMoveTo *fallOffScreen = [CCActionMoveTo actionWithDuration:2.0f position:fallDownOffScreenPoint];
    CCActionRemove *removeWhenDone = [CCActionRemove action];
    CCActionSequence *fallSequence = [CCActionSequence actions:fallOffScreen, removeWhenDone, nil];
    [self runAction:fallSequence];
    
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:0.1 angle:60];
    CCActionRepeatForever *rotateForever = [CCActionRepeatForever actionWithAction:rotate];
    [self runAction:rotateForever];
}

-(void)explodeFeathers {
    int totalNumberOfFeathers = 100;
    CCParticleSystem * explosion = [CCParticleSystem particleWithTotalParticles:totalNumberOfFeathers];
    
    explosion.position = self.position;
    explosion.emitterMode = CCParticleSystemModeGravity;
    
    explosion.gravity = ccp(0, -200.0f);
    
    explosion.duration = 0.1f;
    
    explosion.emissionRate = totalNumberOfFeathers/explosion.duration;
    
    explosion.texture = [CCTexture textureWithFile:@"feather.png"];
    
    explosion.startColor = [CCColor whiteColor];
    explosion.endColor = [[CCColor whiteColor] colorWithAlphaComponent:0.0f];
    
    explosion.life = 0.25f;
    explosion.lifeVar = 0.75f;
    explosion.speed = 60;
    explosion.speedVar = 80;
    
    explosion.startSize = 16;
    explosion.startSizeVar = 4;
    explosion.endSize = CCParticleSystemStartSizeEqualToEndSize;
    explosion.endSizeVar = 8;
    
    explosion.angleVar = 360;
    explosion.startSpinVar = 360;
    explosion.endSpinVar = 360;
    
    explosion.autoRemoveOnFinish = YES;
    
    ccBlendFunc blendFunc;
    blendFunc.src = GL_SRC_ALPHA;
    blendFunc.dst = GL_ONE;
    explosion.blendFunc = blendFunc;
    
    CCNode* scene = self.parent;
    [scene addChild:explosion];
}

-(int)removeBird:(BOOL)hitByArrow {
    [self stopAllActions];
    
    int score = 0;
    
    if (hitByArrow) {
        self.birdState = BirdStateDead;
        score = (self.timesToVisit + 1) * 5;
        [self displayPoints:score];
        [self animateFall];
        [self explodeFeathers];
    } else {
        self.birdState = BirdStateFlewOut;
         [self removeFromParentAndCleanup:YES];
    }
    
    return score;
}

-(void)turnaround {
    self.flipX = !self.flipX;
    
    if (self.flipX)
        self.timesToVisit--;
    
    if (self.timesToVisit <= 0) {
        self.birdState = BirdStateFlyingOut;
    }
}

-(void)displayPoints:(int)amount {
    NSString *ptsStr = [NSString stringWithFormat:@"%d", amount];
    CCLabelBMFont *ptsLabel = [CCLabelBMFont labelWithString:ptsStr fntFile:@"points.fnt"];
    ptsLabel.position = self.position;
    
    CCNode *scene = self.parent;
    [scene addChild:ptsLabel];
    
    float xDelta1 = 10;
    float yDelta1 = 5;
    float yDelta2 = 10;
    float yDelta4 = 20;
    ccBezierConfig curve;
    curve.controlPoint_1 = ccp(ptsLabel.position.x - xDelta1, ptsLabel.position.y + yDelta1);
    curve.controlPoint_2 = ccp(ptsLabel.position.x + xDelta1, ptsLabel.position.y + yDelta2);
    curve.endPosition = ccp(ptsLabel.position.x, ptsLabel.position.y + yDelta4);
    
    float baseDuratin = 1.0f;
    
    CCActionBezierTo *bezierMove = [CCActionBezierTo actionWithDuration:baseDuratin bezier:curve];
    
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:baseDuratin * 0.25f];
    
    CCActionDelay * delay = [CCActionDelay actionWithDuration:baseDuratin * 0.75f];
    
    CCActionSequence *delayAndFade = [CCActionSequence actions:delay, fadeOut, nil];
    
    CCActionSpawn *bezieAndFaout = [CCActionSpawn actions:bezierMove, delayAndFade, nil];
    
    CCActionRemove *removeInTheEnd = [CCActionRemove action];
    
    CCActionSequence *actions = [CCActionSequence actions:bezieAndFaout, removeInTheEnd, nil];
    
    [ptsLabel runAction:actions];
}

@end
