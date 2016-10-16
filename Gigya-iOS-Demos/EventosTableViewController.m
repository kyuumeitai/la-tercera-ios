//
//  EventosTableViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "EventosTableViewController.h"
#import "BeneficioGeneralTableViewCell.h"
#import "BeneficioGeneralDestacadoTableViewCell.h"
#import  "DetalleEventosViewController.h"
#import "Category.h"
#import "Evento.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"
#import "SVPullToRefresh.h"
#define benefitCategoryId 39

@interface EventosTableViewController ()

@end

@implementation EventosTableViewController

@synthesize eventosItemsArray;

NSMutableArray *listaCategoriasEventos;
NSMutableArray *listaBeneficiosEventos;
NSString *storyBoardNameEventos;

//New Pagination code
int currentPageNumberEventos ;
BOOL isPageRefreshingEventos =  false;
BOOL firstTimeEventos = false;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    __weak EventosTableViewController *weakSelf = self;
    
    SessionManager *sesion = [SessionManager session];
    storyBoardNameEventos = sesion.storyBoardName;
    //listaCategoriasConcursos = [[NSMutableArray alloc] init];
    eventosItemsArray = [[NSMutableArray alloc] init];
    //listaCategoriasConcursos = sesion.categoryList;
    currentPageNumberEventos = 1;
    firstTimeEventos = true;
    
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];

}


- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingEventos= NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventosItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ClubCategoryTableCell5";
    NSArray *nib;
    
    if (indexPath.row==0) {
        BeneficioGeneralDestacadoTableViewCell *cell = (BeneficioGeneralDestacadoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            if([storyBoardNameEventos
                isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameEventos isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell" owner:self options:nil];
            }
            //
            cell = [nib objectAtIndex:0];
            Evento *evento = [self.eventosItemsArray objectAtIndex:0];
            
            cell.labelTitulo.text = evento.title;
            cell.labelSubtitulo.text = evento.summary;
            cell.labelDescuento.text = evento.desclabel;
            
            if((unsigned long)evento.desclabel.length >3)
                cell.labelDescuento.alpha = 0;
            
            //Get Image
            
            NSArray * arr = [evento.imagenNormalString componentsSeparatedByString:@","];
            UIImage *imagenEvento = nil;
            
            //Now data is decoded. You can convert them to UIImage
            imagenEvento = [Tools decodeBase64ToImage:[arr lastObject]];
            if(imagenEvento == nil)
                imagenEvento = [UIImage imageNamed:@"PlaceholderHeaderClub"];
            
            cell.imageDestacada.image = imagenEvento;
        }
        
        return cell;
        
    }else{
        
        BeneficioGeneralTableViewCell *cell = (BeneficioGeneralTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            if([storyBoardNameEventos
                isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameEventos
                                                                    isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell" owner:self options:nil];
            }
            
            cell = [nib objectAtIndex:0];
        }
        
        Evento *evento2 = [self.eventosItemsArray objectAtIndex:indexPath.row];
        [evento2 logDescription];
        
        cell.labelTitulo.text = evento2.title;
        cell.labelDescuento.text = evento2.desclabel;
        cell.labelSubtitulo.text = evento2.summary;
        if((unsigned long)evento2.desclabel.length >3)
            cell.labelDescuento.alpha = 0;
        //Get Image
        NSArray * arr2 = [evento2.imagenNormalString componentsSeparatedByString:@","];
        UIImage *imagenBeneficio2 = nil;
        
        //Now data is decoded. You can convert them to UIImage
        imagenBeneficio2 = [Tools decodeBase64ToImage:[arr2 lastObject]];
        if(!imagenBeneficio2)
            imagenBeneficio2 = [UIImage imageNamed:@"PlaceholderHeaderClub"];
        cell.imageCategoria.image = imagenBeneficio2;
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 278.0;
    }
    else {
        return 114.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"DETECTED");

    DetalleEventosViewController *detalleEvento = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleEventoViewController"];
    
    
    Evento *evento = [self.eventosItemsArray objectAtIndex:indexPath.row];
    
    [detalleEvento loadEventForEventId:evento.idEvento];
    
    //Get Image
    NSArray * arr = [evento.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleEvento.eventoImage = imagenBeneficio;
    
    detalleEvento.eventoTitle = evento.title;
    // detalleConcurso.benefitAddress = @"";
    // detalleBeneficio.benefitDiscount= concurso.desclabel;
    detalleEvento.eventoDescription = evento.summary;
    detalleEvento.eventoId = evento.idEvento;
    [evento logDescription];
    
    [self.navigationController pushViewController: detalleEvento animated:YES];
    
}
  
-(void)loadBenefitsForCategoryId:(int)idCategory{
    
    NSLog(@"Load category benefits Concursos");
    __weak EventosTableViewController *weakSelf = self;
    // IMPORTANT - Only update the UI on the main thread
    if (isPageRefreshingEventos == false)
        [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    
    [connectionManager getPagedEvents:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingEventos == false){
                    
                    [self errorDetectedWithNSError:error];
                }else{
                    [weakSelf.tableView endUpdates];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
            } else {
                
                NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    
                    isPageRefreshingEventos = YES;
                    
                }else{
                    
                    [self reloadBenefitsDataFromService:arrayJson];
                    NSLog(@"Lista jhson: %@",arrayJson);
                }
            }
        });
    }forPage:currentPageNumberEventos];

}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    
    
    __weak EventosTableViewController *weakSelf = self;
    NSLog(@"  reload Concursos");
    //benefitsItemsArray5 = [[NSMutableArray alloc] init];
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    id benefits = [tempDict objectForKey:@"results"];
    
    for (id benefit in benefits){
        
        id titleBen = [benefit objectForKey:@"titulo"];
        int idBen =[ [benefit objectForKey:@"id"] intValue];;
        //NSLog(@"idBen :%d",idBen);
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"descripcion"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        
        Evento *evento = [[Evento alloc] init];
        evento.idEvento = idBen;
        evento.title = titleBen;
        evento.url = linkBen;
        evento.summary= summaryBen;
        evento.desclabel = benefitLabelBen;
        
        if([benefit objectForKey:@"imagenDestacada"] != [NSNull null]){
            
            NSString *imagenBen = [benefit objectForKey:@"imagenDestacada"] ;
            evento.imagenNormalString = imagenBen;
        }
        
        [self.eventosItemsArray addObject:evento];
        
    }
    
    if (firstTimeEventos ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             [SVProgressHUD dismiss];
         }];
        firstTimeEventos = false;
    }else{
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        isPageRefreshingEventos = NO;
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }
    
    NSLog(@" ******* RELOAD DATA TABLE Concursos ****** ----------------------");
}

//Error handler
-(void) errorDetectedWithNSError:(NSError*) error{
    
    NSLog(@"Error obteniendo datos! El error es:  %@", [error localizedDescription]);
    
    //Escondemos el loading
    [SVProgressHUD dismiss];
    
    //Damos explicaciones del caso
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error obteniendo Datos"
                          message:@"Ha ocurrido un error al obtener los datos. Reintente más tarde."
                          delegate:nil //or self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberEventos);
    
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberEventos);
    isPageRefreshingEventos = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberEventos = currentPageNumberEventos +1;
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
}
@end
