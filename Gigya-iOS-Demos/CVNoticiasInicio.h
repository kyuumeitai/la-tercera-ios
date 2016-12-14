//
//  CVLaTercera.h
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVNoticiasInicio : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *headlinesArray;
@property int categoryIdNoticiasInicio;
-(void)startRefresh;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end
