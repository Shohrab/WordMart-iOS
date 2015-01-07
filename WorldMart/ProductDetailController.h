//
//  ProductDetailController.h
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *productPhoto;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *Quantitys;
@property (weak, nonatomic) IBOutlet UILabel *discription;
@property (weak, nonatomic) IBOutlet UILabel *vendorName;

@property(nonatomic,strong)NSDictionary *productDetail;

@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
- (IBAction)AddToCart:(id)sender;
@end
