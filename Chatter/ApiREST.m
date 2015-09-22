//
//  ApiREST.m
//  chatter
//
//  Created by cjc on 14/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "ApiREST.h"
#import "Config.h"

/*
NSString * const SESSION_NAME = @"session.name";
NSString * const SESSION_TOKEN = @"session.token";
NSString * const SESSION_ID = @"session.id";
NSString * const SESSION_API_KEY = @"apiKey";
*/
@implementation ApiREST

+ (NSURL *)URLForQuery:(NSString *)query {
    query = [NSString stringWithFormat:@"%@%@", [[Config getConfig] server], query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"query:%@", query);
    return [NSURL URLWithString:query];
}

+ (NSDictionary *)getSessionData:(NSString *)sessionName {
    NSLog(@"getSessionData");    
    if (!sessionName) {
        return nil;
    }
    
    NSString *req = @"token/";

    NSURL *url = [self URLForQuery:[NSString stringWithFormat:@"%@%@", req, sessionName]];
    NSLog(@"url:%@", url.path);
#warning Control de errores!!!!! url invalida, server no contesta...
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                        options:0
                                                                          error:NULL];
    NSLog(@"Results = %@", propertyListResults);
    if ([[propertyListResults valueForKeyPath:SESSION_NAME] isEqualToString: sessionName]) {
        return propertyListResults;
    } else {
        return nil;
    }
}

@end
