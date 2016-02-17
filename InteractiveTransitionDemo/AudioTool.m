//
//  AudioTool.m
//  InteractiveTransitionDemo
//
//  Created by Jerry on 16/2/3.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool

+ (NSDictionary *)metadataForFile:(AudioFileID)audioFile {
    NSMutableDictionary *result = nil;
    UInt32 dataSize = 0;
    OSStatus err;
    
    err = AudioFileGetPropertyInfo(audioFile,
                                   kAudioFilePropertyInfoDictionary,
                                   &dataSize,
                                   0);
    
    if (err != noErr) return result;
    
    err = AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dataSize, &result);
    if (err != noErr) return result;
    
    err = AudioFileGetPropertyInfo(audioFile,
                                   kAudioFilePropertyAlbumArtwork,
                                   &dataSize,
                                   0);
    NSData *image;
    if (err == noErr) {
        AudioFileGetProperty(audioFile,
                             kAudioFilePropertyAlbumArtwork,
                             &dataSize,
                             &image);
        if (image) {
            [result setObject:image forKey:@"picture"];
        }
        
    } else if ((image = [self imageDataFromID3Tag:audioFile])) {
        [result setObject:image forKey:@"picture"];
    }
    
    return result;
}

+ (NSData *)imageDataFromID3Tag:(AudioFileID)audioFile {
    
    OSStatus err;
    
    UInt32 propertySize = 0;
    AudioFileGetPropertyInfo(audioFile,
                             kAudioFilePropertyID3Tag,
                             &propertySize,
                             0);
    
    char *rawID3Tag = (char *)malloc(propertySize);
    err = AudioFileGetProperty(audioFile,
                               kAudioFilePropertyID3Tag,
                               &propertySize,
                               rawID3Tag);
    
    if (err != noErr) {
        free(rawID3Tag);
        return nil;
    }
    
    UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = sizeof(id3TagSize);
    AudioFormatGetProperty(kAudioFormatProperty_ID3TagSize,
                           propertySize,
                           rawID3Tag,
                           &id3TagSizeLength,
                           &id3TagSize);
    
    CFDictionaryRef id3Dict;
    AudioFormatGetProperty(kAudioFormatProperty_ID3TagToDictionary,
                           propertySize,
                           rawID3Tag,
                           &id3TagSize,
                           &id3Dict);
    
    NSDictionary *tagDict = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)id3Dict];
    free(rawID3Tag);
    CFRelease(id3Dict);
    
    NSDictionary *apicDict = tagDict[@"APIC"];
    if (!apicDict) return nil;
    
    NSString *picKey      = [[apicDict allKeys] lastObject];
    NSDictionary *picDict = apicDict[picKey];
    if (!picDict) return nil;
    
    return picDict[@"data"];
}


@end
