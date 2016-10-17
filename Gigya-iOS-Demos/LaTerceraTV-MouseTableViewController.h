//
//  LaTerceraTV-MouseTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_MouseTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVMouseArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVMouseArray;
@property int categoryId;

@end
