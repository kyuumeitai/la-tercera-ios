//
//  MKPointAnnotation_custom.h
//  La Tercera
//
//  Created by diseno on 05-05-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPointAnnotation_custom : MKPointAnnotation
@property int benefitId;
@property int storeId;
@property int commerceId;
@property (nonatomic,strong) NSString * normalImageString;
@property (nonatomic,strong) NSString * benefitTitle;
@property (nonatomic,strong) NSString * DescText;
@property (nonatomic,strong) NSString * StoreAddress;
@property (readonly, nonatomic) CLLocation * location;
@end
