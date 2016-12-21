//
//  HorariosTableViewController.m
//  La Tercera
//
//  Created by Daniel López Monsalve on 16-12-16.
//  Copyright © 2016 Copesa. All rights reserved.
//

#import "HorariosTableViewController.h"
#import "Headers/MOCA.h"
#import "SessionManager.h"
#import "UserProfile.h"

@interface HorariosTableViewController ()

@end

@implementation HorariosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    [self setupSwitches];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"Singleton description: %@",[sesion profileDescription]);
    UserProfile *perfil = [sesion getUserProfile];
    [MOCA initializeSDK];
    MOCAUser * currentUser = [[MOCA currentInstance] login:perfil.email];
    
    [currentUser saveWithBlock:^(MOCAUser *user, NSError *error){
         if (error) NSLog(@"Save user failed: %@", error);
    }];

}

- (void)setupSwitches{
    // [_asistViajes setOn:YES];
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"Singleton description: %@",[sesion profileDescription]);
    UserProfile *perfil = [sesion getUserProfile];
    [MOCA initializeSDK];
    MOCAUser * currentUser = [[MOCA currentInstance] login:perfil.email];
    if (currentUser)
    {
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_01"]){
            [_horario1 setOn:(YES)];
        }
        
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_02"]){
            [_horario2 setOn:(YES)];
        }
        
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_03"]){
            [_horario3 setOn:(YES)];
        }
        
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_04"]){
            [_horario4 setOn:(YES)];
        }
        
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_05"]){
            [_horario5 setOn:(YES)];
        }
        
        if([[MOCA currentInstance] getTagValue:@"preference_notification_schedules_06"]){
            [_horario6 setOn:(YES)];
        }
    }
}

- (IBAction)switchChanged:(id)sender {
    NSLog(@"Switch changed");
    [self configureSwitches];
    
}


-(void)configureSwitches{
    SessionManager *sesion = [SessionManager session];
    
    NSLog(@"Singleton description: %@",[sesion profileDescription]);
    UserProfile *perfil = [sesion getUserProfile];
    [MOCA initializeSDK];
    MOCAUser * currentUser = [[MOCA currentInstance] login:perfil.email];
    if (currentUser)
    {
        if([_horario1 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_01"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_01"];
        }
        
        if([_horario2 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_02"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_02"];
        }
        
        if([_horario3 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_03"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_03"];
        }
        
        if([_horario4 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_04"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_04"];
        }
        
        if([_horario5 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_05"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_05"];
        }
        
        if([_horario6 isOn]){
            [[MOCA currentInstance] addTag:@"preference_notification_schedules_06"];
        }else{
            [[MOCA currentInstance] removeTag:@"preference_notification_schedules_06"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
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
