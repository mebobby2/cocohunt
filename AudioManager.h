//
//  AudioManager.h
//  CocoHunt
//
//  Created by Bobby Lei on 21/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVAudioPlayer;

@interface AudioManager : NSObject <AVAudioPlayerDelegate>
-(void)playSoundEffect:(NSString*)soundFile;
-(void)playBackgroundSound:(NSString*)soundFile;
-(void)playMusic;
-(void)stopMusic;
+(instancetype)sharedAudioManager;
@end
