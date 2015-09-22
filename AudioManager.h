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
@property (nonatomic, readonly) BOOL isSoundEnabled;
@property (nonatomic, readonly) BOOL isMusicEnabled;
-(void)playSoundEffect:(NSString*)soundFile;
-(void)playSoundEffect:(NSString *)soundFile withPosition:(CGPoint)pos;
-(void)playBackgroundSound:(NSString*)soundFile;
-(void)playMusic;
-(void)stopMusic;
-(void)preloadSoundEffects;
-(void)toggleSound;
-(void)toggleMusic;
+(instancetype)sharedAudioManager;
@end
