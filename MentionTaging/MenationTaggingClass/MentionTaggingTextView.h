//
//  MentionTaggingTextView.h
//  MentionTaging
//
//  Created by Neel Shah on 18/03/14.
//  Copyright (c) 2014 Neel Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGHashtagMentionController.h"



@protocol MentionTaggingTextViewDelegate;

@interface MentionTaggingTextView : UITextView<GGHashtagMentionDelegate,UITextViewDelegate,UITableViewDelegate>
{
	NSRange replaceRange;
	NSMutableArray *mArrSearchFollowerList;
	
	id <MentionTaggingTextViewDelegate> __unsafe_unretained _delegateClass;
}


@property (nonatomic, retain) GGHashtagMentionController *hmc;
@property (nonatomic,retain)UITableView *tblView;

@property (unsafe_unretained) id <MentionTaggingTextViewDelegate> delegateClass;

@property (nonatomic,retain)NSMutableArray *mArrUserSelectFollower;
@property (nonatomic,retain)NSArray *arrFollowersMain;

-(void)initialize;

-(NSArray *)getMentionTagArray;

@end



@protocol MentionTaggingTextViewDelegate <NSObject>

@optional

- (void)mentionTagControllerAfterSearch:(NSArray *)arrFollower;

- (void)mentionTagControllerAfterSelectName;

-(void)hasTagController;

-(void)ForOtherControllerText;

@end
