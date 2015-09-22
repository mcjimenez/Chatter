//
//  RoomViewController.m
//  chatter
//
//  Created by cjc on 14/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "RoomViewController.h"
#import "ApiREST.h"
#import "Config.h"

#warning "CONTROL DE ERRORES!!!!!! Servidor no disponible!!!!!!!!!
#warning anda maja, ordena esto un poco

@interface RoomViewController () <OTSessionDelegate, OTPublisherDelegate, OTSubscriberKitDelegate>

@property (weak, nonatomic) IBOutlet UIView *subscriberView;
@property (weak, nonatomic) IBOutlet UIView *publisherView;
@property (weak, nonatomic) IBOutlet UIButton *pubMicBtn;
@property (weak, nonatomic) IBOutlet UIButton *pubCameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *pubIsCameraFrontBtn;

@property (weak, nonatomic) IBOutlet UIButton *subCameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *subAudioBtn;
@property (weak, nonatomic) IBOutlet UILabel *subWaiting;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

#warning poner borde a publisher y redondear esquinas
#warning router session!!!!! meter mas de un subscriber - y relacionado con su gestion

@implementation RoomViewController {
   OTSession *_session;
   OTPublisher *_publisher;
   OTSubscriber *_subscriber;
   NSString *_apiKey;
   NSString *_sessionId;
   NSString *_token;
}

- (IBAction)endCall:(UIButton *)sender {
    OTError *error = nil;
    if (_session.sessionConnectionStatus == OTSessionConnectionStatusConnected ||
        _session.sessionConnectionStatus == OTSessionConnectionStatusConnecting) {
        [_session disconnect:&error];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setButton: (UIButton *)button withValue:(BOOL)isOn prefixImg:(NSString *)name {
    
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", name, (!isOn ? IMG_OFF : @"")]];
    [button setImage:img forState:UIControlStateNormal];
}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    [self loadDataSessionAndConnect];
}

- (void)loadDataSessionAndConnect {
    NSLog(@"roomName:%@", _roomName);
    if (!_roomName) {
        return;
    }
    [self.spinner startAnimating];
    dispatch_queue_t sessionQ = dispatch_queue_create("session", NULL);
    dispatch_async(sessionQ, ^{
        NSDictionary *dataSession = [ApiREST getSessionData:_roomName];
        if (dataSession) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.refreshControl endRefreshing];
                self.title = [dataSession valueForKeyPath:SESSION_NAME];
                _token = [dataSession valueForKeyPath:SESSION_TOKEN];
                _sessionId = [dataSession valueForKeyPath:SESSION_ID];
                _apiKey = [dataSession valueForKeyPath:SESSION_API_KEY];
                if(!_apiKey || !_token || !_sessionId) {
                    NSLog(@"!!!!**** Error invalid connection parameters");
                } else {
                    NSLog(@"VAmos a conectar con token %@token\n apiKEy:%@ \n sessionId%@", _token, _apiKey, _sessionId);
                    [self doConnect];
                }

            });
        } else {
            NSLog(@"Error recovering data session");
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewElem];
    self.tabBarItem.enabled = NO;
    //[self loadDataSessionAndConnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure view

-(void)toggleSubAudio {
    NSLog(@"subcriber Audio toggle");
    _subscriber.subscribeToAudio = !_subscriber.subscribeToAudio;
    [self setButton:_subAudioBtn withValue:_subscriber.subscribeToAudio prefixImg:SPEAKER_IMG];
}

- (void)toggleSubCamera {
    NSLog(@"togglePubCamera!!");
    _subscriber.subscribeToVideo = !_subscriber.subscribeToVideo;
    [self setButton:self.subCameraBtn withValue:_subscriber.subscribeToVideo prefixImg:CAMERA_IMG];
}

- (void)togglePubCamera {
    NSLog(@"togglePubCamera!!");
    _publisher.publishVideo = !_publisher.publishVideo;
    [self setButton:self.pubCameraBtn withValue:_publisher.publishVideo prefixImg:CAMERA_IMG];
}

- (void)togglePubMic {
    NSLog(@"DENTRO!!! togglePubMic AUDIO:%d", _publisher.publishAudio);
    _publisher.publishAudio = !_publisher.publishAudio;
    [self setButton:self.pubMicBtn withValue:_publisher.publishAudio prefixImg:MIC_IMG];
}

-(void)swapCamera {
    UIImage *imageBtn;
    if (_publisher.cameraPosition == AVCaptureDevicePositionFront) {
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
        imageBtn = [UIImage imageNamed:CAMERA_SWAP_IMG];
    } else {
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
        imageBtn = [UIImage imageNamed:CAMERA_SWAP_BACK_IMG];
    }
    [self.pubIsCameraFrontBtn setImage:imageBtn forState:UIControlStateNormal];
}

