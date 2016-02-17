//
//  AudioTool.h
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioTool : NSObject

+ (NSDictionary *)metadataForFile:(AudioFileID)audioFile;

@end
