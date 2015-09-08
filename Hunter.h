//
//  Hunter.h
//  CocoHunt
//
//  Created by Bobby Lei on 7/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Hunter : CCSprite

-(void)aimAtPoint:(CGPoint)point;
-(CCSprite*)shootAtPoint:(CGPoint)point;

@end
