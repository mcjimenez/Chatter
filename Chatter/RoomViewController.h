//
//  RoomViewController.h
//  chatter
//
//  Created by cjc on 14/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#ifndef ROOMVIEWCONTROLLER_H
#define  ROOMVIEWCONTROLLER_H

#import <UIKit/UIKit.h>
#import <OpenTok/OpenTok.h>

#define SPEAKER_IMG @"speaker"
#define MIC_IMG @"mic"
#define CAMERA_IMG @"camera"

#define IMG_OFF @"Off"

#define CAMERA_SWAP_IMG @"cameraSwap"
#define CAMERA_SWAP_BACK_IMG @"cameraSwapBack"


@interface RoomViewController : UIViewController
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *userId;
//@property (strong, nonatomic) NSString *apiKey;
//@property (strong, nonatomic) NSString *sessionId;
//@property (strong, nonatomic) NSString *token;
@end

#endif