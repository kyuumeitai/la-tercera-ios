//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import "CVNoticiasTendencias.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellMediana.h"
#import "CollectionViewCellHorizontal.h"
#import "CollectionViewCellBanner.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "Headline.h"
#import "DetalleNewsViewController.h"
#import "Article.h"
#import "UIImageView+AFNetworking.h"
#import "SessionManager.h"
#import "SVPullToRefresh.h"
#import "ContentType.h"
#import "SVProgressHUD.h"

//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categorySlug @"tendencias"
#define categoryTitle @"Tendencias"

@implementation CVNoticiasTendencias

@synthesize headlinesArray;
@synthesize collectionView;
@synthesize categoryIdNoticiasTendencias;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";

//New Pagination code
int currentPageNumberTendencias ;
BOOL isPageRefreshingTendencias =  false;
BOOL firstTimeTendencias = false;
NSArray *bannersTendencias= nil;
BOOL _isScrollingTendencias;
int numeroPaginasNoticiasTendencias;
NSString *dayNoticiasTendencias;
NSString *monthNoticiasTendencias;
NSString *yearNoticiasTendencias;
NSString *storyBoardNameNoticiasTendencias;
//int categoryId;
NSMutableArray *relatedIdsArrayTendencias;


- (void) viewDidLoad{
    categoryIdNoticiasTendencias = 0;

    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardNameNoticiasTendencias = sesion.storyBoardName;
    
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            categoryIdNoticiasTendencias = contenido.contentId;
    }
    
    NSLog(@" El nombre del storboard es: %@", storyBoardNameNoticiasTendencias);
    NSLog(@"CategoryId: %d", self.categoryIdNoticiasTendencias);

    __weak CVNoticiasTendencias *weakSelf = self;
    headlinesArray = [[NSMutableArray alloc] init];
    
    bannersTendencias = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/tendencias_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/tendencias_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/tendencias_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/tendencias_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/tendencias_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    /*
    //Celda Mediana
    UINib *cellNib2 ;
    
    if([storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana4-5" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"collectionViewMediana4-5"];
        
    }else{
        
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    }
    
    
    //Celda Horizontal
    UINib *cellNib3 ;
    
    if([storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal4-5" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:@"collectionViewHorizontal4-5"];
        
    }else{
        
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    }
    
    */
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumberTendencias = 1;
    firstTimeTendencias = true;
    
    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [self loadHeadlinesWithCategory:self.categoryIdNoticiasTendencias];
    });
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
    
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
//    refreshControl.tintColor = [UIColor colorWithRed:0.686 green:0.153 blue:0.188 alpha:1];
//    self.collectionView.refreshControl = refreshControl;
}

-(void)startRefresh{
    
    [self viewDidLoad];
    [SVProgressHUD showWithStatus:@"Actualizando noticias" maskType:SVProgressHUDMaskTypeClear];
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingTendencias = NO;
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"app will enter foreground");
    //[self startRefresh];
}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak CVNoticiasTendencias *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingTendencias == false){
                    
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
                    
                    isPageRefreshingTendencias = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                  //NSLog(@"Lista headlines jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberTendencias];
    
}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak CVNoticiasTendencias *weakSelf = self;
    NSLog(@"  reload headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    
    relatedIdsArrayTendencias = [[NSMutableArray alloc]initWithCapacity:9999];
    
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
        NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        //id title = [dictTitular objectForKey:@"title"]
        NSNumber *artId = [NSNumber numberWithInteger:[idArt intValue] ];
        [relatedIdsArrayTendencias addObject: artId];
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
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumberTendencias);
        if (indice == currentPageNumberTendencias*6 ){
            NSLog(@"____ currentPageNumberTendencias*6: %d", currentPageNumberTendencias*6);
            [headlinesArray addObject:@"OBJETO"];
        }
        //[titular logDescription];
        
        [headlinesArray addObject:titular];
    }
    
    //New code
    if (firstTimeTendencias ==true){
        self.view.alpha = 0.0;
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             [SVProgressHUD dismiss];
         }];
        firstTimeTendencias= false;
    }else{
        
        [SVProgressHUD dismiss];
        isPageRefreshingTendencias= NO;
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


//Changes
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0 || indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0 || indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0 ) {
        
        CollectionViewCellGrande *cell;
        if([storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
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
        
        CollectionViewCellBanner *celdaBanner;
        celdaBanner = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        

        switch (indexPath.item) {
            case 5:
                celdaBanner.bannerUnitID =  bannersTendencias[0]  ;
                break;
            case 11:
                
                celdaBanner.bannerUnitID =  bannersTendencias[1]  ;
                
                break;
            case 17:
                
                celdaBanner.bannerUnitID =  bannersTendencias[2]  ;
                
                break;
            case 23:
                
                celdaBanner.bannerUnitID =  bannersTendencias[3]  ;
                
                break;
            default:
                celdaBanner.bannerUnitID =  bannersTendencias[2]  ;
                
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
        
        if(_isScrollingTendencias == false){
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
        detalleNews.idCategoria = self.categoryIdNoticiasTendencias;
        detalleNews.relatedIdsArray = relatedIdsArrayTendencias;
         [detalleNews loadBenefitForBenefitId:idArticulo andCategory:categoryTitle];   //detalleNews.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController pushViewController:detalleNews animated:YES];
    }
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberTendencias);
    isPageRefreshingTendencias = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberTendencias = currentPageNumberTendencias +1;
    [self loadHeadlinesWithCategory:categoryIdNoticiasTendencias];
    
}

//other change
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([indexPath row]==0 || [indexPath row] % 6 == 0 || [indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 || [indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
        
        if([storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameNoticiasTendencias isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
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
            float characterCountTitulo = [titulo length]+4;
            //NSLog(@"characterCountTitulo: %f",characterCountTitulo);
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
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollingTendencias = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isScrollingTendencias = NO;
    }
}

@end
