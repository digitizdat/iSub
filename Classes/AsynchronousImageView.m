//
//  AsynchronousImageView.m
//  GLOSS
//
//  Created by Слава on 22.10.09.
//  Copyright 2009 Slava Bushtruk. All rights reserved.
//  ---------------------------------------------------
//
//  Modified by Ben Baron for the iSub project.
//

#import "AsynchronousImageView.h"
#import "iSubAppDelegate.h"
#import "MusicControlsSingleton.h"
#import "DatabaseControlsSingleton.h"
#import "Song.h"
#import "NSString-md5.h"
#import "FMDatabase.h"
#import "PageControlViewController.h"

@implementation AsynchronousImageView

@synthesize coverArtId, isForPlayer;

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:(NSCoder*)coder];
	
    if (self != nil)
    {
		appDelegate = (iSubAppDelegate *)[[UIApplication sharedApplication] delegate];
		musicControls = [MusicControlsSingleton sharedInstance];
		databaseControls = [DatabaseControlsSingleton sharedInstance];
		isForPlayer = NO;
    }
	
    return self;
}


#pragma mark -
#pragma mark Handle User Input

- (void)reloadCoverArt
{	
	/*if(musicControls.currentSongObject.coverArtId)
	{
		musicControls.coverArtUrl = nil;
		if (appDelegate.isHighRez)
		{
			musicControls.coverArtUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@&size=640", [appDelegate getBaseUrl:@"getCoverArt.view"], musicControls.currentSongObject.coverArtId]];
		}
		else
		{	
			musicControls.coverArtUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@&size=320", [appDelegate getBaseUrl:@"getCoverArt.view"], musicControls.currentSongObject.coverArtId]];
		}
		[self loadImageFromURLString:[musicControls.coverArtUrl absoluteString]];
	}
	else 
	{
		self.image = [UIImage imageNamed:@"default-album-art.png"];
	}*/
}

-(void)oneTap
{
	DLog(@"Single tap");
	PageControlViewController *pageControlViewController = [[PageControlViewController alloc] initWithNibName:@"PageControlViewController" bundle:nil];
	[self addSubview:pageControlViewController.view];
	[pageControlViewController showSongInfo];
}

-(void)twoTaps
{
	DLog(@"Double tap");
	[self reloadCoverArt];
}

-(void)threeTaps
{
	DLog(@"Triple tap");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// Detect touch anywhere
	UITouch *touch = [touches anyObject];
	
	switch ([touch tapCount]) 
	{
		case 1:
			[self performSelector:@selector(oneTap) withObject:nil afterDelay:.5];
			break;
			
		case 2:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
			[self performSelector:@selector(twoTaps) withObject:nil afterDelay:.5];
			break;
			
		case 3:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoTaps) object:nil];
			[self performSelector:@selector(threeTaps) withObject:nil afterDelay:.5];
			break;
			
		default:
			break;
	}
}

#pragma mark -
#pragma mark Load Image

//- (void)loadImageFromURLString:(NSString *)theUrlString
- (void)loadImageFromCoverArtId:(NSString *)artId isForPlayer:(BOOL)isPlayer
{
	self.coverArtId = artId;
	self.isForPlayer = isPlayer;
	
	appDelegate = (iSubAppDelegate *)[[UIApplication sharedApplication] delegate];
	musicControls = [MusicControlsSingleton sharedInstance];
	databaseControls = [DatabaseControlsSingleton sharedInstance];
	
	songAtTimeOfLoad = [musicControls.currentSongObject copy];

	NSURL *theUrl;
	if (IS_IPAD())
	{
		theUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&size=540", [appDelegate getBaseUrl:@"getCoverArt.view"], coverArtId]];
	}
	else
	{
		if (appDelegate.isHighRez)
		{
			theUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&size=640", [appDelegate getBaseUrl:@"getCoverArt.view"], coverArtId]];
		}
		else
		{	
			theUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&size=320", [appDelegate getBaseUrl:@"getCoverArt.view"], coverArtId]];
		}
	}
	NSURLRequest *request = [NSURLRequest requestWithURL:theUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	data = [[NSMutableData data] retain];
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)space 
{
	if([[space authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) 
	{
		return YES; // Self-signed cert will be accepted
		// Note: it doesn't seem to matter what you return for a proper SSL cert, only self-signed certs
	}
	// If no other authentication is required, return NO for everything else
	// Otherwise maybe YES for NSURLAuthenticationMethodDefault and etc.
	return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{	
	if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge]; 
	}
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    [data appendData:incrementalData];
}


- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	DLog(@"Connection to album art failed");
	if([songAtTimeOfLoad.songId isEqualToString:musicControls.currentSongObject.songId])
	{
		self.image = [UIImage imageNamed:@"default-album-art.png"];
	}
	
	[songAtTimeOfLoad release]; songAtTimeOfLoad = nil;
	[data release]; data = nil;
	[connection release]; connection = nil;
}	


- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{	
	if([songAtTimeOfLoad.songId isEqualToString:musicControls.currentSongObject.songId] || !isForPlayer)
	{
		// Check to see if the data is a valid image. If so, use it; if not, use the default image.
		if([UIImage imageWithData:data])
		{
			if (IS_IPAD())
			{
				[databaseControls.coverArtCacheDb540 executeUpdate:@"INSERT OR REPLACE INTO coverArtCache (id, data) VALUES (?, ?)", [NSString md5:coverArtId], data];
			}
			else
			{
				[databaseControls.coverArtCacheDb320 executeUpdate:@"INSERT OR REPLACE INTO coverArtCache (id, data) VALUES (?, ?)", [NSString md5:coverArtId], data];
			}
			
			if (appDelegate.isHighRez && !IS_IPAD())
			{
				UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0,320.0), NO, 2.0);
				[[UIImage imageWithData:data] drawInRect:CGRectMake(0,0,320,320)];
				self.image = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();
			}
			else
			{
				self.image = [UIImage imageWithData:data];
			}
		}
		else 
		{
			self.image = [UIImage imageNamed:@"default-album-art.png"];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"createReflection" object:nil];
	
	[songAtTimeOfLoad release]; songAtTimeOfLoad = nil;
	[data release]; data = nil;
	[connection release]; connection = nil;
}


- (void)dealloc 
{
	[coverArtId release];
	[super dealloc];
}

@end
