//
//  DetalleNewsViewController.h
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetalleNewsViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *imagenNews;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain,nonatomic) NSString * tituloCategoria;
@property int idArticulo;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(void)loadBenefitForBenefitId:(int)idArticle andCategory:(NSString*)categoria;
@end
