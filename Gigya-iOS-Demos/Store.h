//
//  Store.h
//  La Tercera
//
//  Created by diseno on 04-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Store : UIViewController

@property (nonatomic, strong) NSString               *storeId;
@property (nonatomic, strong) NSString               *storeDescription;
@property (nonatomic, strong) NSString               *storeAddress;
@property (nonatomic, assign) CLLocationCoordinate2D storeLocation;
@property (nonatomic, strong) NSString               *distanciaEnMetros;
@property (nonatomic, assign) CGFloat                dMeter;
@property (nonatomic, copy) NSString *idStore;
@property (nonatomic, strong) UIImage *imagenStore;
@property (nonatomic, copy) NSString *descripcion;
@property (nonatomic, copy) NSString *direccion;
@property  int likes;
@property CGFloat distancia;

@property BOOL forProfileOne;
@property BOOL forProfileTwo;
@property BOOL forProfileThree;


@end