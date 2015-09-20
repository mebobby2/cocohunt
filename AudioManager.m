//
//  AudioManager.m
//  CocoHunt
//
//  Created by Bobby Lei on 21/09/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

-(void)playSoundEffect:(NSString *)soundFile {
    [[OALSimpleAudio sharedInstance] playEffect:soundFile];
}

+(AudioManager*)sharedAudioManager {
    static dispatch_once_t pred;
    static AudioManager * _sharedInstance;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
