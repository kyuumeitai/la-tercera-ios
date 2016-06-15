//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import "CVNoticiasPolitica.h"
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
//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categoryId 9
#define categoryName @"Politica"

@implementation CVNoticiasPolitica

@synthesize headlinesArray;

static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";

int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;

BOOL nibMyCellloaded;
BOOL nibMyCell2loaded;

- (void) viewDidLoad{
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
    
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    
    UINib *cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
    
    [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];

    [super viewDidLoad];
    [self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
       [self loadHeadlinesWithCategory:categoryId];
    });

}

-(void)loadHeadlinesWithCategory:(int)idCategory{
    
    NSLog(@"Load Headlines");
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc]init];
    BOOL estaConectado = [connectionManager verifyConnection];
    NSLog(@"Verificando conexión: %d",estaConectado);
    [connectionManager getHeadlinesForCategoryId:^(BOOL success, NSArray *arrayJson, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                NSLog(@"Error obteniendo datos! %@ %@", error, [error localizedDescription]);
            } else {
                [self reloadHeadlinesDataFromArrayJson:arrayJson];
               // NSLog(@"Lista headlines jhson: %@",arrayJson);
            }
        });
    }:idCategory];

}

-(void) reloadHeadlinesDataFromArrayJson:(NSArray*)arrayJson{
    NSDictionary *diccionarioTitulares = (NSDictionary*)arrayJson;
    //NSLog(@"  reload headlines array, is: %@ ",diccionarioTitulares);
    
    NSArray* arrayTitulares = [diccionarioTitulares objectForKey:@"articles"];
    NSLog(@" El array de titulares, es: %@ ",arrayTitulares);
    
  
    headlinesArray = [[NSMutableArray alloc] init];
    
       for (id titularTemp in arrayTitulares){
            
           NSLog(@"El titular: %@ ", titularTemp);
           NSDictionary *dictTitular = (NSDictionary*) titularTemp;
           id idArt =  [dictTitular objectForKey:@"id"];
           id title = [dictTitular objectForKey:@"title"];
           id summary = [dictTitular objectForKey:@"short_description"];
           id imageThumb = [dictTitular objectForKey:@"thumb_url"];
           
           Headline *titular = [[Headline alloc] init];
           titular.idArt = [idArt intValue];
           titular.title = title;
           titular.summary = summary;
           titular.imagenThumbString = imageThumb;
           
           //[titular logDescription];
           [headlinesArray addObject:titular];
        }
        
           // [SVProgressHUD dismiss];
    
    [self.collectionView reloadData];
    [UIView transitionWithView:self.collectionView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [self.collectionView setAlpha:1.0]; } completion:nil];
    
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
    
    
    Headline *titular = [headlinesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0 || indexPath.item % 6 == 0) {
        
        CollectionViewCellGrande *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
        
        
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
        
        
        CollectionViewCellMediana *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMediana forIndexPath:indexPath];
        
        
        // Configure the cell
        // cell.labelTituloNews.text = titular.title;
        cell.labelSummary.text = titular.title;
        NSString *urlImagen = titular.imagenThumbString;
        NSURL *url = [NSURL URLWithString:urlImagen];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //__weak UITableViewCell *weakCell = cell;
        
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
        
        
        CollectionViewCellHorizontal*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHorizontal forIndexPath:indexPath];
        
        // Configure the cell
        cell.labelSummary.text = titular.title;
        
        return cell;
        
    }
    
    if (indexPath.item == 5 || ((indexPath.item % 6)-5) == 0 || ((indexPath.item % 6)-5) == 0 )
    {
        
        
        CollectionViewCellBanner *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        // Configure the cell
        cell.bannerUnitID =  @"ca-app-pub-3940256099942544/2934735716";
        [cell initBanner];
        return cell;
        
    }
    CollectionViewCellBanner *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NewsPageViewController *newsPage =  (NewsPageViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"newsPageSB"];
    NewspaperPage *paginita = (NewspaperPage*)[self.pagesArray objectAtIndex:indexPath.row ];
    newsPage.numeroPagina = paginita.pageNumber;
    newsPage.urlDetailPage = paginita.urlDetail;
    newsPage.categoria = paginita.categoria;
    newsPage.totalPaginas = (int)[self.pagesArray count] ;
    newsPage.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:newsPage animated:YES completion:nil];
  */  
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row]==0 || [indexPath row] % 6 == 0){
        return CGSizeMake(370, 420);
        
    }
    
    if([indexPath row]==1 || [indexPath row]==2  || (([indexPath row]% 6)-1) == 0 || (([indexPath row] % 6)-2) == 0 ) {
        return CGSizeMake(170, 262);
        
    }
    
    if([indexPath row]==3 || [indexPath row]==4 || (([indexPath row]% 6)-3) == 0 || (([indexPath row] % 6)-4) == 0 ){
        return CGSizeMake(374, 80);
        
    }
    
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return CGSizeMake(316, 265);
        
    }
    
    return CGSizeMake(374, 428);
}


@end
