//
//  SPGameVibration.m
//  Miracle Mine
//
//  Created by 深谷 哲史 on 11/12/20.
//  Copyright (c) 2011 Keio University. All rights reserved.
//

#import "BGGameVibrator.h"

@implementation BGGameVibrator

+ (void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
