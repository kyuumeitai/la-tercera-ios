//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import "CVNoticiasMundo.h"
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

//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categoryId 9
#define categoryName @"Mundo"

@implementation CVNoticiasMundo

@synthesize headlinesArray;
@synthesize collectionView;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";

//New Pagination code
int currentPageNumber ;
BOOL isPageRefreshingMundo =  false;
BOOL firstTimeMundo = false;
NSArray *bannersMundo= nil;
BOOL _isScrollingMundo;
int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;
NSString *storyBoardName;


- (void) viewDidLoad{
    [super viewDidLoad];
    
    __weak CVNoticiasMundo *weakSelf = self;
    headlinesArray = [[NSMutableArray alloc] init];
    
    bannersMundo = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/Mundo_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Mundo_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Mundo_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Mundo_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/Mundo_300x250-E", nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    
    if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"])
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
    
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    
    UINib *cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
    
    [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumber = 1;
    firstTimeMundo = true;
    
    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [self loadHeadlinesWithCategory:categoryId];
    });
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreRows];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    isPageRefreshingMundo = NO;
}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    NSLog(@"Load Headlines");
    
    __weak CVNoticiasMundo *weakSelf = self;
    
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                if (isPageRefreshingMundo == false){
                    
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
                    
                    isPageRefreshingMundo = YES;
                    
                }else{
                    
                    [self reloadHeadlinesDataFromArrayJson:arrayJson];
                  //NSLog(@"Lista headlines jhson: %@",arrayJson);
                }
            }
        });
    }:idCategory andPage:currentPageNumber];
    
}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    __weak CVNoticiasMundo *weakSelf = self;
    NSLog(@"  reload headlines");
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    //NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    
    
    int indice = 0;
    
    for (id titularTemp in arrayTitulares){
        indice ++;
        NSLog(@"El Indice es: %d ", indice);
        NSDictionary *dictTitular = (NSDictionary*) titularTemp;
        id idArt =  [dictTitular objectForKey:@"id"];
        id title = [dictTitular objectForKey:@"title"];
        id summary = [dictTitular objectForKey:@"short_description"];
        
        id imageThumb ;
        
        if ([dictTitular objectForKey:@"thumb_url"] == (id)[NSNull null]){
            imageThumb = @"https://placekitten.com/200/200";
        }else{
           imageThumb = [dictTitular objectForKey:@"thumb_url"];
        }
        
        Headline *titular = [[Headline alloc] init];
        titular.idArt = [idArt intValue];
        titular.title = title;
        titular.summary = summary;
        titular.imagenThumbString = imageThumb;
        
        NSLog(@"____ Numero de pagina: %d", currentPageNumber);
        if (indice == currentPageNumber*6 ){
            NSLog(@"____ currentPageNumber*6: %d", currentPageNumber*6);
            [headlinesArray addObject:@"OBJETO"];
        }
        //[titular logDescription];
        
        [headlinesArray addObject:titular];
    }
    
    //New code
    if (firstTimeMundo ==true){
        self.view.alpha = 0.0;
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.5
                         animations:^{ self.view.alpha = 1.0; /* Some fake chages */
                             
                         }
                         completion:^(BOOL finished)
         {
             //[SVProgressHUD dismiss];
         }];
        firstTimeMundo= false;
    }else{
        
        //[SVProgressHUD dismiss];
        isPageRefreshingMundo= NO;
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
    celdaBanner = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
    
    
    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0) {
        
        CollectionViewCellGrande *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
        
        
        // Configure the cell
        cell.labelTituloNews.text = titular.title;
        cell.labelSummary.text = titular.summary;
        NSString *urlImagen = titular.imagenThumbString;
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
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
    
    if (indexPath.item == 1 || indexPath.item == 2 || ((indexPath.item % 6)-1) == 0 || ((indexPath.item % 6)-2) == 0  )
    {
        
        
        CollectionViewCellMediana *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMediana forIndexPath:indexPath];
        
        
        // Configure the cell
        // cell.labelTituloNews.text = titular.title;
        cell.labelSummary.text = titular.title;
        NSString *urlImagen = titular.imagenThumbString;
        NSURL *url = [NSURL URLWithString:urlImagen];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak CollectionViewCellMediana *weakCellMediana = cell;
        
        [cell.imageNews setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCellMediana.imageNews.image = image;
                                           [weakCellMediana setNeedsLayout];
                                       } failure:nil];
        
        return cell;
        
    }
    
    if (indexPath.item == 3 || indexPath.item == 4 || ((indexPath.item % 6)-3) == 0 || ((indexPath.item % 6)-4) == 0 )
    {
        
        
        CollectionViewCellHorizontal*cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHorizontal forIndexPath:indexPath];
        
        // Configure the cell
        cell.labelSummary.text = titular.title;
        NSString *urlImagen = titular.imagenThumbString;
        NSURL *url = [NSURL URLWithString:urlImagen];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak CollectionViewCellHorizontal *weakCellHorizontal = cell;
        
        [cell.imageNews setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCellHorizontal.imageNews.image = image;
                                           [weakCellHorizontal setNeedsLayout];
                                       } failure:nil];
        
        
        return cell;
        
    }
    
    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 )
    {
        
        
        switch (indexPath.item) {
            case 5:
                celdaBanner.bannerUnitID =  bannersMundo[0]  ;
                break;
            case 11:
                
                celdaBanner.bannerUnitID =  bannersMundo[1]  ;
                
                break;
            case 17:
                
                celdaBanner.bannerUnitID =  bannersMundo[2]  ;
                
                break;
            case 23:
                
                celdaBanner.bannerUnitID =  bannersMundo[3]  ;
                
                break;
            default:
                celdaBanner.bannerUnitID =  bannersMundo[2]  ;
                
                break;
        }
        
        
        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO){
            
            [celdaBanner initBanner];
            [celdaBanner loadBanner];
        }
        
        if(_isScrollingMundo == false){
            [celdaBanner initBanner];
            [celdaBanner loadBanner];
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
        [detalleNews loadBenefitForBenefitId:idArticulo];    //detalleNews.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController pushViewController:detalleNews animated:YES];
    }
}

- (void)loadMoreRows {
    
    NSLog(@"***********   Load More Rows   ************");
    NSLog(@" scroll to bottom!, with pageNumber: %d",currentPageNumber);
    isPageRefreshingMundo = YES;
    //[self showMBProgressHUDOnView:self.view withText:@"Please wait..."];
    currentPageNumber = currentPageNumber +1;
    [self loadHeadlinesWithCategory:categoryId];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row]==0 || [indexPath row] % 6 == 0){
        
        if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
            
            return CGSizeMake(286, 468);
            
        }else{
            return CGSizeMake(370, 420);
        }
    }
    
    if([indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 ) {
        return CGSizeMake(170, 262);
        
    }
    
    if([indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
        return CGSizeMake(356, 100);
        
    }
    
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return CGSizeMake(370, 265);
        
    }
    
    return CGSizeMake(370, 428);
}

//New code

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScrollingMundo = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isScrollingMundo = NO;
    }
}

@end