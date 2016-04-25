//
//  CategoryDetailView1.m
//  La Tercera
//
//  Created by BrUjO on 17-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//
 #import <QuartzCore/QuartzCore.h> 
#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CustomButtonTerceraShadows : UIButton


@property (nonatomic)  NSInteger borderRadius;

/*
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
 */
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable float  shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;

@property (nonatomic) IBInspectable CGFloat shadowXOffset;
@property (nonatomic) IBInspectable CGFloat shadowYOffset;


@end

@implementation CustomButtonTerceraShadows

-(void)drawRect:(CGRect)aRect{
    self.layer.cornerRadius =  4;
    self.layer.shadowColor =    _shadowColor.CGColor;
    self.layer.shadowOffset =   CGSizeMake(_shadowXOffset, _shadowYOffset);
    self.layer.shadowOpacity =  _shadowOpacity;
    self.layer.shadowRadius =   _shadowRadius;
    self.layer.masksToBounds = false;
    self.layer.masksToBounds = true;

}

@end





