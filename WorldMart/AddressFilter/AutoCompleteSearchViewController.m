//
//  AutoCompleteSearchViewController.m
//  Unicabi
//
//  Created by AITL on 12/10/13.
//
//

#import "AutoCompleteSearchViewController.h"
#import "AFNetworking.h"
#define GoogleAPIKey @"AIzaSyCWolR9_wDYS3iXDshSRcb-eIjlfGPZLFM"   //new

@interface AutoCompleteSearchViewController ()

@end

@implementation AutoCompleteSearchViewController
@synthesize delegate;

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
    
    searchTextField.delegate=self;
    searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([searchTextField.text length]==0) {
        [self.NearestContentArray removeAllObjects];
        [AutoCompleteSearchTable reloadData];
    }else
    [self autocompleteSearch:searchTextField.text];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.NearestContentArray removeAllObjects];
    [AutoCompleteSearchTable reloadData];

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([searchTextField.text length]==0) {
        [self.NearestContentArray removeAllObjects];
        [AutoCompleteSearchTable reloadData];
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)autocompleteSearch:(NSString*)searchText{
    
    NSString *requestingUrl = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=&language=&sensor=true&key=%@",searchText,GoogleAPIKey] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestingUrl]];
    
    NSLog(@"request url-->%@",requestingUrl);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                          
                        NSLog(@"Autocomplete Address - %@",(NSDictionary *)JSON);
                        self.NearestContentArray =[(NSDictionary *)JSON  valueForKey:@"predictions"];
                        if ([self.NearestContentArray count]!=0){
                        [self.delegate returnAddressListFromGoogle:self.NearestContentArray];
                                                                                                
                    }
                                                                          
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

        NSLog(@"Failing to get Address");
    }];
    
    [operation start];
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
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.textLabel.font=[UIFont systemFontOfSize:10];
    cell.textLabel.text=[[self.NearestContentArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    [self AddressInfoDetail:[[self.NearestContentArray objectAtIndex:indexPath.row] valueForKey:@"reference"]];
}
 /*Calculating DistanceFromGoogle*/

-(void)AddressInfoDetail:(NSString*)referenceCode{
    
    NSString *requestingUrl = [[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=%@",referenceCode,GoogleAPIKey] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestingUrl]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                NSDictionary *dic=[(NSDictionary *)JSON valueForKey:@"result"];
                                                    
                               // NSLog(@"Response - %@",dic);
                                                      
                                                                                            
                                NSArray *addressComponent=[dic valueForKey:@"address_components"];
                                NSString *PostCodeInfo=nil;
                                                                                            
                                NSLog(@"Adress - %@",addressComponent);

                                for (int i=0; i<[addressComponent count]; i++) {
                                                                                                
                            if ([[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"postal_code"]||[[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"postal_code_prefix"]) {
//                            if ([[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_2"]){
//                                        
                                    
                                NSArray *postcodes=[[[addressComponent objectAtIndex:i] valueForKey:@"short_name"] componentsSeparatedByString:@" "];
                                //NSLog(@"postcode array-%@",postcodes);
                                
                                PostCodeInfo =[postcodes objectAtIndex:0];
                                NSLog(@"postcodeInfo---%@",PostCodeInfo);
                                break;
                            }
                                                                                                
                            }
                                      
                        NSString *chooseCountry = @"";
                                                                                            
                        NSString *cityName = @"";
                                                
                        NSString *stateName = @"";
                                                                                            
                        for (int i=0; i<[addressComponent count]; i++) {
                            
                            if ([[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0]isEqualToString:@"country"]) {
                                chooseCountry = [[addressComponent objectAtIndex:i] valueForKey:@"long_name"];
                      
                            }
                            if ([[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0]isEqualToString:@"locality"]) {
                                cityName = [[addressComponent objectAtIndex:i] valueForKey:@"long_name"];
                                
                            }
                            
                            if ([[[[addressComponent objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0]isEqualToString:@"administrative_area_level_1"]) {
                                stateName = [[addressComponent objectAtIndex:i] valueForKey:@"long_name"];
                                
                            }
                            
                        }
                                NSMutableDictionary *MutableDictionary=[[NSMutableDictionary alloc]init];
                                [MutableDictionary setObject:[dic valueForKey:@"formatted_address"] forKey:@"address"];
                                if (PostCodeInfo!=nil) {
                                [MutableDictionary setObject:PostCodeInfo forKey:@"postcode"];
                                    }else
                                [MutableDictionary setObject:@"Unavailable" forKey:@"postcode"];
                                [MutableDictionary setObject:chooseCountry forKey:@"country"];
                                [MutableDictionary setObject:cityName forKey:@"city"];
                                [MutableDictionary setObject:cityName forKey:@"state"];
                                                                                            
                                                                                            
                                [self.delegate returnSelectedAddressLocFromGoogle:MutableDictionary];
                                                                                            
                                }
                                                                                        
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
   // [[AppDelegate shareDelegate] customAlert:@"Warning!" withMessage:@"Could not Connect to the server."];
        
    }];
    [operation start];
    
}


- (IBAction)DoneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}
- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
