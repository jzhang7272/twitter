//
//  ComposeViewController.m
//  Pods
//
//  Created by Josey Zhang on 6/29/21.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeText;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) int count;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeText.delegate = self;
    self.composeText.text = @"What's happening?";
    self.composeText.textColor = [UIColor lightGrayColor];
    self.count = 140;
}
- (IBAction)closeTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"What's happening?"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    
    NSString *newText = [self.composeText.text stringByReplacingCharactersInRange:range withString:text];
    self.count = newText.length;
    
    self.countLabel.text = [NSString stringWithFormat:@"Characters: %d/140", self.count];

    return newText.length < characterLimit;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What's happening?";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

// Post tweet and send back to home timeline
- (IBAction)postTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.composeText.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}
@end
