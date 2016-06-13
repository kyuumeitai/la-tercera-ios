//
//  CollectionViewCellBanner.m
//  La Tercera
//
//  Created by diseno on 09-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CollectionViewCellBanner.h"
@implementation CollectionViewCellBanner

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);
    //self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";

    // Initialization code
}

- (void)initBanner{
    
    self.bannerView.adUnitID = self.bannerUnitID;
    self.bannerView.rootViewController = self.bannerView;
    [self.bannerView loadRequest:[GADRequest request]];
}

@end
