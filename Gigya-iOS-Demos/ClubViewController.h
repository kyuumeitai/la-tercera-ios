//
//  ClubViewController.h
//  La Tercera
//
//  Created by diseno on 09-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ClubViewController : UIViewController <CLLocationManagerDelegate>{
NSMutableArray * categoryItemsArray;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    BOOL firstTime;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBanner;
@property (weak, nonatomic) IBOutlet UIButton *btnIdentify;
@property (nonatomic, retain) NSMutableArray * categoryItemsArray;
@property (nonatomic, retain) NSMutableArray * starredItemsArray;

@end
