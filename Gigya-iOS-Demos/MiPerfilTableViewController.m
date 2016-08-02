//
//  MiPerfilTableViewController.m
//  La Tercera
//
//  Created by diseno on 28-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "MiPerfilTableViewController.h"
#import "SessionManager.h"
#import "UserProfile.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GigyaSDK/Gigya.h>


@interface MiPerfilTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textFieldUserName;
@property (weak, nonatomic) IBOutlet UILabel *texfieldEmail;
@property GSAccount *user;
@end

@implementation MiPerfilTableViewController

SessionManager *sesion;
UserProfile *profile;
NSString *nombre;
NSString *email;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    sesion = [SessionManager session];
    profile = [sesion getUserProfile];
    
    
    NSString *nombreCompleto = [NSString stringWithFormat:@"%@ %@",profile.name, profile.lastName];
    nombre = nombreCompleto;
    email = profile.email;
    

    _textFieldUserName.text = nombre;
    _texfieldEmail.text = email;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeSessionPressed:(id)sender {
    [Gigya logoutWithCompletionHandler:^(GSResponse *response, NSError *error) {
        self.user = nil;
        [sesion resetUserProfile];
        if (error) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                               message:[@"Hubo un problema saliendo de Gigya. Codigo error " stringByAppendingFormat:@"%d",response.errorCode]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:@"Cancelar", nil];
            [alert show];
        }else{
             [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
