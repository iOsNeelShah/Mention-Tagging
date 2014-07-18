//
//  SimpleViewController.h
//  MentionTaging
//
//  Created by Neel Shah on 18/03/14.
//  Copyright (c) 2014 Neel Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MentionTaggingTextView.h"

@interface SimpleViewController : UIViewController<MentionTaggingTextViewDelegate>
{
	IBOutlet UITableView *IBlblView;
	NSMutableArray *mArrFollower;
}

@property (nonatomic,retain)IBOutlet MentionTaggingTextView *IBtxtViewMention;

@end
