//
//  AudioManager.h
//  CocoHunt
//
//  Created by Bobby Lei on 21/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVAudioPlayer;

#define kSoundArrowShot @"arrow_shot.wav"
#define kSoundBirdHit @"bird_hit.mp3"
#define kSoundWin @"win.wav"
#define kSoundArrowLose @"lose.wav"


@interface AudioManager : NSObject <AVAudioPlayerDelegate>
-(void)playSoundEffect:(NSString*)soundFile;
-(void)playBackgroundSound:(NSString*)soundFile;
-(void)playMusic;
-(void)stopMusic;
-(void)preloadSoundEffects;
+(instancetype)sharedAudioManager;
@end
