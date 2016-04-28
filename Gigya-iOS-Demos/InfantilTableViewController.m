//
//  InfantilTableViewController.m
//  La Tercera
//
//  Created by diseno on 15-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import  "InfantilTableViewController.h"
#import  "CategoriasTableViewCell.h"
#import  "DestacadoTableViewCell.h"
#import  "DetalleBeneficioViewController.h"
#import "Category.h"
#import "Benefit.h"
#import "SingletonManager.h"


@interface InfantilTableViewController ()

@end

@implementation InfantilTableViewController
NSMutableArray *listaCategorias2;
NSMutableArray *listaBeneficios2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SingletonManager *singleton = [SingletonManager singletonManager];
    listaCategorias2 = [[NSMutableArray alloc] init];
    listaCategorias2 = singleton.categoryList;
    //NSLog(@"La lista de categorias es: %@",listaCategorias2.description);
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCat == %d", 8];
    NSArray *filteredArray = [listaCategorias2 filteredArrayUsingPredicate:predicate];
    
    Category* firstFoundObject = nil;
    firstFoundObject =  filteredArray.count > 0 ? filteredArray.firstObject : nil;
    Category *categoria = firstFoundObject;
    
    listaBeneficios2 = [[NSMutableArray alloc] init];
    listaBeneficios2 = categoria.arrayBenefits;
   // NSLog(@"La lista de beneficios Infantil es: %@",listaBeneficios2.description);
     
    CGSize size = CGSizeMake(0,listaBeneficios2.count * 100);
    [self.tableView setContentSize:size];
   
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listaBeneficios2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"BanioTableCell";
    
    
    
    /*MyManager *singleton = [MyManager sharedManager];
     NSString *storyBoardName = singleton.storyBoardName;
     
     
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone4"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone4" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone5"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone5" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6"] )
     nib = [[NSBundle mainBundle] loadNibNamed:@"BaniosTableViewCell-iPhone6" owner:self options:nil];
     if ([storyBoardName isEqualToString:@"MainStoryboard-iPhone6Plus"] )
     */
    NSArray *nib;
    
    if (indexPath.row==0) {
        DestacadoTableViewCell *cell = (DestacadoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DestacadoTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            Benefit *beneficio = [listaBeneficios2 objectAtIndex:0];
            
            cell.labelTitulo.text = beneficio.title;
            cell.labelSubtitulo.text = beneficio.summary;
            cell.labelDescuento.text = beneficio.desclabel;
            cell.labelDistancia.text = @"A 200 metros de su ubicación";
            cell.imageDestacada.image = beneficio.imagenNormal;
        }
        return cell;
    }else{
        
        CategoriasTableViewCell *cell = (CategoriasTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            
            nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Benefit *beneficio2 = [listaBeneficios2 objectAtIndex:indexPath.row];
        [beneficio2 logDescription];
        
        cell.labelTitulo.text = beneficio2.title;
        cell.labelDescuento.text = beneficio2.desclabel;
        cell.labelDistancia.text = @"A 200 metros de su ubicación";
        NSLog(@" Imagen beneficionormal: %@",beneficio2.imagenNormal);
        cell.imageCategoria.image = beneficio2.imagenNormal;
        
        
        
        
        return cell;
    }
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 278.0;
    }
    else {
        return 100.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"DETECTED");
    
    
    DetalleBeneficioViewController *detalleBeneficio = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleBeneficioViewController"];
    Benefit *beneficio = [listaBeneficios2 objectAtIndex:indexPath.row];
    detalleBeneficio.benefitImage = beneficio.imagenNormal;
    detalleBeneficio.benefitTitle= beneficio.title;
    detalleBeneficio.benefitAddress = @"A 200 metros de su ubicación";
    detalleBeneficio.benefitDiscount= beneficio.desclabel;
    detalleBeneficio.benefitDescription = beneficio.summary;
    
    
    [self.navigationController pushViewController: detalleBeneficio animated:YES];
    
}

@end
