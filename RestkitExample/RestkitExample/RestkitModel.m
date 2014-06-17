//
//  RestkitModel.m
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "RestkitModel.h"

static RestkitModel *sharedModel = nil;

@interface RestkitModel ()

@end

@implementation RestkitModel

@synthesize currentUser;

+ (RestkitModel *) sharedModel {
  if (sharedModel == nil) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedModel = [[RestkitModel alloc]init];
    });
  }
  return sharedModel;
}


- (RestkitModel *)init {
  self = [super init];
  if (self) {
  
  }
  
  return self;
}

@end
