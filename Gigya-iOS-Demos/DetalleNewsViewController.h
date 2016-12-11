//
//  DetalleNewsViewController.h
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@import GoogleMobileAds;

@interface DetalleNewsViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *imagenNews;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnFav;
@property (weak, nonatomic) IBOutlet UIButton *btnCatFav;
@property (retain,nonatomic) NSString * tituloCategoria;
@property int idCategoria;
@property int idArticulo;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)NSMutableArray *relatedIdsArray;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerNewsDetailView;

-(void)loadBenefitForBenefitId:(int)idArticle andCategory:(NSString*)categoria;
@end
