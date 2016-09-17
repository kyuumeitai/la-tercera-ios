//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CVNegocios.h"
#import "CollectionViewCellPortada.h"
#import "CollectionViewCellStandar.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "UIImageView+AFNetworking.h"
//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"negocios"
#define categoryName @"La Tercera Negocios"

@implementation CVNegocios
  static NSString * const reuseIdentifier = @"cvCell";
  static NSString * const reuseIdentifierPortada = @"portadaCell";
int numeroPaginasNegocios;
NSString *dayNegocios;
NSString *monthNegocios;
NSString *yearNegocios;

BOOL nibMyCellloadedNegocios;
BOOL nibMyCell2loadedNegocios;

- (void) viewDidLoad{
    
    self.pagesArray = [[NSMutableArray alloc] init];


    [super viewDidLoad];
    [self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [self loadPages];
    });

}

-(void)loadPages{
    // Create the request.
    // Send a synchronous request
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellEstandar" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellPortada" bundle: nil];
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierPortada];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSString *categoryId = categoryIdName;
    
    dayNegocios = [NSString stringWithFormat:@"%li",(long)[components day]];
    monthNegocios = [NSString stringWithFormat:@"%li",(long)[components month]];
    yearNegocios = [NSString stringWithFormat:@"%li",(long)[components year]];
    
    if ([monthNegocios length] == 1)
        monthNegocios = [NSString stringWithFormat:@"0%@",monthNegocios];
    
    if ([dayNegocios length] == 1)
        dayNegocios = [NSString stringWithFormat:@"0%@",dayNegocios];
    
    
    NSString *lastEditionString = @"http://papeldigital.info/settings_last.js";
    NSURL *googleURLEd = [NSURL URLWithString:lastEditionString];
    NSError *errorEd;
    NSString *googlePageEd = [NSString stringWithContentsOfURL:googleURLEd
                                                      encoding:NSASCIIStringEncoding
                                                         error:&errorEd];
    
    
    NSArray *myWords = [googlePageEd componentsSeparatedByString:@"['"];
    
    for (int i=0;i<myWords.count;i++) {
        //NSLog(@"<<<< Array[%i] = %@",i,myWords[i]);
        NSString * myMatch = [NSString stringWithFormat:@"%@', '%@'",categoryIdName,categoryName];
        //NSLog(@" ESTOOO ES MY MATCH: %@",myMatch);
        if ([myWords[i] rangeOfString:myMatch].location != NSNotFound) {
            NSLog(@"string APPEARS");
            NSArray *myComps = [myWords[i] componentsSeparatedByString:@"/"];
            
            
            yearNegocios = [myComps[0] substringFromIndex: [myComps[0] length] - 4];
            monthNegocios = myComps[1];
            dayNegocios = [myComps[2] substringToIndex:2];
            
        }
    }
    
    NSString *pagesString = [NSString stringWithFormat:@"http://www.papeldigital.info/%@/%@/%@/%@/01/settings.js",categoryId,yearNegocios,monthNegocios,dayNegocios];
    NSURL *googleURL = [NSURL URLWithString:pagesString];
    NSError *error;
    NSString *googlePage = [NSString stringWithContentsOfURL:googleURL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    
    numeroPaginasNegocios= (int)[Tools numberOfOccurrencesOfString:@"site_thumbs[" inString:googlePage] ;
    
    //NSLog(@" ****^^^^EL NUMERO DE PAGINAS ES: %li",(long)numeroPaginasNegocios);
    
    NSString *temporalPage;
    NSString *temporalDetailPage;
    
    int numeroPagina = 1;
    for (int i = 1; i <= numeroPaginasNegocios; i++) {
        
        if(i==1){
            temporalPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/03/%03d.jpg",categoryId,yearNegocios,monthNegocios,dayNegocios,i];
            temporalDetailPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/04/%03d.jpg",categoryId,yearNegocios,monthNegocios,dayNegocios,i];
            
        }else{
            temporalPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/02/%03d.jpg",categoryId,yearNegocios,monthNegocios,dayNegocios,i];
            temporalDetailPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/04/%03d.jpg",categoryId,yearNegocios,monthNegocios,dayNegocios,i];
        }
        //NSLog(@"Add new page");
        NSString *pageNumber = [NSString stringWithFormat:@"Página %i",numeroPagina];
        NewspaperPage *pagina = [[NewspaperPage alloc] init];
        pagina.title = pageNumber;
        pagina.categoria = categoryName;
        pagina.pageNumber = numeroPagina;
        pagina.urlThumbnail = temporalPage;
        pagina.urlDetail = temporalDetailPage;
        //[pagina logDescription];
        [self.pagesArray addObject:pagina];
        numeroPagina++;
    }
    
    [self.collectionView reloadData];
    [UIView transitionWithView:self.collectionView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [self.collectionView setAlpha:1.0]; } completion:nil];
}
#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
   }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.pagesArray count];
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

 NewspaperPage *miPagina = [self.pagesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0) {
        
             CollectionViewCellPortada *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierPortada forIndexPath:indexPath];
        
    
        // Configure the cell
        cell.textLabel.text = miPagina.title;
        NSString *urlImagen = miPagina.urlThumbnail;
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        //__weak UITableViewCell *weakCell = cell;
        __weak CollectionViewCellPortada *weakCell = cell;
        
        [cell.imageThumbnail setImageWithURLRequest:request
                                   placeholderImage:placeholderImage
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                weakCell.imageThumbnail.image = image;
                                                [weakCell setNeedsLayout];
                                            } failure:nil];
        return cell;
    }else{
              
        CollectionViewCellStandar *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
    
        cell.textLabel.text = miPagina.title;
        NSString *urlImagen = miPagina.urlThumbnail;
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak CollectionViewCellStandar *weakCell = cell;
       
        [cell.imageThumbnail setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.imageThumbnail.image = image;
                                           [weakCell setNeedsLayout];
                                  
                                       } failure:nil];

        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsPageViewController *newsPage =  (NewsPageViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"newsPageSB"];
    NewspaperPage *paginita = (NewspaperPage*)[self.pagesArray objectAtIndex:indexPath.row ];
    newsPage.numeroPagina = paginita.pageNumber;
    newsPage.urlDetailPage = paginita.urlDetail;
    newsPage.categoria = paginita.categoria;
    newsPage.totalPaginas = (int)[self.pagesArray count] ;
    newsPage.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:newsPage animated:YES completion:nil];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row]==0){
        return CGSizeMake(248, 336);

    }else{
        return CGSizeMake(111, 142);
    }
}


@end
