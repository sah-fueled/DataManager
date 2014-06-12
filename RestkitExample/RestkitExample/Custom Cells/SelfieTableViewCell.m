//
//  SelfieTableViewCell.m
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieTableViewCell.h"
#import "Selfie.h"

@interface SelfieTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selfieImageView;
@property (weak, nonatomic) IBOutlet UILabel *selfieIdLabel;

@end

@implementation SelfieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelfieTableViewCell" owner:nil options:nil];
      self = [nib firstObject];
    }
    return self;
}

- (void)initializeWithSelfie:(Selfie *)selfie {
  [self.captionLabel setText:selfie.caption];
  [self.selfieIdLabel setText:[NSString stringWithFormat:@"%@",selfie.selfieId]];
  dispatch_queue_t loaderQueue = dispatch_queue_create("imageLoaderQueue", 0);

  dispatch_async(loaderQueue, ^{
    NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:selfie.imageURL]];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.selfieImageView.image = [UIImage imageWithData:data];
    });
  });
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
