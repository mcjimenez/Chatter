//
//  ViewControllerTools.m
//  chatter
//
//  Created by cjc on 21/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "ViewControllerTools.h"
#import <UIKit/UIKit.h>

@implementation ViewControllerTools

+ (instancetype)getShadow {
    static ViewControllerTools *vct;
    if (!vct) {
        vct = [[self alloc] initPrivate];
    }
    return vct;
}

- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use +[ViewControllerTools getShadow]"];
    return nil;
}

- (instancetype)initPrivate {
    self =[super init];
    return self;
}

- (void)setButtonAspect:(UIButton*)btn {
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    btn.layer.masksToBounds = NO;
    btn.layer.shadowRadius = 3.0f;
    btn.layer.shadowOpacity = 1.0;
    btn.layer.cornerRadius = 3.0f;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0.0705882 green:0.529412 blue:0.752941 alpha:1];
}

- (void)configTxtField:(UITextField *)txtField withDelegate:(id)delegate{
    txtField.returnKeyType = UIReturnKeyDone;
    txtField.enablesReturnKeyAutomatically = YES;
    txtField.delegate = delegate;
}

- (void)configTxtField:(UITextField *)txtField withPlaceHolder:(NSString *)txt andDelegate:(id)delegate {
    [self configTxtField:txtField withDelegate:delegate];
    txtField.placeholder = txt;
}
@end
