//
//  LaTerceraTV-SeriesTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_SeriesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVSeriesArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVSeriesArray;
@property int categoryId;

@end
