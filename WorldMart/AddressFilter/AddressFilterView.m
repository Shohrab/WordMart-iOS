//
//  AddressFilterView.m
//  Unicabi
//
//  Created by Aitl on 3/23/14.
//
//

#import "AddressFilterView.h"
#import "MBProgressHUD.h"
@interface AddressFilterView ()

@end

@implementation AddressFilterView
@synthesize delegate;
@synthesize viewname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.NearestContentArray=[[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent=NO;
    [self addRightButton];
    
    autocompleteObj=[[AutoCompleteSearchViewController alloc]init];
    autocompleteObj.delegate=self;
    
    [AddressTableView setBackgroundColor:[UIColor clearColor]];
    [AddressTableView setSeparatorInset:UIEdgeInsetsZero];
    
 
    
}
-(void)viewWillAppear:(BOOL)animated{
    UIImage *padingImg=nil;
    
    if ([self.TopbarTitle isEqualToString:@"ENTER PICKUP"]) {
        
        
        SearchTextField.placeholder=NSLocalizedString(@"Enter postcode or Address", @"Enter postcode or Address");
        padingImg=[UIImage imageNamed:@"PadpickUpLabel.png"];
        [SearchTextField becomeFirstResponder];

    }else{
    
        SearchTextField.placeholder=NSLocalizedString(@"Enter postcode or Address", @"Enter postcode or Address");
        padingImg=[UIImage imageNamed:@"DropOffPadd.png"];
        [SearchTextField becomeFirstResponder];
    
    }
    
    self.title=self.TopbarTitle;
    
    UIView *leftview=[[UIView alloc]initWithFrame:CGRectMake(0, 1, padingImg.size.width, padingImg.size.height)];
    UIImageView *imgViews=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, padingImg.size.width, padingImg.size.height)];
    imgViews.image=padingImg;
    [leftview addSubview:imgViews];
    leftview.frame=CGRectMake(leftview.frame.origin.x, leftview.frame.origin.y, leftview.frame.size.width+5, leftview.frame.size.height);
    
    SearchTextField.leftView=leftview;
    SearchTextField.delegate=self;
    SearchTextField.leftViewMode=UITextFieldViewModeAlways;
    SearchTextField.returnKeyType = UIReturnKeySearch;
    SearchTextField.clearButtonMode=UITextFieldViewModeAlways;
}
- (void)addRightButton {
    
    UIImage *backButtonImage = [UIImage imageNamed:@"CloseButton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:backButtonImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"backTapBox"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismissViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //[self.navigationItem setRightBarButtonItem:barButtonItem];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -18;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, barButtonItem/*this will be the button which u actually need*/, nil] animated:YES];

    
}
-(void)dismissViewAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    
    [autocompleteObj autocompleteSearch:SearchTextField.text];
    //[fourview setFoursquireAddress:SearchTextField.text];
    
    return YES;
}

-(void)returnAddressListFromGoogle:(NSArray *)addresslistArray{

     NSLog(@"Address list -%@",addresslistArray);
    
    [self.NearestContentArray removeAllObjects];
    [self.NearestContentArray addObjectsFromArray:addresslistArray];
    
    [AddressTableView reloadData];
    

}
-(void)returnSelectedAddressLocFromGoogle:(NSDictionary *)addressInfo{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (![viewname isEqualToString:@"DROPOFF"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pickuplocation" object:self userInfo:addressInfo];//_08_06_14 transparen picup purpose
    }
    [self dismissViewControllerAnimated:YES completion:^{
    
        [self.delegate SelectedAddressFromList:addressInfo];
     
        
    }];
}
#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.NearestContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.textLabel.text=[[self.NearestContentArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell.imageView.image=[UIImage imageNamed:@"lociCon.png"];
    [cell setBackgroundColor:[UIColor clearColor]];
     return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

   //fourview setFoursquireAddress:SearchTextField.text];
    [SearchTextField resignFirstResponder];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [autocompleteObj AddressInfoDetail:[[self.NearestContentArray objectAtIndex:indexPath.row] valueForKey:@"reference"]];
    [table deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
