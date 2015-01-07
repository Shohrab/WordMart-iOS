//
//  ProductCell.h
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtPrice;
@property (weak, nonatomic) IBOutlet UILabel *txttimeLabel;
@property (weak, nonatomic) IBOutlet DYRateView *starrateView;
@property (weak, nonatomic) IBOutlet UIImageView *photoVIew;

@end
