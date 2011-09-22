//
//  SocialControlsSingleton.h
//  iSub
//
//  Created by Ben Baron on 10/15/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//

//#import <Foundation/Foundation.h>  // REMOVED THIS TO STOP XCODE SYNTAX HIGHLIGHT PROBLEM, THIS IS INCLUDED IN THE PROJECT HEADER

#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface SocialSingleton : NSObject <SA_OAuthTwitterControllerDelegate>
{
	
	SA_OAuthTwitterEngine *twitterEngine;

}

@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

+ (SocialSingleton*)sharedInstance;

- (void) createTwitterEngine;

@end
