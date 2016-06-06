//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CVNoticiasInicio.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellMediana.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "UIImageView+AFNetworking.h"
//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryIdName @"lt"
#define categoryName @"La Tercera"

@implementation CVNoticiasInicio

  static NSString * const reuseIdentifierGrande = @"collectionViewGrande";
static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;

BOOL nibMyCellloaded;
BOOL nibMyCell2loaded;

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
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    
   UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
  
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];

        //NSLog(@"Add new page");
    for (int i=0; i<3; i++){
        NSString *pageNumber = [NSString stringWithFormat:@"Página %i",i];
        NewspaperPage *pagina = [[NewspaperPage alloc] init];
        pagina.title = pageNumber;
        pagina.categoria = categoryName;
        pagina.pageNumber = i;
        [self.pagesArray addObject:pagina];
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
        
             CollectionViewCellGrande *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierGrande forIndexPath:indexPath];
        
    
        // Configure the cell
        cell.labelTituloNews.text = @"Notición muy importante!";
        NSString *urlImagen = miPagina.urlThumbnail;
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        //__weak UITableViewCell *weakCell = cell;
            /*
        __weak CollectionViewCellGrande *weakCell = cell;
        
   
        [cell.imageNews setImageWithURLRequest:request
                                   placeholderImage:placeholderImage
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                weakCell.imageThumbnail.image = image;
                                                [weakCell setNeedsLayout];
                                            } failure:nil];
        */
        return cell;
    }else{
              
        
        CollectionViewCellGrande *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMediana forIndexPath:indexPath];
        
        
        // Configure the cell
        cell.labelSummary.text = @"Notición muy importante, hay descuento!";
        NSString *urlImagen = miPagina.urlThumbnail;
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];


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
        return CGSizeMake(374, 428);

    }else{
        return CGSizeMake(183, 267);
    }
}


@end
