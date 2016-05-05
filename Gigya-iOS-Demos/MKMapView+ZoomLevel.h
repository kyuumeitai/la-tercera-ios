//
//  MapKit.h
//  La Tercera
//
//  Created by diseno on 04-05-16.
//  Copyright © 2016 Gigya. All rights reserved.
//
// MKMapView+ZoomLevel.h

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end