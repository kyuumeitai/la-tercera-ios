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
-(void)loadBanner;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;
@property (nonatomic, copy) NSString* bannerUnitID;

@end
