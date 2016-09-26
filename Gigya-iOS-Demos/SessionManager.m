//
//  Singleton.m
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import "SessionManager.h"

@implementation SessionManager

@synthesize profileCode;
@synthesize profileType;
@synthesize profileEmail;
@synthesize profileGigyaId;
@synthesize storyBoardName;
@synthesize userLocation;
@synthesize leftSlideMenu;
@synthesize width;
@synthesize categoryList;
@synthesize userProfile;
@synthesize isLogged;

#pragma mark Singleton Methods

+ (id)session{
    static SessionManager *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[self alloc] init];
    });
    return session;
}

- (id)init {
    if (self = [super init]) {
        
        storyBoardName =  @"MainStoryBoard";
        
        //Temp vars
        profileGigyaId =  @"noneId ";
        profileEmail = @"    - ";
        profileCode = -1;
        profileType = @"anonimo";
        //End temp vars
        
        userLocation = nil;
        leftSlideMenu = nil;
        
        categoryList = [[NSMutableArray alloc]init];
        
        userProfile = [[UserProfile alloc] init];
        userProfile.userProfileId = -1;
        userProfile.rut = @"";
        userProfile.name = @"";
        userProfile.lastName = @"";
        userProfile.email = @"";
        userProfile.status = false;
        userProfile.suscriber = false;
        userProfile.token = @"";
        userProfile.other_emails = [[NSMutableArray alloc]init];
        userProfile.gender = @"";
        userProfile.birthdate = @"";
        userProfile.profileType = @"anonimo";
        userProfile.profileLevel = 0;
        //userProfile.profileLevel = 2;
        userProfile.preferences = [[NSMutableArray alloc]init];
        userProfile.site = @"";
        userProfile.notificacionesClub = false;
        userProfile.notificacionesNoticias = false;
        userProfile.horario1 = false;
        userProfile.horario2 = false;
        userProfile.horario3 = false;
        userProfile.device = -1;

        width = 0;
        NSLog(@"Sesión iniciada");
    }
    return self;
}


-(NSString*)sessionDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@" Está logueado: %d ,  Storyboard: %@  User ProfileId: %d y categoryList: %@  ", self.isLogged, self.storyBoardName, self.userProfile.userProfileId, self.categoryList];
    
    return mensaje;
    
}

-(NSString*)profileDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@"Email %@ , Nombres: %@ %@, ProfileLevel: %d, es Suscriptor?: %d , ProfileType: %@  User status: %d   ", userProfile.email,userProfile.name, userProfile.lastName, userProfile.profileLevel , userProfile.suscriber, userProfile.profileType, userProfile.status];
    
    return mensaje;
    
}

-(void) resetUserProfile{
    
    NSLog(@"Reset user profile");
    
    //Temp vars
    profileGigyaId =  @"noneId ";
    profileEmail = @"    - ";
    profileCode = -1;
    profileType = @"anonimo";
    //End temp vars
    
    userLocation = nil;
    leftSlideMenu = nil;
    
    categoryList = [[NSMutableArray alloc]init];
    
    userProfile = [[UserProfile alloc] init];
    userProfile.userProfileId = -1;
    userProfile.rut = @"";
    userProfile.name = @"";
    userProfile.lastName = @"";
    userProfile.email = @"";
    userProfile.status = false;
    userProfile.suscriber = false;
    userProfile.token = @"";
    userProfile.other_emails = [[NSMutableArray alloc]init];
    userProfile.gender = @"";
    userProfile.birthdate = @"";
    userProfile.profileType = @"anonimo";
    userProfile.profileLevel = 0;
    userProfile.preferences = [[NSMutableArray alloc]init];
    userProfile.site = @"";
    userProfile.notificacionesClub = false;
    userProfile.notificacionesNoticias = false;
    userProfile.horario1 = false;
    userProfile.horario2 = false;
    userProfile.horario3 = false;
    userProfile.device = -1;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

-(UserProfile *)getUserProfile{
    
    return userProfile;
    
}

-(BOOL)isRepeatedForSelectedCategory:(int)idCat{
    
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        NSLog(@"Comparamos idCat: %d con: %d , que es: %@", idCat, [[objeto valueForKey:@"idCat"] intValue], [objeto valueForKey:@"nombreCat"]);
        int valor = [[objeto valueForKey:@"idCat"] intValue];
        
        if (idCat == valor) {
            
            return true;
            
        }
        
    }
    return false;
}

-(BOOL) saveMiSeleccionCategoryWithId:(int)idCat andCategoryName:(NSString*)categoryName{
    
    BOOL exitoso = false;
    

    
    if([self isRepeatedForSelectedCategory:idCat]){
            
            return false;
            
        }else{
            
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            
            // Create a new selection category
            NSManagedObject *nuevaCategoriaSeleccion = [NSEntityDescription insertNewObjectForEntityForName:@"CategoriasSeleccion" inManagedObjectContext:managedObjectContext];
            
            [nuevaCategoriaSeleccion  setValue:categoryName forKey:@"nombreCat"];

            [nuevaCategoriaSeleccion  setValue:[NSNumber numberWithInt:idCat] forKey:@"idCat"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"No se pudo guardar! %@ %@", error, [error localizedDescription]);
                exitoso = false;
            }else{
                
                exitoso = true;
            }
            
        }
    

    return exitoso;
}


-(NSArray*) getMiSeleccionArray{
    
    NSArray *arraySeleccion = [[NSArray alloc] init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CategoriasSeleccion"];
    arraySeleccion = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"El array seleccion es : %@",arraySeleccion);
    
    return arraySeleccion;
}

-(NSMutableArray*) getMiSeleccionCategoryIdsArray{
    
    NSMutableArray *arraySeleccionIds = [[NSMutableArray alloc] init];
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        int valor = [[objeto valueForKey:@"idCat"] intValue];
        [arraySeleccionIds addObject:[NSNumber numberWithInteger:valor]];
    }

    
    return arraySeleccionIds;
}

-(NSMutableArray*) getMiSeleccionCategoryTitlesArray{
    
    NSMutableArray *arraySeleccionTitles = [[NSMutableArray alloc] init];
    
    SessionManager *sesion = [SessionManager session];
    
    NSMutableArray *arreglo = (NSMutableArray*)[sesion getMiSeleccionArray];
    for (NSManagedObject *objeto in arreglo) {
        NSString * tituloCat = [objeto valueForKey:@"nombreCat"];
        [arraySeleccionTitles addObject:tituloCat];
    }
    
    
    return arraySeleccionTitles;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



@end
