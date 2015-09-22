//
//  Config.m
//  chatter
//
//  Created by cjc on 15/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "Config.h"

#warning esto va todo a preferencias!!!!!

@implementation Config

@synthesize name = _name;
@synthesize server = _server;

+ (instancetype)getConfig {
    static Config *config;
    if (!config) {
        config = [[self alloc] initPrivate];
    }
    return config;
}

- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use +[Config getConfig]"];
    return nil;
}

- (instancetype)initPrivate {
    self =[super init];
    return self;
}

- (NSString *)server {
    if (!_server) {
        _server =  @"http://192.168.2.50:8080/";
    }
    return _server;
}

- (void)setServer:(NSString *)server {
    _server = server;
    NSLog(@"Puesto server:%@", server);
    
}

- (NSString *)name {
    if (!_name) {
        _name = @"";
    }
    return _name;
}

- (void)setName:(NSString *)name {
    NSLog(@"Setter name!!!");
    _name = name;
    NSLog(@"Puesto nombre:%@", name);
}

- (BOOL)isPubVideoON {

    return _pubVideoON;
}

- (BOOL)isSubVideoON {
    return _subVideoON;
}

- (BOOL)isCameraFront {
    return _cameraFront;
}

- (BOOL)isMicON {
    return _micON;
}

- (BOOL)isSpeakerON {
    return _speakerON;
}

@end
