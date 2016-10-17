//
//  LaTerceraTV-ReportajesTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 17-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaTerceraTV_ReportajesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *laTerceraTVReportajesArray;
}
@property (nonatomic, retain) NSMutableArray *laTerceraTVReportajesArray;
@property int categoryId;

@end
