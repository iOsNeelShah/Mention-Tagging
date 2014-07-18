//
//  MentionTaggingTextView.m
//  MentionTaging
//
//  Created by Neel Shah on 18/03/14.
//  Copyright (c) 2014 Neel Shah. All rights reserved.
//

#import "MentionTaggingTextView.h"
#import "FollowingFollowers.h"

@implementation MentionTaggingTextView
@synthesize hmc;
@synthesize arrFollowersMain;
@synthesize mArrUserSelectFollower;
@synthesize delegateClass;
@synthesize tblView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self initialize];
    }
    return self;
}

-(id)init {
	if (self = [super init]) {
		[self initialize];
	}
	return self;
}

-(void)initialize
{
	hmc=[[GGHashtagMentionController alloc] initWithTextView:self delegate:self];
	self.delegate=self;
	tblView.delegate=self;
	mArrSearchFollowerList=[[NSMutableArray alloc] init];
	mArrUserSelectFollower=[[NSMutableArray alloc] init];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	
	if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
	
	if ([text isEqualToString:@" "])
	{
		[mArrSearchFollowerList removeAllObjects];
		if ([self.delegateClass respondsToSelector:@selector(mentionTagControllerAfterSelectName)]) {
			[self.delegateClass mentionTagControllerAfterSelectName];
		}
	}
	
	// When the clicks back button
	BOOL isReduceFromArray=FALSE;
    if ([text isEqualToString:@""])
    {
        // Go through the array for Objects
        for (int i = 0; i < [mArrUserSelectFollower count]; i++) {
            NSRange rangeFromArray = [[[mArrUserSelectFollower objectAtIndex:i] objectForKey:@"textRange"] rangeValue];
			if (NSLocationInRange(range.location, rangeFromArray)) {
				NSString *subStrAfterDelete = [textView.text stringByReplacingCharactersInRange:rangeFromArray withString:@""];
				
				// Remove range from current and labels ranges array
				[mArrUserSelectFollower removeObjectAtIndex:i];
				isReduceFromArray=TRUE;
				
				for (int j=0; j<[mArrUserSelectFollower count]; j++) {
					if (textView.text.length!=range.location) {
						NSRange rangeNew=[[[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"textRange"] rangeValue];
						int textRange=rangeNew.location+rangeNew.length;
						if (textRange>range.location) {
							rangeNew.location= abs(rangeNew.location-rangeFromArray.length);
							[mArrUserSelectFollower replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																					   [NSValue valueWithRange:rangeNew],@"textRange",
																					   [[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"userId"],@"userId",
																					   [[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"sUserFullName"],@"sUserFullName",
																					   nil]];
						}
					}
				}
				// Set the text with added
				if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 6.0) {
					NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
					paragraphStyle.alignment = NSTextAlignmentLeft;
					
					NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",subStrAfterDelete]];
					for (int k=0; k<[mArrUserSelectFollower count]; k++) {
						[mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:[[[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"textRange"] rangeValue]];
					}
					[mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subStrAfterDelete length])];
					self.attributedText=mutableAttributedString;
					self.selectedRange = NSMakeRange(rangeFromArray.location, 0);
				}
				else
					[textView setText:[NSString stringWithFormat:@"%@ ",subStrAfterDelete]];
				
				if (isReduceFromArray) {
					return YES;
				}
			}
        }
		for (int k=0; k<[mArrUserSelectFollower count]; k++)
		{
			NSRange rangeNew=[[[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"textRange"] rangeValue];
			int textRange=rangeNew.location+rangeNew.length;
			if (textRange>range.location)
			{
				rangeNew.location=rangeNew.location-range.length;
				
				[mArrUserSelectFollower replaceObjectAtIndex:k withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																		   [NSValue valueWithRange:rangeNew],@"textRange",
																		   [[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"userId"],@"userId",
																		   [[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"sUserFullName"],@"sUserFullName",
																		   nil]];
			}
		}
    }
	else
	{
		NSMutableIndexSet *duplicated = [NSMutableIndexSet indexSet];
		for (int k=0; k<[mArrUserSelectFollower count]; k++)
		{
			NSRange rangeNew=[[[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"textRange"] rangeValue];
			int textRange=rangeNew.location+rangeNew.length;
			if (textRange>range.location)
			{
				rangeNew.location=rangeNew.location+text.length;
				[mArrUserSelectFollower replaceObjectAtIndex:k withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																		   [NSValue valueWithRange:rangeNew],@"textRange",
																		   [[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"userId"],@"userId",
																		   [[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"sUserFullName"],@"sUserFullName",
																		   nil]];
			}
			if (NSLocationInRange(range.location, rangeNew) || range.location==textRange) {
				[duplicated addIndex:k];
			}
		}
		[mArrUserSelectFollower removeObjectsAtIndexes:duplicated];
		if ([duplicated count]>0) {
			if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 6.0) {
				NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
				paragraphStyle.alignment = NSTextAlignmentLeft;
				
				NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
				for (int k=0; k<[mArrUserSelectFollower count]; k++) {
					[mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:[[[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"textRange"] rangeValue]];
				}
				[mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
				self.attributedText=mutableAttributedString;
				self.selectedRange = NSMakeRange(range.location, 0);
			}
		}
	}
	
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	// Get the current text
	NSMutableString * textStr = [NSMutableString stringWithString:self.text];
	
	// Get the Previously added values
	FollowingFollowers	 *follow=[mArrSearchFollowerList objectAtIndex:indexPath.row];
	NSString *str = [NSString stringWithFormat:@"@%@",follow.sUserFullName];
	
	
	NSArray *arrString=[str componentsSeparatedByString:@" "];
	
	// Create the final string to be replaced
	NSRange location=replaceRange;
	NSRange subLocation=location;
	
	[textStr replaceCharactersInRange:location withString:[NSString stringWithFormat:@"%@ ",str]];
	
	// Make the NSRange for the string for storing
	int iArrCount=[mArrUserSelectFollower count];
	
	for (int i=0; i<[arrString count]; i++)
	{
		NSString *stringFinal=[arrString objectAtIndex:i];
		
		if (i>=0 && i<[arrString count]-1) {
			stringFinal=[stringFinal stringByAppendingString:@" "];
		}
		
		NSString *preString=@"";
		if (i!=0)
		{
			preString=[preString stringByAppendingFormat:@"%@ ",[arrString objectAtIndex:i-1]];
		}
		subLocation.location=subLocation.location+preString.length;
		NSRange rangeFinal;
		rangeFinal = NSMakeRange(subLocation.location, stringFinal.length);
		
		NSDictionary *dicRangNId=[NSDictionary dictionaryWithObjectsAndKeys:
								  [NSValue valueWithRange:rangeFinal],@"textRange",
								  [NSNumber numberWithInt:follow.iUserId],@"userId",
								  follow.sUserFullName,@"sUserFullName",
								  nil];
		
		[mArrUserSelectFollower addObject:dicRangNId];
		
		int reduce=1;
		if (i>0) {
			reduce=0;
		}
		
		for (int j=0;j<iArrCount;j++) {
			NSRange arrayRange=[[[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"textRange"] rangeValue];
			int textRange=arrayRange.location+arrayRange.length;
			if (textRange>location.location) {
				arrayRange.location=(arrayRange.location-reduce)+stringFinal.length;
				[mArrUserSelectFollower replaceObjectAtIndex:j withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																		   [NSValue valueWithRange:arrayRange],@"textRange",
																		   [[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"userId"],@"userId",
																		   [[mArrUserSelectFollower objectAtIndex:j] objectForKey:@"sUserFullName"],@"sUserFullName",
																		   nil]];
			}
		}
	}
	
	NSMutableIndexSet *indexSet=[NSMutableIndexSet new];;
	for (int i=0; i<[mArrUserSelectFollower count]; i++)
	{
		NSRange arrayRange=[[[mArrUserSelectFollower objectAtIndex:i] objectForKey:@"textRange"] rangeValue];
		int textRange=arrayRange.location+arrayRange.length;
		if (textRange>textStr.length) {
			[indexSet addIndex:i];
		}
	}
	[mArrUserSelectFollower removeObjectsAtIndexes:indexSet];
	
	// Add the same range for labels string for drawing
	if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 6.0) {
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
		paragraphStyle.alignment = NSTextAlignmentLeft;
		
		NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
		for (int k=0; k<[mArrUserSelectFollower count]; k++) {
			[mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:[[[mArrUserSelectFollower objectAtIndex:k] objectForKey:@"textRange"] rangeValue]];
		}
		[mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
		self.attributedText=mutableAttributedString;
	}
	else
		[self setText:textStr];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	self.selectedRange = NSMakeRange(self.text.length,0);
	
	if ([self.delegateClass respondsToSelector:@selector(mentionTagControllerAfterSelectName)]) {
		[self.delegateClass mentionTagControllerAfterSelectName];
	}
	
	[mArrSearchFollowerList removeAllObjects];
	
}

#pragma mark - GGHMCDelegate

//For Mentions
- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range
{
    replaceRange = range;
	[mArrSearchFollowerList removeAllObjects];
    if (![text isEqualToString:@""]) {
		[self searchContactWD:text];
	}
    if ([self.delegateClass respondsToSelector:@selector(mentionTagControllerAfterSearch:)]) {
		[self.delegateClass mentionTagControllerAfterSearch:mArrSearchFollowerList];
	}
}

//For HashTag
- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onHashtagWithText:(NSString *)text range:(NSRange)range
{
	if ([self.delegateClass respondsToSelector:@selector(hasTagController)]) {
		[self.delegateClass hasTagController];
	}
}

//For other Text
- (void) hashtagMentionControllerDidFinishWord:(GGHashtagMentionController *)hashtagMentionController {
    replaceRange = NSMakeRange(NSNotFound, 0);
    [mArrSearchFollowerList removeAllObjects];
    if ([self.delegateClass respondsToSelector:@selector(ForOtherControllerText)]) {
		[self.delegateClass ForOtherControllerText];
	}
}



#pragma mark - Search

- (void) searchContactWD:(NSString *)searchTextFollower
{
	[mArrSearchFollowerList removeAllObjects];
    NSString *searchText = searchTextFollower;
    NSMutableArray *arrSearchText=[NSMutableArray arrayWithArray:[searchText componentsSeparatedByString:@" "]];
	if ([[arrSearchText lastObject] isEqualToString:@""]) {
		[arrSearchText removeLastObject];
	}
    
    for(int i=0;i<[arrFollowersMain count];i++)
    {
		FollowingFollowers *info=[arrFollowersMain	objectAtIndex:i];
		[self SearchWords:info arrSearchText:arrSearchText];
    }
}

-(BOOL)SearchLogic:(NSString *)To compare:(NSString *)From
{
    NSComparisonResult resultArr = [To compare:From options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [From length])];
    
    return resultArr==NSOrderedSame;
}

-(void)SearchWords:(FollowingFollowers *)sInfo arrSearchText:(NSArray *)arrSearchText
{
	NSArray *arrFields=[sInfo.sUserFullName componentsSeparatedByString:@" "];
	int match1=0;
	NSMutableDictionary *mDicStoreWordMatch=[[NSMutableDictionary alloc] init];
	for (int iFieldIndex=0; iFieldIndex<[arrFields count]; iFieldIndex++) {
		for (int iSearchIndex=0; iSearchIndex<[arrSearchText count]; iSearchIndex++) {
			
			if ([self SearchLogic:[arrFields objectAtIndex:iFieldIndex] compare:[arrSearchText objectAtIndex:iSearchIndex]]){
				if (![mDicStoreWordMatch objectForKey:[arrSearchText objectAtIndex:iSearchIndex]]) {
					[mDicStoreWordMatch setObject:[NSNumber numberWithInt:TRUE] forKey:[arrSearchText objectAtIndex:iSearchIndex]];
					match1++;
				}
			}
		}
	}
	
	if (match1==[arrSearchText count]) {
		[mArrSearchFollowerList addObject:sInfo];
	}
}

-(NSArray *)getMentionTagArray
{
	return mArrUserSelectFollower;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
