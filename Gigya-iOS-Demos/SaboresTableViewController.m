//
//  SaboresTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "SaboresTableViewController.h"
#import  "CategoriasTableViewCell.h"
#import  "DestacadoTableViewCell.h"
#import  "DetalleBeneficioViewController.h"
#import "Category.h"
#import "Benefit.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"
#import "SVPullToRefresh.h"

@interface SaboresTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SaboresTableViewController
@synthesize benefitsItemsArray5;
@synthesize tableView;
NSMutableArray *listaCategorias;
NSMutableArray *listaBeneficios;

int currentPageNumber ;
BOOL isPageRefreshing =  false;
BOOL firstTime = false;


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak SaboresTableViewController *weakSelf = self;

    SessionManager *sesion = [SessionManager session];
    listaCategorias = [[NSMutableArray alloc] init];
    benefitsItemsArray5 = [[NSMutableArray alloc] init];
    listaCategorias = sesion.categoryList;
    //NSLog(@"La lista de categorias es: %@",listaCategorias.description);
    //[self loadBenefitsForCategoryId:39];
    currentPageNumber = 1;
    firstTime = true;
    
    [self loadBenefitsForCategoryId:39];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];

       // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshing = NO;
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
    return self.benefitsItemsArray5.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
static NSString *simpleTableIdentifier = @"ClubCategoryTableCell5";
    NSArray *nib;
    
    if (indexPath.row==0) {
        DestacadoTableViewCell *cell = (DestacadoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DestacadoTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            Benefit *beneficio = [self.benefitsItemsArray5 objectAtIndex:0];
            
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
        
        CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Benefit *beneficio2 = [self.benefitsItemsArray5 objectAtIndex:indexPath.row];
        //[beneficio2 logDescription];
        
        cell.labelTitulo.text = beneficio2.title;
        cell.labelDescuento.text = beneficio2.desclabel;
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
        return 100.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"DETECTED");
    
    DetalleBeneficioViewController *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    Benefit *beneficio = [self.benefitsItemsArray5 objectAtIndex:indexPath.row];
    [detalleBeneficio loadBenefitForBenefitId:beneficio.idBen];
    
    //Get Image
    NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];

    detalleBeneficio.benefitImage = imagenBeneficio;
    
    detalleBeneficio.benefitTitle= beneficio.title;
    detalleBeneficio.benefitAddress = @"Nueva Providencia #283, Providencia, Santiago       A 200 metros de su ubicación";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    detalleBeneficio.benefitId = beneficio.idBen;
   // NSLog(@"ID beneficio es: %d",detalleBeneficio.benefitId);
    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];
}

-(void)loadBenefitsForCategoryId:(int)idCategory{
    
    NSLog(@"Load category benefits Sabores");
     __weak SaboresTableViewController *weakSelf = self;
    // IMPORTANT - Only update the UI on the main thread
    if (isPageRefreshing == false)
    [SVProgressHUD showWithStatus:@"Obteniendo beneficios disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    
    [connectionManager getPagedBenefitsForCategoryId :^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshing == false){
                    
                [self errorDetectedWithNSError:error];
                }else{
                    [weakSelf.tableView endUpdates];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
            } else {
                
                 NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    
                    isPageRefreshing = YES;
                    
                }else{
                    
                [self reloadBenefitsDataFromService:arrayJson];
                // NSLog(@"Lista jhson: %@",arrayJson);
              }
            }
        });
    }:idCategory andPage:currentPageNumber];
    
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    
    
    __weak SaboresTableViewController *weakSelf = self;
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
        
        [self.benefitsItemsArray5 addObject:beneficio];

    }
    
    if (firstTime ==true){
    self.view.alpha = 0.0;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5
                     animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                         
                     }
                     completion:^(BOOL finished)
     {
         [SVProgressHUD dismiss];
     }];
        firstTime = false;
    }else{
         [self.tableView reloadData];
         [SVProgressHUD dismiss];
        isPageRefreshing = NO;
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
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumber);

            NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumber);
            isPageRefreshing = YES;
            //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
            currentPageNumber = currentPageNumber +1;
            [self loadBenefitsForCategoryId:39];

}



/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumber);
    
    CGFloat maxPosition = scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height;
    CGFloat currentPosition = scrollView.contentOffset.y + self.topLayoutGuide.length;
    //NSLog(@" Current Position: %f",currentPosition);
   // NSLog(@"Max Position: %f",maxPosition);

   if (currentPosition == maxPosition) {
         NSLog(@"Estoy accaaaaa adentro, pagerefreshing: %d",isPageRefreshing);
      
        if(isPageRefreshing == NO){ // no need to worry about threads because this is always on main thread.
             NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumber);
            isPageRefreshing = YES;
            //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
            currentPageNumber = currentPageNumber +1;
            [self loadBenefitsForCategoryId:39];
        }
    }
    
}
*/


@end
