//
//  LaTerceraTV-ActualidadTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_ActualidadTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVActualidadArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVActualidadArray;
@property int categoryId;

@end
