#import <Foundation/Foundation.h>


@protocol GGHashtagMentionDelegate;

@interface GGHashtagMentionController : NSObject

- (id) initWithTextView:(UITextView *)textView delegate:(id <GGHashtagMentionDelegate>)delegate;

@end

@protocol GGHashtagMentionDelegate <NSObject>

@optional

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range;

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onHashtagWithText:(NSString *)text range:(NSRange)range;

- (void) hashtagMentionControllerDidFinishWord:(GGHashtagMentionController *)hashtagMentionController;

@end