-(void) resetButton:(UIButton *)button withImageName:(NSString *)name {
    button.hidden = YES;
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

-(void) activeButton:(UIButton *)button withSelector:(SEL)selector {
    button.hidden = NO;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(void)configViewElem{
    [self resetButton:self.pubMicBtn withImageName:MIC_IMG];
    [self resetButton:self.pubIsCameraFrontBtn withImageName:CAMERA_SWAP_IMG];
    [self resetButton:self.pubCameraBtn withImageName:CAMERA_IMG];
    
    [self resetButton:self.subAudioBtn withImageName:SPEAKER_IMG];
    [self resetButton:self.subCameraBtn withImageName:CAMERA_IMG];
    //self.subWaiting.text = @"Waiting for someone else in the Room";
    self.subWaiting.hidden = YES;
}

#pragma mark - OpenTok methods

- (void)doConnect {
    // Initialize a new instance of OTSession and begin the connection process.
    _session = [[OTSession alloc] initWithApiKey:_apiKey
                                       sessionId:_sessionId
                                        delegate:self];
    OTError *error = nil;
    [_session connectWithToken:_token error:&error];
    if (error) {
        NSLog(@"Unable to connect to the session (%@)", error.localizedDescription);
    } else {
        [self.spinner stopAnimating];
         self.subWaiting.hidden = NO;
    }
}

- (void) session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"session didFailWithError: (%@)", error);
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
      [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}


- (void)session:(OTSession*)session streamDestroyed:(OTStream *)stream {
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId]) {
      [self cleanupSubscriber];
    }
}

- (void)cleanupSubscriber {
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

- (void)sessionDidConnect:(OTSession*)session {
    NSLog(@"Connected to the session.");
    [self doPublish];
}

- (void)doPublish {
    NSLog(@"doPublish");
    _publisher = [[OTPublisher alloc] initWithDelegate:self];
    
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error) {
        NSLog(@"Unable to publish (%@)", error.localizedDescription);
        return;
    }
    
    [_publisher.view setFrame:CGRectMake(0, 0, _publisherView.bounds.size.width,
                                         _publisherView.bounds.size.height)];
    [_publisherView addSubview:_publisher.view];
    
    [self activeButton:self.pubMicBtn withSelector:@selector(togglePubMic)];
    [self activeButton:self.pubIsCameraFrontBtn withSelector:@selector(swapCamera)];
    [self activeButton:self.pubCameraBtn withSelector:@selector(togglePubCamera)];
    
//    _publisher.publishVideo = YES;
//    _publisher.publishAudio = YES;
    
    if (![Config getConfig].micON) {
        NSLog(@"doPublisheer!!! Desactivar MIC");
        _publisher.publishAudio = NO;
        NSLog(@"doPublisheer!!! done");
        [self setButton:self.pubMicBtn withValue:NO prefixImg:MIC_IMG];
    }

    if (![Config getConfig].pubVideoON) {
        NSLog(@"doPublisheer!!! Desactivar PUB VIDEO");
        _publisher.publishVideo = NO;
        NSLog(@"doPublisheer!!! done");
        [self setButton:self.pubCameraBtn withValue:NO prefixImg:CAMERA_IMG];
    }

    if (![Config getConfig].isCameraFront) {
        [self swapCamera];
    }

}

- (void)publisher:(OTPublisherKit *)publisher streamCreated:(OTStream *)stream {
    NSLog(@"Now publishing.");
}

- (void)publisher:(OTPublisherKit *)publisher streamDestroyed:(OTStream *)stream {
    NSLog(@"Dejar de publicar!!!");
    [self cleanupPublisher];
}

- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
}

- (void)publisher:(OTPublisherKit*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}

- (void)session:(OTSession*)session streamCreated:(OTStream *)stream {
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    if (nil == _subscriber) {
        [self doSubscribe:stream];
    }
}

- (void)doSubscribe:(OTStream*)stream {
    NSLog(@"DO_SUBSCRIBE!!!!");
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error) {
        NSLog(@"Unable to publish (%@)", error.localizedDescription);
    } else {
        self.subWaiting.hidden = YES;
    }
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber {
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    [_subscriber.view setFrame:CGRectMake(0, 0, _subscriberView.bounds.size.width,
                                          _subscriberView.bounds.size.height)];
    [_subscriberView addSubview:_subscriber.view];
    [self activeButton:self.subAudioBtn withSelector:@selector(toggleSubAudio)];
    [self activeButton:self.subCameraBtn withSelector:@selector(toggleSubCamera)];
    
    if (![Config getConfig].isSpeakerON) {
        _subscriber.subscribeToAudio = NO;
        [self setButton:self.subAudioBtn withValue:NO prefixImg:SPEAKER_IMG];
    } else {
        _subscriber.subscribeToAudio = YES;
    }
    
    if (![Config getConfig].subVideoON) {
        NSLog(@"no video SUB");
        _subscriber.subscribeToVideo = NO;
        [self setButton:self.subCameraBtn withValue:NO prefixImg:CAMERA_IMG];
    } else {
        _subscriber.subscribeToVideo = YES;
    }
}

- (void)subscriber:(OTSubscriberKit*)subscriber didFailWithError:(OTError*)error {
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
}


@end
