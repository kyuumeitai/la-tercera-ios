//
//  CollectionViewCellLaTercera.m
//  La Tercera
//
//  Created by diseno on 11-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CollectionViewCellStandar.h"

@implementation CollectionViewCellStandar
- (void)awakeFromNib {
    
    // background color
    /*
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView = bgView;
    self.backgroundView.backgroundColor = [UIColor blueColor];
     */
    
    // selected background
    UIView *selectedView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView = selectedView;
    self.selectedBackgroundView.backgroundColor = [UIColor redColor];
}

@end
