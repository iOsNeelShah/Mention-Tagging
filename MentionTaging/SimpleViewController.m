//
//  SimpleViewController.m
//  MentionTaging
//
//  Created by Neel Shah on 18/03/14.
//  Copyright (c) 2014 Neel Shah. All rights reserved.
//

#import "SimpleViewController.h"
#import "MentionTaggingTextView.h"
#import "FollowingFollowers.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSMutableArray *arr=[[NSMutableArray alloc] init];
	FollowingFollowers *follow1=[[FollowingFollowers alloc] init];
	follow1.sUserFullName=@"Neel";
	follow1.iUserId=1;
	[arr addObject:follow1];
	
	FollowingFollowers *follow2=[[FollowingFollowers alloc] init];
	follow2.sUserFullName=@"Hello Neel";
	follow2.iUserId=10;
	[arr addObject:follow2];
	
	FollowingFollowers *follow3=[[FollowingFollowers alloc] init];
	follow3.sUserFullName=@"Shah Neel";
	follow3.iUserId=100;
	[arr addObject:follow3];
	
	_IBtxtViewMention.arrFollowersMain=[NSArray arrayWithArray:arr];
	_IBtxtViewMention.delegateClass=self;
	_IBtxtViewMention.tblView=IBlblView;
	[_IBtxtViewMention initialize];
	
	
	mArrFollower=[[NSMutableArray alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //Change the total no of section you wants
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [mArrFollower count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    // Configure the cell...
	FollowingFollowers *follow=[mArrFollower objectAtIndex:indexPath.row];
	
    cell.textLabel.text = follow.sUserFullName;
	
    return cell;
}

-(void)toHideTableFollower
{
	
}

-(void)mentionTagControllerAfterSearch:(NSArray *)arrFollower
{
	mArrFollower=[NSMutableArray arrayWithArray:arrFollower];
	[IBlblView reloadData];
}

-(void)mentionTagControllerAfterSelectName
{
	[mArrFollower removeAllObjects];
	NSArray *arrMentionTag=[_IBtxtViewMention getMentionTagArray];
	[IBlblView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
