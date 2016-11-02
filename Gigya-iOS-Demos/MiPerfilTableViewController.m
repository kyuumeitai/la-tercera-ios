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
#import "ConnectionManager.h"


@interface MiPerfilTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textFieldUserName;
@property (weak, nonatomic) IBOutlet UILabel *texfieldEmail;

@property GSAccount *user;
@end

@implementation MiPerfilTableViewController

SessionManager *sesionMiPerfil;
UserProfile *profile;
NSString *nombre;
NSString *emailMiPerfil;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    sesionMiPerfil = [SessionManager session];
    profile = [sesionMiPerfil getUserProfile];
    
    
    NSString *nombreCompleto = [NSString stringWithFormat:@"%@ %@",profile.name, profile.lastName];
    nombre = nombreCompleto;
    emailMiPerfil = profile.email;
    

    _textFieldUserName.text = nombre;
    _texfieldEmail.text = emailMiPerfil;
    
    //ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    
    //NSString *respuesta = [connectionManager getHistoryWithemailMiPerfil:@"cristian.villarreal.urrutia@gmail.com"];

    //NSString *respuesta = [connectionManager getHistoryWithemailMiPerfil:emailMiPerfil];
    //NSLog(@"***::::-----    %@     -----::::***\r\r\r",respuesta);
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeSessionPressed:(id)sender {
    [Gigya logoutWithCompletionHandler:^(GSResponse *response, NSError *error) {
        self.user = nil;
        [sesionMiPerfil resetUserProfile];
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


@end
