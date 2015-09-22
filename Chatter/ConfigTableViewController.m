//
//  ConfigTableViewController.m
//  chatter
//
//  Created by cjc on 18/9/15.
//  Copyright (c) 2015 tokbox. All rights reserved.
//

#import "ConfigTableViewController.h"
#import "Config.h"
#import "EditConfigViewController.h"

#warning CrearCustomCell con switch para valores booleanos
#warning dale una vuelta, no me gusta esto

@interface ConfigTableViewController ()

@end

@implementation ConfigTableViewController

NSIndexPath *currentIndexPath = nil;

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (currentIndexPath) {
        NSArray *arrIndexPath = @[currentIndexPath];
        [self.tableView reloadRowsAtIndexPaths:arrIndexPath withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindFromEditConfig:(UIStoryboardSegue *)sender {
    NSLog(@"UNWind!!");
    if ([[sender identifier] isEqualToString:@"customUnwindSettings"]) {
        NSLog(@"Salvar VALOR");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 3;
            break;
        case 3:
            rows = 2;
            break;
    }
    return rows;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing for segue");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
#warning Rehacer esto
    if ([segue.identifier isEqualToString:@"editConfig"]) {
        if ([segue.destinationViewController isKindOfClass:[EditConfigViewController class]]) {
            Config *config = [Config getConfig];
            EditConfigViewController *ecvc = (EditConfigViewController *)segue.destinationViewController;
            currentIndexPath = (NSIndexPath *)sender;
            switch (currentIndexPath.section) {
                case 0:
                    ecvc.attName = @"name";
                    ecvc.attValue = config.name ? config.name : @"";
                    break;
                case 1:
                    ecvc.attName = @"server";
                    ecvc.attValue = config.server;
                    break;
                case 2:
                    if (currentIndexPath.row == 0) {
                        ecvc.attName = @"pubVideoOn";
                        ecvc.attValue = (config.isPubVideoON ? @"Sí" : @"No");
                    } else if (currentIndexPath.row == 1) {
                        ecvc.attName = @"subVideoOn";
                        ecvc.attValue = config.isSubVideoON ? @"Sí" : @"No";
                    } else if (currentIndexPath.row == 2) {
                        ecvc.attName = @"cameraFront";
                        ecvc.attValue = config.isCameraFront ? @"Front" : @"Back";
                    }
                    break;
                case 3:
                    if (currentIndexPath.row == 0) {
                        ecvc.attName = @"micOn";
                        ecvc.attValue = config.isMicON ? @"Sí" : @"No";
                    } else {
                        ecvc.attName = @"speakerOn";
                        ecvc.attValue = config.isSpeakerON ? @"Sí" : @"No";
                    }
                    break;
            }

        }
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)getCellWithText:(NSString *)name andDetail:(NSString *)detail {
#warning q pasa con la longitud de linea?? ein?
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *) getCellWithText:(NSString *)name andAccessory:(UITableViewCellAccessoryType)accessory {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = name;
    cell.accessoryType = accessory;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    [self performSegueWithIdentifier:@"editConfig" sender:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    Config *config = [Config getConfig];
    
    switch (indexPath.section) {
        case 0:
            cell = [self getCellWithText:@"Name" andDetail:(config.name ? config.name : @"Your name")];
            break;
        case 1:
            cell = [self getCellWithText:@"Server" andDetail:(config.server? config.server : @"OpenTok server url")];
            break;
        case 2:
            if (indexPath.row == 0) {
                cell = [self getCellWithText:@"Enabled your video"
                                andDetail:(config.isPubVideoON ? @"Sí" : @"No")];
            } else if (indexPath.row == 1) {
                cell = [self getCellWithText:@"Enabled room's video"
                                andDetail:(config.isSubVideoON ? @"Sí" : @"No")];
            } else if (indexPath.row == 2) {
                cell = [self getCellWithText:@"Camera" andDetail: (config.isCameraFront ? @"Front" : @"Back")];
            }
            break;
        case 3:
            if (indexPath.row == 0) {
                cell = [self getCellWithText:@"Enabled mic"
                                andDetail:(config.isMicON ? @"Sí" : @"No")];
            } else {
                cell = [self getCellWithText:@"Enabled speaker"
                                andDetail:(config.isSpeakerON ? @"Sí" : @"No")];
            }
    }
   return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
