//
//  PhysicsBird.h
//  CocoHunt
//
//  Created by Bobby Lei on 31/10/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Bird.h"

@interface PhysicsBird : Bird

@property (nonatomic, weak) CCSprite *stoneToDrop;

-(void)flyAndDropStoneAt:(CGPoint)point stone:(CCSprite*)stone;

@end
