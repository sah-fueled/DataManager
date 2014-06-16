//
//  MappingProvider.m
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import "User.h"
#import "Selfie.h"

@implementation MappingProvider

+ (RKObjectMapping *)userMapping {
  
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
  NSDictionary *mappingDictionary = @{@"id": @"userId",
                                      @"name": @"name",
                                      @"email": @"email",
                                      };
  [mapping addAttributeMappingsFromDictionary:mappingDictionary];
  
  return mapping;
}

+ (RKEntityMapping *)userMappingForStore:(RKManagedObjectStore *)store {
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:store];
  NSDictionary *mappingDictionary = @{@"id": @"userId",
                                      @"name": @"name",
                                      @"email": @"email",
                                      };
  [mapping addAttributeMappingsFromDictionary:mappingDictionary];
  
  return mapping;
}

+ (RKEntityMapping *)selfieMappingForStore:(RKManagedObjectStore *)store {
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Selfie" inManagedObjectStore:store];
  NSDictionary *mappingDictionary = @{@"id": @"selfieId",
                                      @"caption": @"caption",
                                      @"category": @"category",
                                      @"imageSize":@"imageSize",
                                      @"imageUrl":@"imageURL",
                                      @"isDeleted":@"isDeleted",
                                      @"user": @"userId"
                                      };
  mapping.identificationAttributes = @[@"selfieId"];
  [mapping addAttributeMappingsFromDictionary:mappingDictionary];
  [mapping addConnectionForRelationship:@"user" connectedBy:@{ @"userId": @"userId" }];
//  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"userId" toKeyPath:@"user" withMapping:[MappingProvider userMappingForStore:store]]];
  return mapping;
}

+ (RKObjectMapping *)selfieRequestMappingForStore:(RKManagedObjectStore *)store {
  RKObjectMapping *mapping = [RKObjectMapping requestMapping];
//  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Selfie" inManagedObjectStore:store];
//  RKObjectMapping *mapping =
  NSDictionary *mappingDictionary = @{@"selfieId":@"id",
                                      @"caption": @"caption",
                                      @"category": @"category",
                                      @"imageSize":@"imageSize",
                                      @"imageURL":@"imageUrl",
                                      @"isDeleted":@"isDeleted"
                                      };
////  mapping.identificationAttributes = @[@"selfieId"];
  [mapping addAttributeMappingsFromDictionary:mappingDictionary];
//  [mapping addAttributeMappingsFromArray:@[@"id", @"caption", @"category",@"imageSize"]];

  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[MappingProvider userMapping].inverseMapping]];
  return mapping;
}

+ (RKObjectMapping *)selfieMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Selfie class]];
  NSDictionary *mappingDictionary = @{@"id": @"selfieId",
                                      @"caption": @"caption",
                                      @"category": @"category",
                                      @"imageSize":@"imageSize",
                                      @"imageUrl":@"imageURL",
                                      @"isDeleted":@"isDeleted"
                                      };
  [mapping addAttributeMappingsFromDictionary:mappingDictionary];
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[MappingProvider userMapping]]];
  return mapping;
}

//+ (void)setPaginationMapping {
//  RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
//  
//  [paginationMapping addAttributeMappingsFromDictionary:@{
//                                                          @"pagination.per_page": @"perPage",
//                                                          @"pagination.total_pages": @"pageCount",
//                                                          @"count": @"objectCount",
//                                                          }];
//  
//}


@end
