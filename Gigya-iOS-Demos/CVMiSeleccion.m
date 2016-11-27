//
//  CVMiSeleccion.m
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 18-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import "CVMiSeleccion.h"
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
#import "ContentType.h"
#import "HeaderMiSeleccionReusableView.h"

#define categoryIdName @"lt"
#define categorySlug @"home"
#define categoryTitle @"Inicio"

@interface CVMiSeleccion ()

@end

@implementation CVMiSeleccion
@synthesize headlinesArray;
@synthesize collectionView;
@synthesize categoryId;
@synthesize categoryIdsArray,categoryNamesArray,arrayOfArrays;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";
BOOL _isScrolling;
int indiceArrayOfArrays;

//New Pagination code
int currentPageNumberMiSeleccion ;
BOOL isPageRefreshingMiSeleccion =  false;
BOOL firstTimeMiSeleccion = false;
NSArray *bannersMiSeleccion= nil;
BOOL _isScrollingMiSeleccion;
int numeroPaginasMiSeleccion;
NSString *dayMiSeleccion;
NSString *monthMiSeleccion;
NSString *yearMiSeleccion;
NSString *storyBoardNameMiSeleccion;

NSMutableArray *relatedIdsArrayMiSeleccion;

- (void) viewDidLoad{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectionItems) name:@"agregandoCategoriaAMiSeleccion" object:nil];
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardNameMiSeleccion = sesion.storyBoardName;
    indiceArrayOfArrays = 0;
    NSLog(@" El nombre del storyboard es: %@", storyBoardNameMiSeleccion);
     headlinesArray = [[NSMutableArray alloc] init];
    __weak CVMiSeleccion *weakSelf = self;
   
   
    categoryIdsArray = [[NSMutableArray alloc] init];
    categoryNamesArray = [[NSMutableArray alloc] init];
    bannersMiSeleccion = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/mi-seleccion_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    }
    
    
    //Celda Mediana
    UINib *cellNib2 ;
    
    if([storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana4-5" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"collectionViewMediana4-5"];
        
    }else{
        
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    }
    
    
    //Celda Horizontal
    UINib *cellNib3 ;
    
    if([storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal4-5" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:@"collectionViewHorizontal4-5"];
        
    }else{
        
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    }
    
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    currentPageNumberMiSeleccion = 1;
    firstTimeMiSeleccion = true;
    self.categoryNamesArray = [sesion getMiSeleccionCategoryTitlesArray];
    
    self.categoryIdsArray  = [sesion getMiSeleccionCategoryIdsArray];
    
    NSLog(@"CategoryId: %d", self.categoryId);
    NSLog(@"CategoryNamesArray: count:%lu and array %@",(unsigned long)self.categoryIdsArray.count, self.categoryNamesArray);
    
    int count = self.categoryIdsArray.count;
    
    arrayOfArrays  = [[NSMutableArray alloc] init];
    
    NSLog(@"CategoryNamesArray normal:%i",count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        for (int indice = 0; indice < count;indice++){
            NSLog(@"EL Indice de los ids es: %i",indice);
        self.categoryId = [self.categoryIdsArray[indice] intValue];
              NSLog(@"self.categoryId es: %i",self.categoryId);
        [self loadHeadlinesWithCategory:self.categoryId];
        }
    });

}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingMiSeleccion = NO;
}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines for idCategory: %d",idCategory);
    
    __weak CVMiSeleccion *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingMiSeleccion == false){
                    
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
                    
                    isPageRefreshingMiSeleccion = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                  // NSLog(@"Lista headlines jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:1];
    

}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak CVMiSeleccion *weakSelf = self;
    NSLog(@">>>>>>>>>>  empieza el mambo headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    NSLog(@"  Los titulares son: headlines array, is: %@ ",diccionarioTitulares);
    NSArray* arrayTitulares = [[NSArray alloc] init];
    arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    relatedIdsArrayMiSeleccion = [[NSMutableArray alloc]initWithCapacity:9999];
    
    [headlinesArray removeAllObjects];
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
        //NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        //id title = [dictTitular objectForKey:@"title"];
        NSNumber *artId = [NSNumber numberWithInteger:[idArt intValue] ];
        [relatedIdsArrayMiSeleccion addObject: artId];
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
        
        /*
        NSLog(@"____ Numero de pagina: %d", currentPageNumberMiSeleccion);
        if (indice == currentPageNumberMiSeleccion*6 ){
         
            [headlinesArray addObject:@"OBJETO"];
        }
         */
        //[titular logDescription];
         NSLog(@"____ El titular es: %@", titular.title);
        [headlinesArray addObject:titular];
        if (indice == 10){
            NSLog(@"____ El INDICE ES: %i",indiceArrayOfArrays);
            [arrayOfArrays insertObject:headlinesArray atIndex:indiceArrayOfArrays];
            indiceArrayOfArrays++;
        }
    }

    //New code
    if (firstTimeMiSeleccion ==true){
        self.view.alpha = 0.0;
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeMiSeleccion= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingMiSeleccion= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        //NSLog(@"LA cantidad es: %lu",arrayOfArrays.count);
    }
    NSLog(@" ******* RELOAD DATA TABLEEE ****** ----------------------");

}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return categoryNamesArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    int i=0;
    
    for (NSArray *item in arrayOfArrays) {
        
        
        if (section==i) {
            
            NSLog(@"%lu",(unsigned long)item.count);
            
            return item.count;
        }
        
        
        i++;
        
    }

    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
   // Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    NSLog(@"[indexPath section] %li",(long)[indexPath section]);
    NSLog(@"[arrayOfArrays  objectAtIndex:[indexPath section]] %@",[arrayOfArrays  objectAtIndex:[indexPath section]]);
    id object;
    int indiceArray = 0;
    int indiceHeadline = 0;
    for (object in arrayOfArrays) {

        Headline* headline;
        for (headline in object) {
            NSLog(@"____ Del Array de indice: %i y Del iondice: %i,Headline titular: %@",indiceArray,indiceHeadline ,headline.title );
            indiceHeadline++;
        }
        // NSLog(@"____ cOIbjetoo titular: %@",(Headline*)[object title] );
        indiceArray++;
    }

    NSInteger idpSection = [indexPath section];
    NSInteger idpRow = [indexPath item];
    Headline *titular =  arrayOfArrays[idpSection][idpRow];
    
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0 || indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0 || indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0) {
        
        CollectionViewCellGrande *cell;
        if([storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
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
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
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

  /*
    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 )
    {
        
        
        switch (indexPath.item) {
            case 5:
                celdaBanner.bannerUnitID =  bannersMiSeleccion[0]  ;
                break;
            case 11:
                
                celdaBanner.bannerUnitID =  bannersMiSeleccion[1]  ;
                
                break;
            case 17:
                
                celdaBanner.bannerUnitID =  bannersMiSeleccion[2]  ;
                
                break;
            case 23:
                
                celdaBanner.bannerUnitID =  bannersMiSeleccion[3]  ;
                
                break;
            default:
                celdaBanner.bannerUnitID =  bannersMiSeleccion[2]  ;
                
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
        
     
        if(_isScrollingMiSeleccion == false){
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
    */
    CollectionViewCellBanner *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
    
    return cell;
 
    
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ENtonces el indexpath es: %ld",(long)[indexPath row]);
   /* if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return ;
        
    }else{
    */
        Headline *titular = (Headline*)[headlinesArray objectAtIndex:indexPath.row ];
        [titular logDescription];
        int idArticulo = titular.idArt;
        NSLog(@"id Artículo = %d",idArticulo);
        DetalleNewsViewController *detalleNews =  (DetalleNewsViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"DetalleNewsCategory"];
     detalleNews.relatedIdsArray = relatedIdsArrayMiSeleccion;
        [detalleNews loadBenefitForBenefitId:idArticulo andCategory:categoryTitle];
        [self.navigationController pushViewController:detalleNews animated:YES];
    //}
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberMiSeleccion);
    /*
    isPageRefreshingMiSeleccion = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberMiSeleccion = currentPageNumberMiSeleccion +1;
    [self loadHeadlinesWithCategory:categoryId];
     */
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if((indexPath.item == 0 || indexPath.item % 6 == 0 || indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0 || indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0)){
        
        if([storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameMiSeleccion isEqualToString:@"LaTerceraStoryboard-iPhone5"]){Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
            NSString *titulo = titular.title;
            NSString *resumen = titular.summary;
            float characterCountTitulo = [titulo length];
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
            float characterCountTitulo = [titulo length];
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
/*
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return CGSizeMake(350, 265);
        
    }
  */
    return CGSizeMake(350, 428);
    
}

//New code

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderMiSeleccionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"categoryHeader" forIndexPath:indexPath];
        NSString *title = self.categoryNamesArray[indexPath.section];
       // indexPath.section + 1];
        headerView.categoryTitleLabel.text = title;
        //UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
 
    return reusableview;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollingMiSeleccion = NO;
}

- (void)updateSelectionItems{
    NSLog(@"................::::::^^^^^  Parece que tu quieres salsaaaa! ::::::^^^^^................");
    [self viewDidLoad];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isScrollingMiSeleccion = NO;
    }
}

@end
