//
//  CellOverlay.h
//  iSub
//
//  Created by bbaron on 11/12/10.
//  Copyright 2010 Ben Baron. All rights reserved.
//

//#import <UIKit/UIKit.h>  // REMOVED THIS TO STOP XCODE SYNTAX HIGHLIGHT PROBLEM, THIS IS INCLUDED IN THE PROJECT HEADER


@interface CellOverlay : UIView 
{
	UIButton *downloadButton;
	UIButton *queueButton;
}

@property (nonatomic, retain) UIButton *downloadButton;
@property (nonatomic, retain) UIButton *queueButton;

+ (CellOverlay*)cellOverlayWithTableCell:(UITableViewCell*)cell;
- (id)initWithTableCell:(UITableViewCell*)cell;

@end
