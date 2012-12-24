//
//  ANAddViewController.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/23/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANAddViewController.h"

@interface ANAddViewController ()

@end

@implementation ANAddViewController

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                   target:self
                                                                   action:@selector(donePressed:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        opponentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 32)];
        opponentField.borderStyle = UITextBorderStyleRoundedRect;
        opponentField.placeholder = @"Opponent Name";
        [self.view addSubview:opponentField];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)donePressed:(id)sender {
    [delegate addViewController:self addedWithOpponent:opponentField.text];
}

@end
