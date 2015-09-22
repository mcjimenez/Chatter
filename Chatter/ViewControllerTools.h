//
//  ViewControllerTools.h
//  chatter
//
//  Created by cjc on 21/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIButton;
@class UITextField;

@interface ViewControllerTools : NSObject

+ (instancetype)getShadow;

- (void)setButtonAspect:(UIButton*)btn;
- (void)configTxtField:(UITextField *)txtField withPlaceHolder:(NSString *)txt andDelegate:(id)delegate;
- (void)configTxtField:(UITextField *)txtField withDelegate:(id)delegate;

@end
