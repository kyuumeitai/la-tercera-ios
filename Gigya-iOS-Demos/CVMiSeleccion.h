//
//  CVMiSeleccion.h
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 18-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVMiSeleccion : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) NSMutableArray *arrayOfArrays;
@property (nonatomic, retain) NSMutableArray *headlinesArray;
@property (nonatomic, copy) NSMutableArray *categoryNamesArray;
@property (nonatomic, copy) NSMutableArray *categoryIdsArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int categoryId;
-(void)startRefresh;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end
