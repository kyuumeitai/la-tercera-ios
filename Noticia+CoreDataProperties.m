//
//  Noticia+CoreDataProperties.m
//  La Tercera
//
//  Created by Daniel López Monsalve on 18-12-16.
//  Copyright © 2016 Copesa. All rights reserved.
//

#import "Noticia+CoreDataProperties.h"

@implementation Noticia (CoreDataProperties)

+ (NSFetchRequest<Noticia *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
}

@dynamic author;
@dynamic category;
@dynamic content;
@dynamic date;
@dynamic idArticle;
@dynamic imageLink;
@dynamic summary;
@dynamic title;
@dynamic url;

@end
