//
//  CollectionViewCellBanner.h
//  La Tercera
//
//  Created by diseno on 09-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface CollectionViewCellBanner : UICollectionViewCell

-(void)initBanner;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (nonatomic, copy) NSString* bannerUnitID;

@end
