//
//  HistoryTableViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UITableViewController{
NSMutableArray * historyItemsBenefits;
NSMutableArray * historyItemsContests;

}
@property (nonatomic, retain) NSMutableArray * historyItemsBenefit;
@property (nonatomic, retain) NSMutableArray * historyItemsContests;
@end
