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

+ (RestkitModel *) sharedModel {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [sharedModel initialSetup];
  });
  return sharedModel;
}


- (void)initialSetup {
    
}

@end
