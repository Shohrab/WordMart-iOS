//
//  ViewController.h
//  WorldMart
//
//  Created by Adit Hasan on 1/6/15.
//  Copyright (c) 2015 Adit Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@interface ViewController : UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *listTableVIew;
@property(nonatomic,strong)NSString *categoryID;

@end

