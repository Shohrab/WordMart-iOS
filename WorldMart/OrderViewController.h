//
//  OrderViewController.h
//  WorldMart
//
//  Created by Adit Hasan on 1/7/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@interface OrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SlideNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *OrderTable;
@end
