//
//  CVLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CVLaTercera.h"
#import "CollectionViewCellPortada.h"
#import "CollectionViewCellStandar.h"
#import "NewspaperPage.h"
#import "Tools.h"
#import "UIImageView+AFNetworking.h"
//#import "SDWebImage/UIImageView+WebCache.h"

#define categoryName @"lt"

@implementation CVLaTercera
  static NSString * const reuseIdentifier = @"cvCell";
  static NSString * const reuseIdentifierPortada = @"portadaCell";
int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;

BOOL nibMyCellloaded;
BOOL nibMyCell2loaded;

- (void) viewDidLoad{
    self.titlesArray = [[NSArray alloc] init];
        self.titlesArray = [NSArray arrayWithObjects: @"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17",@"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17",@"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17",@"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17",@"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17",@"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10",@"Página 11",@"Página 12",@"Página 13",@"Página 14",@"Página 15",@"Página 16",@"Página 17", nil];
    
    self.pagesArray = [[NSMutableArray alloc] init];


    [super viewDidLoad];
    
    [self loadPages];
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellEstandar" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellPortada" bundle: nil];
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierPortada];
}


-(void)loadPages{
    // Create the request.
    // Send a synchronous request

    NSString *pagesString = @"http://www.papeldigital.info/lt/2016/04/07/01/settings.js";
    NSURL *googleURL = [NSURL URLWithString:pagesString];
    NSError *error;
    NSString *googlePage = [NSString stringWithContentsOfURL:googleURL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    
    numeroPaginas= (int)[Tools numberOfOccurrencesOfString:@"site_thumbs[" inString:googlePage] ;
    
    NSLog(@" ****^^^^EL NUMERO DE PAGINAS ES: %li",(long)numeroPaginas);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    day = [NSString stringWithFormat:@"%li",(long)[components day]];
    month = [NSString stringWithFormat:@"%li",(long)[components month]];
    year = [NSString stringWithFormat:@"%li",(long)[components year]];
    
    if ([month length] == 1)
        month = [NSString stringWithFormat:@"0%@",month];
    
    if ([day length] == 1)
        day = [NSString stringWithFormat:@"0%@",day];
    
    NSString *categoryId = categoryName;
    

    
    
    //NSLog(@" ****^^^^  EL ENLACE ES: %@",temporalPage);
    NSLog(@" ****^^^^EL NUMERO DE PAGINAS ES: %li",(long)numeroPaginas);
    NSString *temporalPage;
    int numeroPagina = 1;
     for (int i = 1; i < numeroPaginas; i++) {
        
         if(i==1){
                temporalPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/03/%03d.jpg",categoryId,year,month,day,i];
             
         }else{
                 temporalPage = [NSString stringWithFormat:@"http://papeldigital.info/%@/%@/%@/%@/01/jpg/02/%03d.jpg",categoryId,year,month,day,i];
         }
        //NSLog(@"Add new page");
        NSString *pageNumber = [NSString stringWithFormat:@"Página %i",numeroPagina];
        NewspaperPage *pagina = [[NewspaperPage alloc] init];
        pagina.title = pageNumber;

      
        // pagina.imagenThumbnail = imagen;
         pagina.url = temporalPage;
        //[pagina logDescription];
        [self.pagesArray addObject:pagina];
         numeroPagina++;
    }
    
    [self.collectionView reloadData];
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
        NSString *urlImagen = miPagina.url;
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
        NSString *urlImagen = miPagina.url;
        
        NSURL *url = [NSURL URLWithString:urlImagen];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        //__weak UITableViewCell *weakCell = cell;
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
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row]==0){
        return CGSizeMake(248, 336);

    }else{
        return CGSizeMake(111, 142);
    }
}


@end
