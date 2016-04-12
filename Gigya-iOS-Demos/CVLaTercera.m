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

@implementation CVLaTercera
  static NSString * const reuseIdentifier = @"cvCell";
static NSString * const reuseIdentifierPortada = @"portadaCell";

BOOL nibMyCellloaded;
BOOL nibMyCell2loaded;
- (void) viewDidLoad{
    self.pagesArray = [[NSArray alloc] init];
    
    self.pagesArray = [NSArray arrayWithObjects: @"Página 1",@"Página 2",@"Página 3",@"Página 4",@"Página 5",@"Página 6",@"Página 7",@"Página 8",@"Página 9",@"Página 10", nil];
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCellEstandar" bundle: nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    UINib *cellNib2 = [UINib nibWithNibName:@"CollectionViewCellPortada" bundle: nil];
    [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierPortada];
  
}


#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    //[self.pagesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.pagesArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

 NSString *data = [self.pagesArray objectAtIndex:indexPath.row];
    
    if (indexPath.item == 0) {
        
             CollectionViewCellPortada *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierPortada forIndexPath:indexPath];
        
    
        // Configure the cell
        cell.textLabel.text = data;
        
        return cell;
    }else{
        
              
        CollectionViewCellStandar *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
        
    
        
        cell.textLabel.text = data;
        return cell;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row]==0){
        return CGSizeMake(248, 288);

    }else{
        return CGSizeMake(111, 142);

    }
    
}



@end
