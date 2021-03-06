//
//  InfantilTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import  "InfantilTableViewController.h"
#import "BeneficioGeneralTableViewCell.h"
#import "BeneficioGeneralDestacadoTableViewCell.h"
#import  "DetalleBeneficioViewController.h"
#import "Category.h"
#import "Benefit.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"
#import "SVPullToRefresh.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

#define benefitCategoryId 7

@interface InfantilTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation InfantilTableViewController
@synthesize tableView;
NSMutableArray *listaCategoriasInfantil;
NSMutableArray *listaBeneficiosInfantil;
@synthesize benefitsItemsArray4;
BOOL firstTime1 = false;
NSString *storyBoardNameInfantil;


//New Pagination code
int currentPageNumberInfantil ;
BOOL isPageRefreshingInfantil=  false;
BOOL firstTimeInfantil = false;


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak InfantilTableViewController *weakSelf = self;
    self.tableView.delegate = self;
    SessionManager *sesion = [SessionManager session];
       storyBoardNameInfantil = sesion.storyBoardName;
    //listaCategoriasInfantil = [[NSMutableArray alloc] init];
    benefitsItemsArray4 = [[NSMutableArray alloc] init];
    //listaCategoriasInfantil = sesion.categoryList;
    //NSLog(@"La lista de categorias es: %@",listaCategorias.description);
    //[self loadBenefitsForCategoryId:39];
    currentPageNumberInfantil = 1;
    firstTimeInfantil = true;
    
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingInfantil = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Beneficios/infantil"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewWillAppear:animated];
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
    return self.benefitsItemsArray4.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ClubCategoryTableCell5";
    NSArray *nib;
    
    if (indexPath.row==0) {
        BeneficioGeneralDestacadoTableViewCell *cell = (BeneficioGeneralDestacadoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            if([storyBoardNameInfantil isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInfantil isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
            Benefit *beneficio = [self.benefitsItemsArray4 objectAtIndex:0];
            
            cell.labelTitulo.text = beneficio.title;
            cell.labelSubtitulo.text = beneficio.summary;
            cell.labelDescuento.text = beneficio.desclabel;
            
            if((unsigned long)beneficio.desclabel.length >3)
                cell.labelDescuento.alpha = 0;
            
            //Get Image
            
            NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
            UIImage *imagenBeneficio = nil;
            
            //Now data is decoded. You can convert them to UIImage
            imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
            if(imagenBeneficio == nil)
                imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
            
            cell.imageDestacada.image = imagenBeneficio;
        }
        
        return cell;
        
    }else{
        
        BeneficioGeneralTableViewCell *cell = (BeneficioGeneralTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            if([storyBoardNameInfantil isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInfantil isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        Benefit *beneficio2 = [self.benefitsItemsArray4 objectAtIndex:indexPath.row];
        //[beneficio2 logDescription];
        
        cell.labelTitulo.text = beneficio2.title;
        cell.labelDescuento.text = beneficio2.desclabel;
        cell.labelSubtitulo.text = beneficio2.summary;
        if((unsigned long)beneficio2.desclabel.length >3)
            cell.labelDescuento.alpha = 0;
        //Get Image
        NSArray * arr2 = [beneficio2.imagenNormalString componentsSeparatedByString:@","];
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
        return 120.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"DETECTED");
    
    DetalleBeneficioViewController *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    Benefit *beneficio = [self.benefitsItemsArray4 objectAtIndex:indexPath.row];
    [detalleBeneficio loadBenefitForBenefitId:beneficio.idBen andStore:@"0"];
    
    //Get Image
    NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleBeneficio.benefitImage = imagenBeneficio;
    
    detalleBeneficio.benefitTitle= beneficio.title;
    detalleBeneficio.benefitAddress = @"";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = beneficio.idBen;
    detalleBeneficio.beneficioTipo = @"infantil";
    detalleBeneficio.benefitRemoteId = beneficio.idRemoteBen;
    [beneficio logDescription];
    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];
}

-(void)loadBenefitsForCategoryId:(int)idCategory{
    
    NSLog(@"Load category benefits Sabores");
    __weak InfantilTableViewController *weakSelf = self;
    // IMPORTANT - Only update the UI on the main thread
    if (isPageRefreshingInfantil == false)
        [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    
    [connectionManager getPagedBenefitsForCategoryId :^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingInfantil == false){
                    
                    [self errorDetectedWithNSError:error];
                }else{
                    NSLog(@"No sirve la data");
                    [self.tableView setBounces:NO];
                    [self.tableView setAlwaysBounceVertical:NO];
                    [SVProgressHUD dismiss];
                    [weakSelf.tableView endUpdates];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
            } else {
                
                NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    NSLog(@"No sirvee la data");
     
                    isPageRefreshingInfantil = NO;
                    
                }else{
                    
                    [self reloadBenefitsDataFromService:arrayJson];
                    // NSLog(@"Lista jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberInfantil];
    
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    
    
    __weak InfantilTableViewController *weakSelf = self;
    NSLog(@"  reload beenfits Sabores");
    //benefitsItemsArray5 = [[NSMutableArray alloc] init];
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    id benefits = [tempDict objectForKey:@"benefits"];
    
    for (id benefit in benefits){
        
        id titleBen = [benefit objectForKey:@"title"];
        int idBen =[ [benefit objectForKey:@"id"] intValue];;
        //NSLog(@"idBen :%d",idBen);
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"summary"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        
        Benefit *beneficio = [[Benefit alloc] init];
        beneficio.idBen = idBen;
        beneficio.title = titleBen;
        beneficio.url = linkBen;
        beneficio.summary= summaryBen;
        beneficio.desclabel = benefitLabelBen;
        
        if([benefit objectForKey:@"image"] != [NSNull null]){
            
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            beneficio.imagenNormalString = imagenBen;
        }
        
        [self.benefitsItemsArray4 addObject:beneficio];
        
    }
    
    if (firstTimeInfantil ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             [SVProgressHUD dismiss];
         }];
        firstTimeInfantil = false;
    }else{
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        isPageRefreshingInfantil = NO;
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }
    
    NSLog(@" ******* RELOAD DATA TABLE Sabores ****** ----------------------");
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
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberInfantil);
    
    isPageRefreshingInfantil = YES;
    [SVProgressHUD showWithStatus:@"Obteniendo más beneficios ..." maskType:SVProgressHUDMaskTypeClear];
    currentPageNumberInfantil = currentPageNumberInfantil +1;
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
}



@end

