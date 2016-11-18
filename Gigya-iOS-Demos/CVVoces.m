//
//  CVVoces.m
//  La Tercera
//
//  Created by Mario Alejandro on 10-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CVVoces.h"
#import "ConnectionManager.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellMediana.h"
#import "CollectionViewCellHorizontal.h"
#import "CollectionViewCellBanner.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "Headline.h"
#import "DetalleNewsViewController.h"
#import "VocesDetailViewController.h"
#import "Article.h"
#import "UIImageView+AFNetworking.h"
#import "SessionManager.h"
#import "SVPullToRefresh.h"
#import "ContentType.h"

//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categorySlug @"voces"
#define categoryTitle @"Voces"


@interface CVVoces ()

@end

@implementation CVVoces

@synthesize headlinesArray;
@synthesize collectionView;
@synthesize categoryId;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";

static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";

//New Pagination code
int currentPageNumberVoces ;
BOOL isPageRefreshingVoces =  false;
BOOL firstTimeVoces = false;
NSArray *bannersVoces= nil;
BOOL _isScrollingVoces;
int numeroPaginasVoces;
NSString *dayVoces;
NSString *monthVoces;
NSString *yearVoces;
NSString *storyBoardNameVoces;

NSMutableArray *relatedIdsArrayVoces;


