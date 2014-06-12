//
//  DataModel.m
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "DataModel.h"

static DataModel *sharedInstance = nil;

@implementation DataModel

+ (DataModel *)sharedModel {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DataModel alloc]init];
  });

  return sharedInstance;
}

@end
