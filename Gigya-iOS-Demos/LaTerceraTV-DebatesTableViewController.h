//
//  LaTerceraTV-DebatesTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_DebatesTableViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVDebatesArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVDebatesArray;
@property int categoryId;

@end