- (void) viewDidLoad{

    
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardNameVoces = sesion.storyBoardName;
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            self.categoryId = contenido.contentId;
    }
    
    
    NSLog(@" El nombre del storboard es: %@", storyBoardNameVoces);
    NSLog(@"CategoryId: %d", self.categoryId);
    __weak CVVoces *weakSelf = self;
    headlinesArray = [[NSMutableArray alloc] init];
    
    bannersVoces = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/Voces_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Voces_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Voces_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Voces_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Voces_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    }
    
    
    //Celda Mediana
    UINib *cellNib2 ;
    
    if([storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana4-5" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"collectionViewMediana4-5"];
        
    }else{
        
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    }
    
    
    //Celda Horizontal
    UINib *cellNib3 ;
    
    if([storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal4-5" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:@"collectionViewHorizontal4-5"];
        
    }else{
        
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    }
    
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumberVoces = 1;
    firstTimeVoces = true;
    
    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [self loadHeadlinesWithCategory:self.categoryId];
    });
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingVoces = NO;
}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak CVVoces *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingVoces == false){
                    
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
                    
                    isPageRefreshingVoces = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                    //NSLog(@"Lista headlines jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumberVoces];
    
}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak CVVoces *weakSelf = self;
    NSLog(@"  reload headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    relatedIdsArrayVoces = [[NSMutableArray alloc]initWithCapacity:9999];
    
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
        //NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        NSNumber *artId = [NSNumber numberWithInteger:[idArt intValue] ];
        [relatedIdsArrayVoces addObject: artId];
        //id title = [dictTitular objectForKey:@"title"];
        id summary = [dictTitular objectForKey:@"short_description"];
        
        id imageThumb ;
        
            if (([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]) || ([[dictTitular objectForKey:@"thumb_url"] isEqualToString:@""])){
            imageThumb = @"";
            }else{
            imageThumb = [dictTitular objectForKey:@"thumb_url"];
            NSLog(@" el thumbnail  es: %@ ",imageThumb);
        }
        
        Headline *titular = [[Headline alloc] init];
        titular.idArt = [idArt intValue];
        NSString *title= [[dictTitular objectForKey:@"title"] stringByReplacingOccurrencesOfString: @"&#8220;" withString:@"“"];
        title = [title stringByReplacingOccurrencesOfString: @"&#8221;" withString:@"”"];
        titular.title = title;
        titular.summary = summary;
        titular.imagenThumbString = imageThumb;
        
        //NSLog(@"____ Numero de pagina: %d", currentPageNumberVoces);
        if (indice == currentPageNumberVoces*6 ){
            //  NSLog(@"____ currentPageNumberVoces*6: %d", currentPageNumberVoces*6);
            [headlinesArray addObject:@"OBJETO"];
        }
        //[titular logDescription];
        
        [headlinesArray addObject:titular];
    }
    
    //New code
    if (firstTimeVoces ==true){
        self.view.alpha = 0.0;
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeVoces= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingVoces= NO;
        // [weakSelf.collectionView endUpdates];
        
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        //NSLog(@"LA cantidad es: %lu",(unsigned long)headlinesArray.count);
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
    
    CollectionViewCellBanner *celdaBanner;
    celdaBanner = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
    
    
    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0 || indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0 || indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0 ) {
        
        CollectionViewCellGrande *cell;
        if([storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            NSLog(@"Usaremos collectionView 4-5");
            cell  =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewGrande4-5" forIndexPath:indexPath];
            
        }else{
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
            
        }
        // Configure the cell
        cell.labelTituloNews.text = titular.title;
        
        cell.labelSummary.text = titular.summary;
        
        
        NSString *urlImagen = titular.imagenThumbString;
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder2"];
        
        //__weak UITableViewCell *weakCell = cell;
        
        __weak CollectionViewCellGrande *weakCell = cell;
        
        
        [cell.imageNews setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.imageNews.image = image;
                                           [weakCell setNeedsLayout];
                                       } failure:nil];
        
        return cell;
    }
    
    
    
    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 )
    {
        
        
        switch (indexPath.item) {
            case 5:
                celdaBanner.bannerUnitID =  bannersVoces[0]  ;
                break;
            case 11:
                
                celdaBanner.bannerUnitID =  bannersVoces[1]  ;
                
                break;
            case 17:
                
                celdaBanner.bannerUnitID =  bannersVoces[2]  ;
                
                break;
            case 23:
                
                celdaBanner.bannerUnitID =  bannersVoces[3]  ;
                
                break;
            default:
                celdaBanner.bannerUnitID =  bannersVoces[2]  ;
                
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
        
        if(_isScrollingVoces == false){
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
    //NSLog(@"ENtonces el indexpath es: %ld",(long)[indexPath row]);
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return ;
        
    }else{
        Headline *titular = (Headline*)[headlinesArray objectAtIndex:indexPath.row ];
        //[titular logDescription];
        int idArticulo = titular.idArt;
        //NSLog(@"id Artículo = %d",idArticulo);
        /*
        DetalleNewsViewController *detalleNews =  (DetalleNewsViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"DetalleNewsCategory"];
        detalleNews.idCategoria = self.categoryId;
        detalleNews.relatedIdsArray = relatedIdsArrayVoces;
        
        [detalleNews loadBenefitForBenefitId:idArticulo andCategory:categoryTitle];   //detalleNews.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController pushViewController:detalleNews animated:YES];
         */
        
        VocesDetailViewController *detalleVoces = (VocesDetailViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"detalleNewsVoces"];
        detalleVoces.idCategoria = self.categoryId;
        detalleVoces.relatedIdsArray = relatedIdsArrayVoces;
        [detalleVoces loadBenefitForBenefitId:idArticulo andCategory:categoryTitle];   //detalleNews.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController pushViewController:detalleVoces animated:YES];
    }
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumberVoces);
    isPageRefreshingVoces = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumberVoces = currentPageNumberVoces +1;
    [self loadHeadlinesWithCategory:categoryId];
    
}


//other change
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([indexPath row]==0 || [indexPath row] % 6 == 0 || [indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 || [indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
        
        if([storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardNameVoces isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            return CGSizeMake(310, 468);
            
        }else{
            return CGSizeMake(350, 420);
        }
    }
    
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        
 
        return CGSizeMake(300, 290);
 
    }
    
    return CGSizeMake(350, 428);
}



//New code

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollingVoces = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isScrollingVoces = NO;
    }
}

-(UICollectionViewFlowLayout*)flowLayout{
    return (UICollectionViewFlowLayout*)self.collectionViewLayout;
}

@end

