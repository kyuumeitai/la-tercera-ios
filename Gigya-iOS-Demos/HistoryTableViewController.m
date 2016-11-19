//
//  HistoryTableViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 16-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"
#import "HistoricoBeneficio.h"
#import "UserProfile.h"


@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController
NSMutableArray *listaHistoryCategorias;
NSMutableArray * historyItemsBenefits;
NSMutableArray * historyItemsContests;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getHistory];
   

       // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getHistory{
    SessionManager *sesion = [SessionManager session];
    UserProfile *profile = [sesion getUserProfile];
    NSString * email = profile.email;
    self.historyItemsBenefit = [[NSMutableArray alloc] init];
    self.historyItemsContests = [[NSMutableArray alloc] init];

    [self loadHistoryForEmail:email];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int secciones = 0;
    
    if (self.historyItemsBenefit.count >0)
        secciones ++;
    if (self.historyItemsContests.count >0)
        secciones ++;
    
    return secciones;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return self.historyItemsBenefit.count;
    }
    if(section ==1){
        return self.historyItemsContests.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *celda = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        
        HistoricoBeneficio *histBenef = self.historyItemsBenefit[indexPath.row];
        celda.textLabel.text = histBenef.titulo;
        
        NSString *detalle =  [NSString stringWithFormat:@"%@ - Monto: $%@  - %@",histBenef.fechaSol, histBenef.monto, histBenef.estado];
        celda.detailTextLabel.text = detalle;

    }else{
          celda.textLabel.text = self.historyItemsContests[indexPath.row];

    }
    
    return celda;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Historial de Beneficios";
    if(section == 1)
        return @"Historial de Concursos";
    
    return @"";
}
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



#pragma - SERVICE METHODS

-(void)loadHistoryForEmail:(NSString*)email{
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    
   NSString * responseString = [connectionManager getHistoryWithEmail:email];
    NSLog(@"responseString: %@",responseString);

    NSError *error;
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary *historyDict = [json objectForKey:@"historial"];
    id benefitDict = [historyDict objectForKey:@"beneficio"];
    
    for (id benefit in benefitDict){
        id fecha = [benefit objectForKey:@"fechaSol"];
        id titulo = [benefit objectForKey:@"titulo"];
        id monto = [benefit objectForKey:@"monto"];
        id estado = [benefit objectForKey:@"estado"];
        
        HistoricoBeneficio *histBenef = [[HistoricoBeneficio alloc] init];
        histBenef.fechaSol = fecha;
        histBenef.titulo = titulo;
        histBenef.monto =monto;
        histBenef.estado = estado;
        [self.historyItemsBenefit addObject:histBenef];
    }
    
    
}

@end
