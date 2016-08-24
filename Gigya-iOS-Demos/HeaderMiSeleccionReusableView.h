//
//  HeaderMiSeleccionReusableView.h
//  La Tercera
//
//  Created by Mario Alejandro on 24-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderMiSeleccionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectionCategoryButton;

@end
