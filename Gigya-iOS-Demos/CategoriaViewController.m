//
//  CategoriaViewController.m
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CategoriaViewController.h"
#import "InfantilTableViewController.h"

#import "YSLContainerViewController.h"

#import "NewsCategoryInicioViewController.h"
#import "NewsCategoryPoliticaViewController.h"


@interface CategoriaViewController ()<YSLContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *botonTodos;
@property (weak, nonatomic) IBOutlet UIButton *botonSabores;
@property (weak, nonatomic) IBOutlet UIButton *botonInfantil;
@property (weak, nonatomic) IBOutlet UIButton *botonTiempoLibre;
@property (weak, nonatomic) IBOutlet UIButton *botonVidaSana;
@property (weak, nonatomic) IBOutlet UIButton *botonMasterCard;
@property (weak, nonatomic) IBOutlet UIButton *botonServicios;
@property (weak, nonatomic) IBOutlet UIButton *botonViajes;

@end

@implementation CategoriaViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self loadCategory];
    [self setupClubCategories];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupClubCategories{
    NSLog(@"setup Club categories");
    // SetUp ViewControllers
    NewsCategoryInicioViewController *newsInicio2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryInicio"];
    newsInicio2VC.title = @"Inicio";
    
    NewsCategoryPoliticaViewController *newsPolitica2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsCategoryPolitica"];
    newsPolitica2VC.title = @"Politica";
    
    // ContainerView
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    float headerSpace = 5.0;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[newsInicio2VC,newsPolitica2VC]                                                                                        topBarHeight:headerSpace                                                                                parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"PT-Sans" size:16];
    UIView *getView = (UIView*)[self.view viewWithTag:200];
    [getView addSubview:containerVC.view];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}

#pragma mark - Menu Categories
- (IBAction)infantilClicked:(id)sender {
    NSLog(@"Infantil clicked");
    self.categoryName = @"infantil";
    
    self.botonInfantil.selected = YES;
    self.botonSabores.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonTodos.selected = NO;
    
    [self loadCategory];
}

- (IBAction)todosClicked:(id)sender {
    NSLog(@"Todos clicked");
    
    self.categoryName = @"todos";
    
    self.botonTodos.selected = YES;
    self.botonSabores.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
    
}
- (IBAction)saboresClicked:(id)sender {
    NSLog(@"Sabores clicked");
    
    self.categoryName = @"sabores";
    
    self.botonSabores.selected = YES;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
}

- (IBAction)vidaSanaClicked:(id)sender {
    NSLog(@"Vida Sana clicked");
    
    self.categoryName = @"vidaSana";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = YES;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
}

- (IBAction)tiempoLibreClicked:(id)sender {
     NSLog(@"Tiempo Libre clicked");
    
    self.categoryName = @"tiempoLibre";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = YES;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
    
}
- (IBAction)serviciosClicked:(id)sender {
     NSLog(@"Servicios clicked");
    
    self.categoryName = @"servicios";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = YES;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
}

- (IBAction)viajesClicked:(id)sender {
     NSLog(@"Viajes clicked");
    
    self.categoryName = @"viajes";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = NO;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = YES;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
}

- (IBAction)mastercardClicked:(id)sender {
    NSLog(@"Viajes clicked");
    
    self.categoryName = @"masterCard";
    
    self.botonSabores.selected = NO;
    self.botonTodos.selected = NO;
    self.botonInfantil.selected = NO;
    self.botonTiempoLibre.selected = NO;
    self.botonVidaSana.selected = NO;
    self.botonMasterCard.selected = YES;
    self.botonServicios.selected = NO;
    self.botonViajes.selected = NO;
    self.botonInfantil.selected = NO;
    
    [self loadCategory];
}

#pragma mark - Load Categories
- (void)loadCategory {
    
    if ([self.categoryName  isEqual: @"infantil"]) {
        
        NSLog(@"Cargando Categoría: %@",_categoryName);
        self.botonInfantil.selected = true;
        InfantilTableViewController *viewController1 = //
        [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
        viewController1.view.frame = self.containerView.bounds;
        
        [viewController1 willMoveToParentViewController:self];
        [self.containerView addSubview:viewController1.view];
        [self addChildViewController:viewController1];
        [viewController1 didMoveToParentViewController:self];
        
    }
    
    if ([self.categoryName  isEqual: @"sabores"]) {
        
        NSLog(@"Cargando Categoría: %@",_categoryName);
        self.botonSabores.selected = true;
        /*
        InfantilTableViewController *viewController1 = //
        [self.storyboard instantiateViewControllerWithIdentifier:@"infantilTableView"];
        viewController1.view.frame = self.containerView.bounds;
        
        [viewController1 willMoveToParentViewController:self];
        [self.containerView addSubview:viewController1.view];
        [self addChildViewController:viewController1];
        [viewController1 didMoveToParentViewController:self];
        */
    }
}

#pragma mark - Load Categories
#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
