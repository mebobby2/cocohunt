//
//  Bird.m
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Bird.h"

@implementation Bird

-(instancetype)initWithBirdType:(BirdType)typeOfBird {
    NSString *birdImageName;
    
    switch (typeOfBird) {
        case BirdTypeBig:
            birdImageName = @"bird_big.png";
            break;
        case BirdTypeMedium:
            birdImageName = @"bird_middle.png";
            break;
        case BirdTypeSmall:
            birdImageName = @"bird_small.png";
            break;
        default:
            CCLOG(@"Unknown bird type, using small bird!");
            birdImageName = @"bird_small.png";
            break;
    }
    
    if (self = [super initWithImageNamed:birdImageName]) {
        self.birdType = typeOfBird;
    }
    return self;
}

@end
