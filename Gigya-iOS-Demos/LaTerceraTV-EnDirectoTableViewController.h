//
//  LaTerceraTV-EnDirectoTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_EnDirectoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVEnDirectoArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVEnDirectoArray;
@property int categoryId;

@end

