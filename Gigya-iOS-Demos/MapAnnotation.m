//
//  MapAnnotation
//
//  Places Near Source Code
//  Created by Mobigo Bilişim Teknolojileri
//  Copyright (c) 2015 Mobigo Bilişim Teknolojileri. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize pinIcon;
@synthesize likes;

-initWithPosition:(CLLocationCoordinate2D)coords{
    self = [super init];
    if (self) {
        _coordinate = coords;
        _title      = title;
        _subtitle   = subtitle;
        _pinIcon    = pinIcon;
        _likes      = likes;
    }
    return self;
}

@end
