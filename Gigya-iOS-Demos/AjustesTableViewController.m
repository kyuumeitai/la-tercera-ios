//
//  AjustesTableViewController.m
//  La Tercera
//
//  Created by diseno on 28-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "AjustesTableViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "Headers/MOCA.h"
#import "SessionManager.h"
#import "UserProfile.h"
#import "ConnectionManager.h"

@interface AjustesTableViewController (){
    UIDownPicker *_dp;
    NSMutableArray *values;
}

@end

@implementation AjustesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    values = [[NSMutableArray alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"seccion_inicio";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        //  Doesn't exist.
        [_seccionesButton setTitle:@"Seleccione" forState:UIControlStateNormal];
        
        [_seccionesButton addTarget:self
                   action:@selector(seccionesPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        //  Get current level
        NSString * currentLevel = [preferences stringForKey:currentLevelKey];

        [_seccionesButton setTitle:currentLevel forState:UIControlStateNormal];
        
        [_seccionesButton addTarget:self
                   action:@selector(seccionesPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
   [self setupSwitches];
}

- (void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Preferencias"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewWillAppear:animated];
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
        NSLog(@"news: %@",[[MOCA currentInstance] getTagValue:@"preference_wants_news_notification"]);
        NSNumber *valueNews = [[MOCA currentInstance] getTagValue:@"preference_wants_news_notification"];
        if([valueNews isEqualToNumber:[NSNumber numberWithInteger:1]]){
            [_notificacionesNoticia setOn:(YES)];
        }
        
        NSLog(@"club: %@",[[MOCA currentInstance] getTagValue:@"preference_wants_club_notification"]);
        NSNumber *valueClub = [[MOCA currentInstance] getTagValue:@"preference_wants_club_notification"];
        if([valueClub isEqualToNumber:[NSNumber numberWithInteger:1]]){
            [_notificacionesClub setOn:(YES)];
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
        if([_notificacionesNoticia isOn]){
            [[MOCA currentInstance] addTag:@"preference_wants_news_notification" withValue:@"1"];
        }else{
            [[MOCA currentInstance] addTag:@"preference_wants_news_notification" withValue:@"0"];
        }
        
        if([_notificacionesClub isOn]){
            [[MOCA currentInstance] addTag:@"preference_wants_club_notification" withValue:@"1"];
        }else{
            [[MOCA currentInstance] addTag:@"preference_wants_club_notification" withValue:@"0"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTerminosCondiciones:(id)sender{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Preferencias/btn/terminosycond"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.latercera.com/terminos-y-condicciones/"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        ConnectionManager *conexion = [[ConnectionManager alloc] init];
        
        BOOL estaConectado = [conexion verifyConnection];
        NSLog(@"Verificando conexión: %d",estaConectado);
        [conexion getAllCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success) {
                    NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
                } else {
                    [self showSecciones:arrayJson];
                }
            });
        }];
    }
}

- (IBAction)seccionesPressed:(id)sender {
    ConnectionManager *conexion = [[ConnectionManager alloc] init];
    
    BOOL estaConectado = [conexion verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [conexion getAllCategories:^(BOOL success, NSArray *arrayJson, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self showSecciones:arrayJson];
            }
        });
    }];
}

-(void) showSecciones: (NSArray*)arrayHeadlinesJson{
    [values removeAllObjects];
    for (NSDictionary *objeto in arrayHeadlinesJson) {
        NSString *valorAGuardar = [objeto valueForKey:@"title"];
        if([valorAGuardar containsString:@"Teletón"] ||
           [valorAGuardar containsString:@"test"] ||
           [valorAGuardar containsString:@"prueba"] ||
           [valorAGuardar containsString:@"teléfono"]){
            
        }else{
            [values addObject:valorAGuardar];
        }
    }
    
    /*_dp = [[UIDownPicker alloc] initWithData:values];
    //[_seccionesButton inputView:_dp];
    [self.parentViewController.view addSubview:_dp];*/
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Seleccione"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    // ObjC Fast Enumeration
    for (NSString *title in values) {
        [actionSheet addButtonWithTitle:title];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancelar"];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"seccion_inicio";
    
    NSString *valor = [values objectAtIndex:buttonIndex];
    [preferences setValue:valor forKey:currentLevelKey];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave)
    {
        //  Couldn't save (I've never seen this happen in real world testing)
    }else{
        [_seccionesButton setTitle:valor forState:UIControlStateNormal];
    }
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
