//
//  MapAnnotation
//
//  Places Near Source Code
//  Created by Mobigo Bilişim Teknolojileri
//  Copyright (c) 2015 Mobigo Bilişim Teknolojileri. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
    NSString               *_title;
    NSString               *_subtitle;
    NSString               *_pinIcon;
    float                  _likes;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString               *title;
@property (nonatomic, copy)   NSString               *subtitle;
@property (nonatomic, copy)   NSString               *pinIcon;
@property float likes;

-initWithPosition:(CLLocationCoordinate2D)coords;

@end
