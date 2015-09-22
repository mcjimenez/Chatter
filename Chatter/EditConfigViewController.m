//
//  EditConfigViewController.m
//  chatter
//
//  Created by cjc on 20/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "EditConfigViewController.h"
#import "Config.h"
#import "ViewControllerTools.h"


#define NAME @"name"
#define SERVER @"server"
#define PUB_VIDEO @"pubVideoOn"
#define SUB_VIDEO @"subVideoOn"
#define CAMERA @"cameraFront"
#define MIC @"micOn"
#define SPEAKER @"speakerOn"

#warning meter locales!!!

@interface EditConfigViewController ()

@property (weak, nonatomic) IBOutlet UITextField *editableValue;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation EditConfigViewController

- (IBAction)saveValue:(UIButton *)sender {
    NSLog(@"saveValue!!!");
#warning Cambiar para attributos booleanos (q visual muestre un UISwitch)
    if ([self.attName isEqualToString:NAME]) {
        NSLog(@"LLAmar a setter de config.name para poner %@", self.editableValue.text);
        [Config getConfig].name = self.editableValue.text;
    } else if ([self.attName isEqualToString:SERVER]) {
        NSLog(@"LLAmar a setter de config.server para poner %@", self.editableValue.text);
        [Config getConfig].server = self.editableValue.text;
    } else if ([self.attName isEqualToString:PUB_VIDEO]) {
        NSLog(@"LLAmar a setter de config.pubVideoON para poner %d", ([self.editableValue.text isEqualToString:@"No"] ? NO : YES));

        [Config getConfig].pubVideoON = ([self.editableValue.text isEqualToString:@"No"] ? NO : YES);
    } else if ([self.attName isEqualToString:SUB_VIDEO]) {
        NSLog(@"LLAmar a setter de config.subVideoON para poner %@", self.editableValue.text);

        [Config getConfig].subVideoON = ([self.editableValue.text isEqualToString:@"No"] ? NO : YES);
    } else if ([self.attName isEqualToString:CAMERA]) {
        NSLog(@"LLAmar a setter de config.cameraFront para poner %@", self.editableValue.text);

        [Config getConfig].cameraFront = ([self.editableValue.text isEqualToString:@"Front"] ? NO : YES);
    } else if ([self.attName isEqualToString:MIC]) {
        NSLog(@"LLAmar a setter de config.micON para poner %@", self.editableValue.text);

        [Config getConfig].micON = ([self.editableValue.text isEqualToString:@"No"] ? NO : YES);
    } else if ([self.attName isEqualToString:SPEAKER]) {
        NSLog(@"LLAmar a setter de config.speakerON para poner %@", self.editableValue.text);
        [Config getConfig].speakerON = ([self.editableValue.text isEqualToString:@"No"] ? NO : YES);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)getTitleValueForAttName:(NSString *)attName {

    NSString *title;
    if ([attName isEqualToString:NAME]) {
        title = @"Name";
    } else if ([attName isEqualToString:SERVER]) {
        title = @"Server";
    } else if ([attName isEqualToString:PUB_VIDEO]) {
        title = @"Room Video Enabled";
    } else if ([attName isEqualToString:SUB_VIDEO]) {
        title = @"Camera enabled";
    } else if ([attName isEqualToString:CAMERA]) {
        title = @"Camera";
    } else if ([attName isEqualToString:MIC]) {
        title = @"Mic enabled";
    } else if ([attName isEqualToString:SPEAKER]) {
        title = @"Speaker enabled";
    }
    return title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ViewControllerTools getShadow] configTxtField:self.editableValue withDelegate:self];
    [[ViewControllerTools getShadow] setButtonAspect:self.doneBtn];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.editableValue.text = self.attValue;
    self.title = [self getTitleValueForAttName:self.attName];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    
    self.tabBarController.navigationItem.leftBarButtonItem = rightButton;
    self.tabBarController.navigationItem.leftItemsSupplementBackButton = YES;
    NSLog(@"viewWillAppear");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (void)saveWithSelector:(SEL)selector {
    
    Config *config = [Config getConfig];
    //[config performSelector:selector withObject:value];
}
 */

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"input: %@", textField);
    [textField resignFirstResponder];
    return YES;
}
@end
