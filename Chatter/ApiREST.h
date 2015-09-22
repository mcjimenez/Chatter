//
//  ApiREST.h
//  chatter
//
//  Created by cjc on 14/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//
#ifndef APIREST_H
#define APIREST_H

#import <Foundation/Foundation.h>

#define SESSION_NAME @"session.name"
#define SESSION_TOKEN @"session.token"
#define SESSION_ID @"session.id"
#define SESSION_API_KEY @"apiKey"

@interface ApiREST : NSObject

+ (NSDictionary *)getSessionData:(NSString *)sessionName;

@end

#endif
