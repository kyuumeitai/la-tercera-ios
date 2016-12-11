//
//  ConcursosTableViewController.m
//  La Tercera
//
//  Created by Mario Alejandro on 11-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConcursosTableViewController.h"
#import "BeneficioGeneralTableViewCell.h"
#import "BeneficioGeneralDestacadoTableViewCell.h"
#import  "DetalleConcursosViewController.h"
#import "Category.h"
#import "Concurso.h"
#import "SessionManager.h"
#import "ConnectionManager.h"
#import "SVProgressHUD.h"
#import "Tools.h"
#import "SVPullToRefresh.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

#define benefitCategoryId 39




@interface ConcursosTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ConcursosTableViewController
@synthesize concursosItemsArray;
@synthesize tableView;
NSMutableArray *listaCategoriasConcursos;
NSMutableArray *listaBeneficiosConcursos;
NSString *storyBoardNameConcursos;

//New Pagination code
int currentPageNumberConcursos ;
BOOL isPageRefreshingConcursos =  false;
BOOL firstTimeConcursos = false;


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak ConcursosTableViewController *weakSelf = self;
    
    SessionManager *sesion = [SessionManager session];
    storyBoardNameConcursos = sesion.storyBoardName;
    //listaCategoriasConcursos = [[NSMutableArray alloc] init];
    concursosItemsArray = [[NSMutableArray alloc] init];
    //listaCategoriasConcursos = sesion.categoryList;
    currentPageNumberConcursos = 1;
    firstTimeConcursos = true;
    
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingConcursos = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Beneficios/concursos"];
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
    return self.concursosItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ClubCategoryTableCell5";
    NSArray *nib;
    
    if (indexPath.row==0) {
        BeneficioGeneralDestacadoTableViewCell *cell = (BeneficioGeneralDestacadoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            if([storyBoardNameConcursos isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameConcursos isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralDestacadoTableViewCell" owner:self options:nil];
            }
            //
            cell = [nib objectAtIndex:0];
            Concurso *concurso = [self.concursosItemsArray objectAtIndex:0];
            
            cell.labelTitulo.text = concurso.title;
            cell.labelSubtitulo.text = concurso.summary;
            cell.labelDescuento.text = concurso.desclabel;
            
            if((unsigned long)concurso.desclabel.length >3)
                cell.labelDescuento.alpha = 0;
            
            //Get Image
            
            NSArray * arr = [concurso.imagenNormalString componentsSeparatedByString:@","];
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
            if([storyBoardNameConcursos isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameConcursos isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell-iPhone4-5" owner:self options:nil];
            }else{
                
                nib = [[NSBundle mainBundle] loadNibNamed:@"BeneficioGeneralTableViewCell" owner:self options:nil];
            }
            
            cell = [nib objectAtIndex:0];
        }
        
        Concurso *concurso2 = [self.concursosItemsArray objectAtIndex:indexPath.row];
        [concurso2 logDescription];
        
        cell.labelTitulo.text = concurso2.title;
        cell.labelDescuento.text = concurso2.desclabel;
        cell.labelSubtitulo.text = concurso2.summary;
        if((unsigned long)concurso2.desclabel.length >3)
            cell.labelDescuento.alpha = 0;
        //Get Image
        NSArray * arr2 = [concurso2.imagenNormalString componentsSeparatedByString:@","];
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
    
    DetalleConcursosViewController *detalleConcurso = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleConcursoViewController"];
    
    
    Concurso *concurso = [self.concursosItemsArray objectAtIndex:indexPath.row];
    
    [detalleConcurso loadContestForContestId:concurso.idConcurso];
    
    //Get Image
    NSArray * arr = [concurso.imagenNormalString componentsSeparatedByString:@","];
    UIImage *imagenBeneficio = nil;
    
    //Now data is decoded. You can convert them to UIImage
    imagenBeneficio = [Tools decodeBase64ToImage:[arr lastObject]];
    if(imagenBeneficio == nil)
        imagenBeneficio = [UIImage imageNamed:@"PlaceholderHeaderClub"];
    
    detalleConcurso.concursoImage = imagenBeneficio;
    
    detalleConcurso.concursoTitle = concurso.title;
   // detalleConcurso.benefitAddress = @"";
   // detalleBeneficio.benefitDiscount= concurso.desclabel;
    detalleConcurso.concursoDescription = concurso.summary;
    detalleConcurso.concursoId = concurso.idConcurso;
    [concurso logDescription];
    
    [self.navigationController pushViewController: detalleConcurso animated:YES];
}

-(void)loadBenefitsForCategoryId:(int)idCategory{
    
    NSLog(@"Load category benefits Concursos");
    __weak ConcursosTableViewController *weakSelf = self;
    // IMPORTANT - Only update the UI on the main thread
    if (isPageRefreshingConcursos == false)
        [SVProgressHUD showWithStatus:@"Obteniendo concursos disponibles" maskType:SVProgressHUDMaskTypeClear];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    
    //for Paging purposes
    
    [connectionManager getPagedContests:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingConcursos == false){
                    
                    [self errorDetectedWithNSError:error];
                }else{
                    [weakSelf.tableView endUpdates];
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
            } else {
                
                NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    
                    isPageRefreshingConcursos = YES;
                    
                }else{
                    
                    [self reloadBenefitsDataFromService:arrayJson];
                     NSLog(@"Lista jhson: %@",arrayJson);
                }
            }
        });
    }forPage:currentPageNumberConcursos];
    
}

-(void) reloadBenefitsDataFromService:(NSArray*)arrayJson{
    
    
    __weak ConcursosTableViewController *weakSelf = self;
    NSLog(@"  reload Concursos");
    //benefitsItemsArray5 = [[NSMutableArray alloc] init];
    
    NSDictionary *tempDict = (NSDictionary*)arrayJson;
    
    id benefits = [tempDict objectForKey:@"results"];
    
    for (id benefit in benefits){
        
        id titleBen = [benefit objectForKey:@"titulo"];
        int idBen =[ [benefit objectForKey:@"id"] intValue];;
        //NSLog(@"idBen :%d",idBen);
        id linkBen = [benefit objectForKey:@"url"] ;
        id summaryBen = [benefit objectForKey:@"description"] ;
        id benefitLabelBen = [benefit objectForKey:@"benefit_label"] ;
        
        
        Concurso *concurso = [[Concurso alloc] init];
        concurso.idConcurso = idBen;
        concurso.title = titleBen;
        concurso.url = linkBen;
        concurso.summary= summaryBen;
        concurso.desclabel = benefitLabelBen;
        
        if([benefit objectForKey:@"image"] != [NSNull null]){
            
            NSString *imagenBen = [benefit objectForKey:@"image"] ;
            concurso.imagenNormalString = imagenBen;
        }
        
        [self.concursosItemsArray addObject:concurso];
        
    }
    
    if (firstTimeConcursos ==true){
        self.view.alpha = 0.0;
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             [SVProgressHUD dismiss];
         }];
        firstTimeConcursos = false;
    }else{
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        isPageRefreshingConcursos = NO;
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
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberConcursos);
    
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberConcursos);
    isPageRefreshingConcursos = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberConcursos = currentPageNumberConcursos +1;
    [self loadBenefitsForCategoryId:benefitCategoryId];
    
}
@end
