//
//  SearchSongsViewController.h
//  iSub
//
//  Created by bbaron on 10/28/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//
//  ---------------
//	searchType:
//
//	0 = artist
//	1 = album
//	2 = song
//

//#import <UIKit/UIKit.h>  // REMOVED THIS TO STOP XCODE SYNTAX HIGHLIGHT PROBLEM, THIS IS INCLUDED IN THE PROJECT HEADER

@class iSubAppDelegate, MusicSingleton, DatabaseSingleton, ViewObjectsSingleton;

@interface SearchSongsViewController : UITableViewController 
{
	iSubAppDelegate *appDelegate;
	MusicSingleton *musicControls;
	DatabaseSingleton *databaseControls;
	ViewObjectsSingleton *viewObjects;
	
	NSString *query;
	NSUInteger searchType;
	
	NSMutableArray *listOfArtists;
	NSMutableArray *listOfAlbums;
	NSMutableArray *listOfSongs;
	
	NSUInteger offset;
	BOOL isMoreResults;
	BOOL isLoading;
	
	NSMutableData *receivedData;
	
	NSURLConnection *connection;
}

@property (nonatomic, retain) NSString *query;
@property NSUInteger searchType;

@property (nonatomic, retain) NSMutableArray *listOfArtists;
@property (nonatomic, retain) NSMutableArray *listOfAlbums;
@property (nonatomic, retain) NSMutableArray *listOfSongs;

@property NSUInteger offset;
@property BOOL isMoreResults;

@property (nonatomic, retain) NSURLConnection *connection;

@end
