//
//  CVLaTercera.h
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVNoticiasTendencias: UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray *headlinesArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int categoryId;

@end
