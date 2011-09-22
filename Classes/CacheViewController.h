//
//  CacheViewController.h
//  iSub
//
//  Created by Ben Baron on 6/1/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//

//#import <UIKit/UIKit.h>  // REMOVED THIS TO STOP XCODE SYNTAX HIGHLIGHT PROBLEM, THIS IS INCLUDED IN THE PROJECT HEADER
//#import <Foundation/Foundation.h>  // REMOVED THIS TO STOP XCODE SYNTAX HIGHLIGHT PROBLEM, THIS IS INCLUDED IN THE PROJECT HEADER

@class iSubAppDelegate, ViewObjectsSingleton, MusicSingleton, DatabaseSingleton, SavedSettings, CacheSingleton;

@interface CacheViewController : UITableViewController 
{
	iSubAppDelegate *appDelegate;
	ViewObjectsSingleton *viewObjects;
	MusicSingleton *musicControls;
	DatabaseSingleton *databaseControls;
	CacheSingleton *cacheControls;
	SavedSettings *settings;
	
	BOOL isNoSongsScreenShowing;
	UIImageView *noSongsScreen;
	
	UIView *headerView;
	UIView *headerView2;
	UISegmentedControl *segmentedControl;
	UILabel *songsCountLabel;
	UILabel *cacheSizeLabel;
	UIButton *deleteSongsButton;
	UILabel *deleteSongsLabel;
	UILabel *spacerLabel;
	UILabel *editSongsLabel;
	UIButton *editSongsButton;
	BOOL isSaveEditShowing;
	
	UIImageView *playAllImage;
	UILabel *playAllLabel;
	UIButton *playAllButton;
	UILabel *spacerLabel2;
	UIImageView *shuffleImage;
	UILabel *shuffleLabel;
	UIButton *shuffleButton;
	
	//UIProgressView *queueDownloadProgressView;
	unsigned long long int queueDownloadProgress;
	NSTimer *updateTimer;
	
	NSMutableArray *listOfArtists;
	NSMutableArray *listOfArtistsSections;
	NSArray *sectionInfo;
	NSUInteger rowCounter;
		
	UIButton *jukeboxInputBlocker;
	
	BOOL showIndex;
}

@property (nonatomic, retain) NSMutableArray *listOfArtists;
@property (nonatomic, retain) NSMutableArray *listOfArtistsSections;
@property (nonatomic, retain) NSArray *sectionInfo;

//@property (nonatomic, retain) UIProgressView *queueDownloadProgressView;

- (void) editSongsAction:(id)sender;

@end
