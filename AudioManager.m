//
//  AudioManager.m
//  CocoHunt
//
//  Created by Bobby Lei on 21/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AudioManager.h"

@interface AudioManager()

@property (strong) NSArray *musicFiles;
@property (strong) OALAudioTrack *currentTrack;
@property (strong) OALAudioTrack *nextTrack;
@property (strong) NSArray* soundEffects;

@end

@implementation AudioManager

-(instancetype)init {
    if (self = [super init]) {
        self.musicFiles = @[@"track_0.mp3", @"track_1.mp3", @"track_2.mp3", @"track_3.mp3", @"track_4.mp3", @"track_5.mp3"];
        self.currentTrack = nil;
        self.nextTrack = nil;
        self.soundEffects = @[kSoundArrowShot, kSoundBirdHit, kSoundArrowLose, kSoundWin];
        
        _isSoundEnabled = YES;
        _isSoundEnabled = YES;
    }
    return self;
}

-(void)preloadSoundEffects {
    for (NSString *sound in self.soundEffects) {
        [[OALSimpleAudio sharedInstance] preloadEffect:sound reduceToMono:NO completionBlock:^(ALBuffer *b) {
            NSLog(@"Sound %@ Preloaded", sound);
        }];
    }
}

-(void)toggleMusic {
    _isMusicEnabled = !_isMusicEnabled;
    if (!_isMusicEnabled && self.currentTrack) {
        [self stopMusic];
    }
}

-(void)toggleSound {
    _isSoundEnabled = !_isSoundEnabled;
}

-(void)playMusic {
    if (!_isMusicEnabled)
        return;
    
    if (self.currentTrack) {
        NSLog(@"The music is already playing");
        return;
    }
    
    int startTrackIndex = arc4random() % self.musicFiles.count;
    int nextTrackIndex = arc4random() % self.musicFiles.count;
    NSString *startTrack = [self.musicFiles objectAtIndex:startTrackIndex];
    NSString* nextTrack = [self.musicFiles objectAtIndex:nextTrackIndex];
    
    self.currentTrack = [OALAudioTrack track];
    self.currentTrack.delegate = self;
    [self.currentTrack preloadFile:startTrack];
    [self.currentTrack play];
    
    self.nextTrack = [OALAudioTrack track];
    [self.nextTrack preloadFile:nextTrack];
}

-(void)stopMusic {
    if (!self.currentTrack) {
        NSLog(@"The music is already stopped");
        return;
    }
    
    [self.currentTrack stop];
    self.currentTrack = nil;
    self.nextTrack = nil;
}

-(void)playNextTrack {
    if (!self.currentTrack)
        return;
    
    self.currentTrack = self.nextTrack;
    self.currentTrack.delegate = self;
    [self.currentTrack play];
    
    int nextTrackIndex = arc4random() % self.musicFiles.count;
    NSString *nextTrack = [self.musicFiles objectAtIndex:nextTrackIndex];
    
    self.nextTrack = [OALAudioTrack track];
    [self.nextTrack preloadFile:nextTrack];
}

-(void)playSoundEffect:(NSString *)soundFile {
    if (!_isSoundEnabled)
        return;
    
    [[OALSimpleAudio sharedInstance] playEffect:soundFile];
}

-(void)playSoundEffect:(NSString *)soundFile withPosition:(CGPoint)pos {
    if (!_isSoundEnabled)
        return;
    
    float pan = pos.x / [CCDirector sharedDirector].viewSize.width;
    pan = clampf(pan, 0.0f, 1.0f);
    pan = pan * 2.0f - 1.0f;
    
    [[OALSimpleAudio sharedInstance] playEffect:soundFile volume:1.0 pitch:1.0 pan:pan loop:NO];
}

-(void)playBackgroundSound:(NSString *)soundFile {
    [[OALSimpleAudio sharedInstance] playBg:soundFile loop:YES];
}

+(AudioManager*)sharedAudioManager {
    static dispatch_once_t pred;
    static AudioManager * _sharedInstance;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playNextTrack];
    });
}

@end
