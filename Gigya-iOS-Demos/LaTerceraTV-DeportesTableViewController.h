//
//  LaTerceraTV-DeportesTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_DeportesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVDeportesArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVDeportesArray;
@property int categoryId;

@end
