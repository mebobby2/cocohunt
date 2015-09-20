//
//  AudioManager.h
//  CocoHunt
//
//  Created by Bobby Lei on 21/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject
-(void)playSoundEffect:(NSString*)soundFile;
+(instancetype)sharedAudioManager;
@end
