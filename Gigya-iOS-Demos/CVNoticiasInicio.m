//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import "CVNoticiasInicio.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellMediana.h"
#import "CollectionViewCellHorizontal.h"
#import "CollectionViewCellBanner.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "Headline.h"
#import "Article.h"
#import "UIImageView+AFNetworking.h"
#import "DetalleNewsViewController.h"
#import "SessionManager.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "ContentType.h"
//#import "UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categorySlug @"home"
#define categoryTitle @"Inicio"

@implementation CVNoticiasInicio
@synthesize categoryIdNoticiasInicio;

@synthesize headlinesArray;
@synthesize collectionView;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";
BOOL _isScrollingInicio;
//New Pagination code
int currentPageNumberInicio ;
BOOL isPageRefreshing =  false;
BOOL firstTime = false;
NSArray *banners= nil;
//int categoryId;
int numeroPaginasNoticiaInicio;
NSString *dayInicio;
NSString *monthInicio;
NSString *yearInicio;
NSString *storyBoardNameInicio;

BOOL nibMyCellloaded;
BOOL nibMyCell2loaded;

NSMutableArray *relatedIdsArrayInicio;

- (void) viewDidLoad{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    SessionManager *sesion = [SessionManager session];
    storyBoardNameInicio = sesion.storyBoardName;
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug]){
            self.categoryIdNoticiasInicio = contenido.contentId;
            NSLog(@"ESTAMOS OKEYYY %d", self.categoryIdNoticiasInicio);
        }

    }

    NSLog(@" El nombre del storboard es: %@", storyBoardNameInicio);
    NSLog(@"CategoryId: %d", self.categoryIdNoticiasInicio);
    
    __weak CVNoticiasInicio *weakSelf = self;
    headlinesArray = [[NSMutableArray alloc] init];
    
    banners = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/inicio_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/inicio_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/inicio_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/inicio_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/inicio_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
        // Set the estimated width of the cells to half the screen width (2 columns layout)


    }
    
    /*
    //Celda Mediana
    UINib *cellNib2 ;
    
    if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana4-5" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"collectionViewMediana4-5"];
        
    }else{
        
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    }
    
    
    //Celda Horizontal
    UINib *cellNib3 ;
    
    if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal4-5" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:@"collectionViewHorizontal4-5"];
        
    }else{
        
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    }
    
    */
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    currentPageNumberInicio = 1;
    firstTime = true;

    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        NSLog(@"CategoryId: %d", self.categoryIdNoticiasInicio);
        
        [self loadHeadlinesWithCategory:self.categoryIdNoticiasInicio];
    });
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
    
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
//    refreshControl.tintColor = [UIColor colorWithRed:0.686 green:0.153 blue:0.188 alpha:1];
//    self.collectionView.refreshControl = refreshControl;
//
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshing = NO;

}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"app will enter foreground");
    //[self startRefresh];
}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak CVNoticiasInicio *weakSelf = self;
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshing == false){
                    
                    //[self errorDetectedWithNSError:error];
                }else{
                    //[self.collectionView reloadData];
                    //[self.collectionView layoutIfNeeded];
                    [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                }
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            }
            else {
                
                NSDictionary *tempDict = (NSDictionary*)arrayJson;
                id noData = [tempDict objectForKey:@"details"];
                
                if(noData){
                    
                    isPageRefreshing = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                    //NSLog(@"Lista headlines jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberInicio];
    
}

-(void)startRefresh{
    if(headlinesArray.count >0){
    [self loadHeadlinesWithCategory:self.categoryIdNoticiasInicio];
       [SVProgressHUD showWithStatus:@"Actualizando noticias" maskType:SVProgressHUDMaskTypeClear];
    }
}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak CVNoticiasInicio *weakSelf = self;
    NSLog(@"  reload headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    relatedIdsArrayInicio = [[NSMutableArray alloc]initWithCapacity:9999];
    
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
       // NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        // id title = [dictTitular objectForKey:@"title"];
        NSNumber *artId = [NSNumber numberWithInteger:[idArt intValue] ];
        [relatedIdsArrayInicio addObject: artId];
        id summary = [dictTitular objectForKey:@"short_description"];
        id imageThumb ;
        
        //if ([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]){
        if ([dictTitular objectForKey:@"image_url"] == (id)[NSNull null]){
            imageThumb = @"http://ltrest.multinetlabs.com/static/lt-default.png";
        }else{
            imageThumb = [dictTitular objectForKey:@"image_url"];
            //imageThumb = [dictTitular objectForKey:@"thumb_url"];
            NSLog(@" el thumbnail  es: %@ ",imageThumb);
        }
        
        Headline *titular = [[Headline alloc] init];
        titular.idArt = [idArt intValue];
        NSString *title= [[dictTitular objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        title = [title stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        
        titular.title = title;
        titular.summary = summary;
        titular.imagenThumbString = imageThumb;
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumberInicio);
        if (indice == currentPageNumberInicio*6 ){
            NSLog(@"____ currentPageNumberInicio*6: %d", currentPageNumberInicio*6);
            [headlinesArray addObject:@"OBJETO"];
        }
        //[titular logDescription];
        
        [headlinesArray addObject:titular];
    }
    
    //New code
    if (firstTime ==true){
        self.view.alpha = 0.0;
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
            [SVProgressHUD dismiss];
         }];
        firstTime= false;
    }else{
        
        [SVProgressHUD dismiss];
        isPageRefreshing= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        NSLog(@"LA cantidad es: %lu",(unsigned long)headlinesArray.count);
    }
    

    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");
}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [headlinesArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellBanner *celdaBanner;
    
    
    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0 || indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0 || indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0 ) {
        
        CollectionViewCellGrande *cell;
        if([storyBoardNameInicio  isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            cell  =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewGrande4-5" forIndexPath:indexPath];
            
        }else{
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
            
        }
        // Configure the cell
        cell.labelTituloNews.text = titular.title;
        
        cell.labelSummary.text = titular.summary;
        
        NSString *nameImagen = titular.imagenThumbString;
        NSURL *urlImagen = [NSURL URLWithString:nameImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:urlImagen];
        UIImage *placeholderImage = [UIImage imageNamed:@" "];
        __weak CollectionViewCellGrande *weakCell = cell;
        
        //[cell.imageNews sd_setImageWithURL:urlImagen];
        [cell.imageNews setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.imageNews.image = image;
                                        
                                           //[weakCell setNeedsLayout];
                                       } failure:nil];
        
        return cell;
    }
    
    
    
    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 )
    {
        
        celdaBanner = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];

        switch (indexPath.item) {
            case 5:
                celdaBanner.bannerUnitID =  banners[0]  ;
                break;
            case 11:
                
                celdaBanner.bannerUnitID =  banners[1]  ;
                
                break;
            case 17:
                
                celdaBanner.bannerUnitID =  banners[2]  ;
                
                break;
            case 23:
                
                celdaBanner.bannerUnitID =  banners[3]  ;
                
                break;
            default:
                celdaBanner.bannerUnitID =  banners[2]  ;
                
                break;
        }
        
        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO){
            
            for(UIView* view in celdaBanner.contentView.subviews) {
                if([view isKindOfClass:[DFPBannerView class]]) {
                    [view removeFromSuperview];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [celdaBanner cellBannerView:self];
            });
        }
        
        if(_isScrollingInicio == false){
            for(UIView* view in celdaBanner.contentView.subviews) {
                if([view isKindOfClass:[DFPBannerView class]]) {
                    [view removeFromSuperview];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [celdaBanner cellBannerView:self];
            });
        }
        
        return celdaBanner;
        
    }
    
    CollectionViewCellBanner *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
    
    return cell;
