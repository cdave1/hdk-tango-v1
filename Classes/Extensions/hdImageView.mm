//
//  hdImageView.m
//  Sierra
//
//  Created by David Petrie on 4/05/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "hdImageView.h"
#include <hdk/hdk.h>
@implementation hdImageView

@synthesize currentImagePath = _currentImagePath;

// via http://cocoadevcentral.com/articles/000056.php and 
// http://webcache.googleusercontent.com/search?q=cache:E2-VxkryiOsJ:www.cocoadev.com/index.pl%3FNSImageView+NSImageView+drag+drop&cd=1&hl=en&ct=clnk&gl=nz&client=firefox-a

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	NSPasteboard* thePasteboard = [sender draggingPasteboard];
	NSArray* theTypes = [thePasteboard types];
	if([theTypes containsObject:NSFilenamesPboardType])
	{
		NSArray* thePaths = [thePasteboard propertyListForType:NSFilenamesPboardType];
		_currentImagePath = [[thePaths objectAtIndex:0] copy];
	}
	else
	{
		_currentImagePath = nil;
	}
	return [super draggingUpdated:sender];
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender

{
	NSPasteboard* thePasteboard = [sender draggingPasteboard];
	NSArray* theTypes = [thePasteboard types];
	if([theTypes containsObject:NSFilenamesPboardType])
	{
		NSArray* thePaths = [thePasteboard propertyListForType:NSFilenamesPboardType];
		_currentImagePath = [[thePaths objectAtIndex:0] copy];
	}
	else
	{
		_currentImagePath = nil;
	}
	
    return YES;
	
}


/*
- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
	
}*/


- (void)setImageAtContentRepositoryPath:(const char *)path
{
	if (path && strlen(path) > 0)
	{
		NSString *fullPath = [NSString stringWithFormat:@"%s%s", FileSystem_BaseDir(), path];
		_currentImagePath = [fullPath copy];
		NSImage *img = [[NSImage alloc] initWithContentsOfFile:fullPath];
		[self setImage:[img autorelease]];
	}
}


- (const char *)getResourcePathOfImage
{
	if (![self image]) return NULL;
	if (_currentImagePath)
	{
		NSLog(@"%@", _currentImagePath);
		return [[_currentImagePath stringByReplacingOccurrencesOfString:[NSString stringWithUTF8String:FileSystem_BaseDir()]
																 withString:@""] UTF8String];
	}
	return NULL;
		 
}


@end
