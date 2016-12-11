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

@interface AjustesTableViewController ()

@end

@implementation AjustesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
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

    
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"cat_bancos"]) == nil) {
       //Not setup yet
        
      [self configureSwitches];
  
    } else {
        
        //Will be readed
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_asistViajes"] == YES){
            [_asistViajes setOn:YES];
        }else{
            [_asistViajes setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_bancos"] == YES){
            [_bancos setOn:YES];
        }else{
            [_bancos setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_casasCambio"] == YES){
            [_casasCambio setOn:YES];
        }else{
            [_casasCambio setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_chocolate"] == YES){
            [_chocolate setOn:YES];
        }else{
            [_chocolate setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_cuidadoPersonal"] == YES){
            [_cuidadoPersonal setOn:YES];
        }else{
            [_cuidadoPersonal setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_farmacias"] == YES){
            [_farmacias setOn:YES];
        }else{
            [_farmacias setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_general"] == YES){
            [_general setOn:YES];
        }else{
            [_general setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_hoteles"] == YES){
            [_hoteles setOn:YES];
        }else{
            [_hoteles setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_jardinesInfantiles"] == YES){
            [_jardinesInfantiles setOn:YES];
        }else{
            [_jardinesInfantiles setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_jugueterias"] == YES){
            [_jugueterias setOn:YES];
        }else{
            [_jugueterias setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_minimarkets"] == YES){
            [_minimarkets setOn:YES];
        }else{
            [_minimarkets setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_musica"] == YES){
            [_musica setOn:YES];
        }else{
            [_musica setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_restoranes"] == YES){
            [_restoranes setOn:YES];
        }else{
            [_restoranes setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_salud"] == YES){
            [_salud setOn:YES];
        }else{
            [_salud setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_tecnologia"] == YES){
            [_tecnologia setOn:YES];
        }else{
            [_tecnologia setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_telefonia"] == YES){
            [_telefonia setOn:YES];
        }else{
            [_telefonia setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_transporte"] == YES){
            [_transporte setOn:YES];
        }else{
            [_transporte setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_turismo"] == YES){
            [_turismo setOn:YES];
        }else{
            [_turismo setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_vestuarioyAccesorios"] == YES){
            [_vestuarioyAccesorios setOn:YES];
        }else{
            [_vestuarioyAccesorios setOn:NO];
        }
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"cat_vinosYLicores"] == YES){
            [_vinosYLicores setOn:YES];
        }else{
            [_vinosYLicores setOn:NO];
        }
        
        
       
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)switchChanged:(id)sender {
    NSLog(@"Switch changed");
    [self configureSwitches];

}


-(void)configureSwitches{
    
    if(_asistViajes.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_asistViajes"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_asistViajes"];
    }
    
    if(_bancos.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_bancos"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_bancos"];
    }
    
    if(_casasCambio.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_casasCambio"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_casasCambio"];
    }
    
    if(_chocolate.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_chocolate"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_chocolate"];
    }
    
    if(_cuidadoPersonal.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_cuidadoPersonal"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_cuidadoPersonal"];
    }
    if(_farmacias.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_farmacias"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_farmacias"];
    }
    
    if(_general.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_general"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_general"];
    }
    
    if(_hoteles.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_hoteles"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_hoteles"];
    }
    
    if(_jardinesInfantiles.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_jardinesInfantiles"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_jardinesInfantiles"];
    }
    
    if(_jugueterias.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_jugueterias"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_jugueterias"];
    }
    
    if(_minimarkets.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_minimarkets"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_minimarkets"];
    }
    
    if(_musica.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_musica"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_musica"];
    }
    
    if(_restoranes.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_restoranes"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_restoranes"];
    }
    
    if(_salud.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_salud"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_salud"];
    }
    
    if(_tecnologia.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_tecnologia"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_tecnologia"];
    }
    
    if(_telefonia.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_telefonia"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_telefonia"];
    }
    
    if(_transporte.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_transporte"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_transporte"];
    }
    
    if(_turismo.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_turismo"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_turismo"];
    }
    
    if(_vestuarioyAccesorios.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_vestuarioyAccesorios"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_vestuarioyAccesorios"];
    }
    
    if(_vinosYLicores.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cat_vinosYLicores"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cat_vinosYLicores"];
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
    return 22;
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
