//
//  LaTerceraTV-HomeTableViewController.h
//  La Tercera
//
//  Created by diseno on 11-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_HomeTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *headlinesArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int categoryId;

@end
