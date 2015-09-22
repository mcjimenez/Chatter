//
//  SelectRoomViewController.m
//  chatter
//
//  Created by cjc on 14/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "SelectRoomViewController.h"
#import "RoomViewController.h"
#import "ApiREST.h"
#import "ViewControllerTools.h"
#import "Config.h"

#warning Al tocar fuera de la pantalla ocultar teclado

@interface SelectRoomViewController () 
@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UITextField *userId;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation SelectRoomViewController

/*
- (void)configTxtField:(UITextField *)txtField withPlaceHolder:(NSString *)txt {
    txtField.placeholder = txt;
    txtField.returnKeyType = UIReturnKeyDone;
    txtField.enablesReturnKeyAutomatically = YES;
    txtField.delegate = self;
}
*/
- (void)configView {
#warning l10n!!!!!!!! q es eso de literales!!!
    
    [[ViewControllerTools getShadow] configTxtField:self.roomName withPlaceHolder:@"Your id in the room" andDelegate:self];
    [[ViewControllerTools getShadow] configTxtField:self.userId withPlaceHolder:@"Room's name to join" andDelegate:self];
    [[ViewControllerTools getShadow] setButtonAspect:self.joinBtn];
    /*
    self.joinBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.joinBtn.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    self.joinBtn.layer.masksToBounds = NO;
    self.joinBtn.layer.shadowRadius = 3.0f;
    self.joinBtn.layer.shadowOpacity = 1.0;
    self.joinBtn.layer.cornerRadius = 3.0f;
     */
    //self.joinBtn.layer.borderWidth = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userId.text = [[Config getConfig]name];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing for segue");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"goRoom"]) {
        if ([segue.destinationViewController isKindOfClass:[RoomViewController class]]) {
            RoomViewController *rvc = (RoomViewController *)segue.destinationViewController;
            rvc.roomName = self.roomName.text;
            rvc.userId = self.userId.text;
        }
    }    
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"input: %@", textField);
    [textField resignFirstResponder];
    return YES;
}

@end
