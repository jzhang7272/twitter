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

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeText.delegate = self;
    self.composeText.text = @"What's happening?";
    self.composeText.textColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}
- (IBAction)closeTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"What's happening?"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What's happening?";
        textView.textColor = [UIColor lightGrayColor]; //optional
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