//    CollectionViewCellBanner *celdaBanner;
//    celdaBanner = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
//    
//    
//    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
//    
//    if (indexPath.item == 0 || indexPath.item % 6 == 0) {
//        
//        CollectionViewCellGrande *cell;
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            cell  =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewGrande4-5" forIndexPath:indexPath];
//            
//        }else{
//            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
//            
//        }
//        // Configure the cell
//        cell.labelTituloNews.text = titular.title;
//        [cell.labelTituloNews sizeToFit];
//        cell.labelSummary.text = titular.summary;
//        NSString *urlImagen = titular.imagenThumbString;
//        NSURL *url = [NSURL URLWithString:urlImagen];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        UIImage *placeholderImage = [UIImage imageNamed:@"placeholderWhite"];
//        
//        //__weak UITableViewCell *weakCell = cell;
//        
//        __weak CollectionViewCellGrande *weakCell = cell;
//        
//        
//        [cell.imageNews setImageWithURLRequest:request
//                              placeholderImage:placeholderImage
//                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                           weakCell.imageNews.image = image;
//                                           //[weakCell setNeedsLayout];
//                                       } failure:nil];
//        
//        return cell;
//    }
//    
//    if (indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0  )
//    {
//        
//        
//        CollectionViewCellMediana *cell;
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            cell  =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewMediana4-5" forIndexPath:indexPath];
//            
//        }else{
//            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMediana forIndexPath:indexPath];
//            
//        }
//        
//        // Configure the cell
//        // cell.labelTituloNews.text = titular.title;
//        cell.labelSummary.text = titular.title;
//        NSString *urlImagen = titular.imagenThumbString;
//        NSURL *url = [NSURL URLWithString:urlImagen];
//        UIImage *placeholderImage = [UIImage imageNamed:@"placeholderWhite"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        
//        __weak CollectionViewCellMediana *weakCellMediana = cell;
//        
//        [cell.imageNews setImageWithURLRequest:request
//                              placeholderImage:placeholderImage
//                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                           weakCellMediana.imageNews.image = image;
//                                           //[weakCellMediana setNeedsLayout];
//                                       } failure:nil];
//        
//        return cell;
//        
//    }
//    
//    if (indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0 )
//    {
//        
//        
//        CollectionViewCellHorizontal *cell;
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            cell  =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewHorizontal4-5" forIndexPath:indexPath];
//            
//        }else{
//            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHorizontal forIndexPath:indexPath];
//            
//        }
//        
//        // Configure the cell
//        cell.labelSummary.text = titular.title;
//        NSString *urlImagen = titular.imagenThumbString;
//        NSURL *url = [NSURL URLWithString:urlImagen];
//        UIImage *placeholderImage = [UIImage imageNamed:@"placeholderWhite"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        
//        __weak CollectionViewCellHorizontal *weakCellHorizontal = cell;
//        
//        [cell.imageNews setImageWithURLRequest:request
//                              placeholderImage:placeholderImage
//                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                           
//                                           weakCellHorizontal.imageNews.image = image;
//                                           // [weakCellHorizontal setNeedsLayout];
//                                       } failure:nil];
//        
//        return cell;
//        
//    }
//    
//    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 )
//    {
//        
//        
//        switch (indexPath.item) {
//            case 5:
//                celdaBanner.bannerUnitID =  banners[0]  ;
//                break;
//            case 11:
//                
//                celdaBanner.bannerUnitID =  banners[1]  ;
//                
//                break;
//            case 17:
//                
//                celdaBanner.bannerUnitID =  banners[2]  ;
//                
//                break;
//            case 23:
//                
//                celdaBanner.bannerUnitID =  banners[3]  ;
//                
//                break;
//            default:
//                celdaBanner.bannerUnitID =  banners[2]  ;
//                
//                break;
//        }
//        
//        
//        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO){
//            
//            for(UIView* view in celdaBanner.contentView.subviews) {
//                if([view isKindOfClass:[DFPBannerView class]]) {
//                    [view removeFromSuperview];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [celdaBanner cellBannerView:self];
//            });
//        }
//        
//        if(_isScrollingInicio == false){
//            for(UIView* view in celdaBanner.contentView.subviews) {
//                if([view isKindOfClass:[DFPBannerView class]]) {
//                    [view removeFromSuperview];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [celdaBanner cellBannerView:self];
//            });
//        }
//        
//        return celdaBanner;
//        
//    }
//    
//    CollectionViewCellBanner *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
//    
//    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ENtonces el indexpath es: %ld",(long)[indexPath row]);
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return ;
        
    }else{
        Headline *titular = (Headline*)[headlinesArray objectAtIndex:indexPath.row ];
        [titular logDescription];
        int idArticulo = titular.idArt;
        NSLog(@"id Artículo = %d",idArticulo);
        DetalleNewsViewController *detalleNews =  (DetalleNewsViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"DetalleNewsCategory"];
         detalleNews.relatedIdsArray = relatedIdsArrayInicio;
        [detalleNews loadBenefitForBenefitId:idArticulo andCategory:categoryTitle];
        detalleNews.idCategoria = self.categoryIdNoticiasInicio;
        [self.navigationController pushViewController:detalleNews animated:YES];
    }
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberInicio);
    isPageRefreshing = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberInicio = currentPageNumberInicio +1;
    [self loadHeadlinesWithCategory:categoryIdNoticiasInicio];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([indexPath row]==0 || [indexPath row] % 6 == 0 || [indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 || [indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
        
        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
            NSString *titulo = titular.title;
            NSString *resumen = titular.summary;
            float characterCountTitulo = [titulo length]+4;
            //NSLog(@"characterCountTitulo: %f",characterCountTitulo);
            float characterCountResumen = [resumen length]+5;
            //NSLog(@"characterCountResumne: %f",characterCountResumen);
            int cantLineasTitulo= ceil(characterCountTitulo/26);
            //NSLog(@"cantLineasTitulo: %d",cantLineasTitulo);
            int cantLineasSummary= floor(characterCountResumen/39);
            //NSLog(@"cantLineasSummary: %d",cantLineasSummary);
            cantLineasTitulo = (cantLineasTitulo==0) ? 1 : cantLineasTitulo;
            //NSLog(@"cantLineasTitulo final: %d",cantLineasTitulo);
            cantLineasSummary = (cantLineasSummary==0) ? 1 : cantLineasSummary;
            //NSLog(@"cantLineasSummary final: %d",cantLineasTitulo);
            cantLineasSummary = (cantLineasSummary>8) ? cantLineasSummary+1 : cantLineasSummary;
            
            //NSLog(@"Summary: %@ cantidad de lineas resumen:%d ",resumen,cantLineasSummary);
            float altoLineas = 330+(cantLineasTitulo*26)+(cantLineasSummary*16);
            //NSLog(@"Titulo: %@ cantidad de lineas:%d  y alto asignado: %f",titulo,cantLineasTitulo,altoLineas);
            
            return CGSizeMake(310,altoLineas);
            
        }else{
            Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
            NSString *titulo = titular.title;
            NSString *resumen = titular.summary;
            float characterCountTitulo = [titulo length]+4;            //NSLog(@"characterCountTitulo: %f",characterCountTitulo);
            float characterCountResumen = [resumen length]+5;
            //NSLog(@"characterCountResumne: %f",characterCountResumen);
            int cantLineasTitulo= ceil(characterCountTitulo/34);
            //NSLog(@"cantLineasTitulo: %d",cantLineasTitulo);
            int cantLineasSummary= floor(characterCountResumen/39);
            //NSLog(@"cantLineasSummary: %d",cantLineasSummary);
            cantLineasTitulo = (cantLineasTitulo==0) ? 1 : cantLineasTitulo;
            //NSLog(@"cantLineasTitulo final: %d",cantLineasTitulo);
            cantLineasSummary = (cantLineasSummary==0) ? 1 : cantLineasSummary;
            //NSLog(@"cantLineasSummary final: %d",cantLineasTitulo);
            cantLineasSummary = (cantLineasSummary>8) ? cantLineasSummary+1 : cantLineasSummary;
            
            //NSLog(@"Summary: %@ cantidad de lineas resumen:%d ",resumen,cantLineasSummary);
            float altoLineas = 320+(cantLineasTitulo*14)+(cantLineasSummary*16);
            //NSLog(@"Titulo: %@ cantidad de lineas:%d  y alto asignado: %f",titulo,cantLineasTitulo,altoLineas);
            
            return CGSizeMake(350,altoLineas);

        }
    }
    
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return CGSizeMake(300, 290);
        
    }
    
    return CGSizeMake(350, 428);
  
//    if([indexPath row]==0 || [indexPath row] % 6 == 0){
//        
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            return CGSizeMake(310, 468);
//            
//        }else{
//            return CGSizeMake(350, 420);
//        }
//    }
//    
//    if([indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 ) {
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            return CGSizeMake(154, 268);
//            
//        }else{
//            
//            return CGSizeMake(170, 262);
//            
//        }
//        
//    }
//    
//    if([indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
//        if([storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameInicio isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
//            return CGSizeMake(300, 100);
//            
//        }else{
//            return CGSizeMake(350, 100);
//        }
//        
//    }
//    
//    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
//        return CGSizeMake(300, 290);
//        
//    }
//    
//    return CGSizeMake(350, 428);
}

//New code

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollingInicio = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isScrollingInicio = NO;
    }
}

@end
