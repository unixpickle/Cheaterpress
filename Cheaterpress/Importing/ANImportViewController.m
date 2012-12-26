//
//  ANImportViewController.m
//  Cheaterpress
//
//  Created by Alex Nichol on 12/25/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANImportViewController.h"

@interface ANImportViewController ()

@end

@implementation ANImportViewController

@synthesize delegate;

- (id)initWithGame:(Game *)g {
    if ((self = [super init])) {
        self.title = @"Import";
        
        game = g;
        self.view.backgroundColor = [UIColor whiteColor];
        
        button = [[ANSimplisticButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20,
                                                                      kANSimplisticButtonHeight)];
        [button addTarget:self action:@selector(pickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Pick Image"];
        [self.view addSubview:button];
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return self;
}

- (void)pickButtonPressed:(id)sender {
    if (import) {
        [import cancel];
        import = nil;
        [button setTitle:@"Pick Image"];
    } else {
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    import = [[ANBoardImport alloc] initWithImage:image];
    [import setDelegate:self];
    [import start];
    [button setTitle:@"Cancel"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (import) {
        [import cancel];
    }
}

#pragma mark - Board Import -

- (void)boardImportFinished:(ANBoardImport *)anImport {
    for (int i = 0; i < 25; i++) {
        int row = i / 5;
        int column = i % 5;
        Box * b = nil;
        for (Box * aBox in game.boxes) {
            if (aBox.column == column && aBox.row == row) {
                b = aBox;
                break;
            }
        }
        b.owner = [import ownerAtIndex:i];
        b.letter = [NSString stringWithFormat:@"%c", toupper([anImport letterAtIndex:i])];
    }
    if ([delegate respondsToSelector:@selector(importViewControllerDone:)]) {
        [delegate importViewControllerDone:self];
    }
    import = nil;
}

- (void)boardImport:(ANBoardImport *)theImport failedWithError:(NSError *)error {
    import = nil;
    [button setTitle:@"Pick Image"];
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:@"Failed to process the game image."
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
    [av show];
}

@end
