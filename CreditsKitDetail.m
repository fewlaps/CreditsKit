//
//  CredtisKitView.h
//
//  Created by yeradis on 10/02/16.
//  Copyright © 2016 Yeradis. All rights reserved.
//

#import "CreditsKitDetail.h"

@interface CreditsKitDetail ()
    @property  NSString* headerContent;
    @property  NSString* descriptionContent;

    @property (weak, nonatomic) IBOutlet UILabel *titleText;
    @property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@end

@implementation CreditsKitDetail

-(id) initWithContentTitle:(NSString *)title description:(NSString *)description {
    self = [super init];
    if (self) {
        self.headerContent = title;
        self.descriptionContent = description;
        self.closeButtonText = @"Close";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.closeButtonText  style: UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    self.title = self.headerContent;
    self.titleText.text = self.headerContent;
    self.descriptionText.text = self.descriptionContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
