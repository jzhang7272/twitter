//
//  ComposeViewController.h
//  Pods
//
//  Created by Josey Zhang on 6/29/21.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

// protocol creates a contract between the ComposeViewController and whichever view controller presented it
@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

// weak avoids memory leaks
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
