//
//  CredtisKitView.h
//
//  Created by yeradis on 10/02/16.
//  Copyright © 2016 Yeradis. All rights reserved.
//

#import "CreditsKit.h"
#import "CreditsKitDetail.h"

@interface CreditsKit ()
@property NSArray *credits;
@end

@implementation CreditsKit

-(id) initWithPListFile:(NSString *)fileName{
    self = [super init];
    if (self) {
        NSString *PlistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        NSMutableArray *dict = [[NSMutableArray alloc] initWithContentsOfFile:PlistPath];
        self.credits = [dict copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"  style: UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 80;//the estimatedRowHeight but if is more this autoincremented with autolayout
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
}

- (void) doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.credits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* header = [self.credits objectAtIndex:indexPath.row][@"Title"];
    NSString* description = [self.credits objectAtIndex:indexPath.row][@"Text"];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = header;
    cell.detailTextLabel.text = description;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* header = [self.credits objectAtIndex:indexPath.row][@"Title"];
    NSString* description = [self.credits objectAtIndex:indexPath.row][@"Text"];

    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:header message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    messageAlert.width = self.tableView.width;
    // Display Alert Message
    //[messageAlert show];
    
    [self showDetailFor:header description:description];
 
}

-(void) showDetailFor:(NSString*) title description:(NSString*) description {
    // Create the PlainViewController (and give it a title)
    CreditsKitDetail * vc = [[CreditsKitDetail alloc] initWithContentTitle:title description:description];
    [vc setTitle:title];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = kSummaryColor;
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
