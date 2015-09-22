//
//  Config.h
//  chatter
//
//  Created by cjc on 15/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *server;
@property (nonatomic, getter=isPubVideoON) BOOL pubVideoON;
@property (nonatomic, getter=isSubVideoON) BOOL subVideoON;
@property (nonatomic, getter=isCameraFront) BOOL cameraFront;

@property (nonatomic, getter=isMicON) BOOL micON;
@property (nonatomic, getter=isSpeakerON) BOOL speakerON;


//TODO Recover data from config file!!!
+ (instancetype)getConfig;

@end
