//
//  NewsPageViewController.h
//  La Tercera
//
//  Created by diseno on 14-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsPageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *newsPageImageView;
@property int numeroPagina;
@property int totalPaginas;
@property (nonatomic,strong) NSString *categoria;
@property (nonatomic,strong) NSString *urlDetailPage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
