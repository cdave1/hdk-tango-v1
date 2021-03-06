//
//  TexturePaletteWindow.mm
//  Sierra
//
//  Created by David Petrie on 1/05/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "TexturePaletteWindow.h"
#import "TextureImage.h"
#import "InterfaceBuilder.h"






@implementation TexturePaletteWindow

- (id) init
{
	if ((self = [super initWithWindowNibName:@"TexturePaletteWindow"]))
	{
		mImages = [[NSMutableArray alloc] init];
		
		// Get path for textures folder
		NSString *basePath = [NSString stringWithFormat:@"%@Interface/Textures/", [NSString stringWithUTF8String:FileSystem_BaseDir()]];
		NSFileManager *localFileManager = [[NSFileManager alloc] init];
		NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:basePath];
		
		NSString *file;
		
		while (file = [dirEnum nextObject]) 
		{
			
			TextureImage *image = [[TextureImage alloc] init];
			image.resourceName = file;
			image.path = [NSString stringWithFormat:@"%@%@", basePath, file];
			image.title = file;
			
			hdPrintf("Loading texture: %s\n", [image.path UTF8String]);
			[mImages addObject:image];
			//[image release];
		}
		[localFileManager release];
		
	}
	return self;
}


- (void) awakeFromNib
{
	[scrollView setDocumentView:mImageBrowser];
	[mImageBrowser reloadData];
	[mImageBrowser setDelegate:self];
		[mImageBrowser setAnimates:YES];
		
}
	

- (void) dealloc
{
    [mImages release];
    [super dealloc];
}


- (void) imageBrowserSelectionDidChange:(IKImageBrowserView *) aBrowser
{
	NSUInteger selectedIndex = [[aBrowser selectionIndexes] firstIndex];
	if (selectedIndex >= [mImages count]) return;
	
	TextureImage *img = [mImages objectAtIndex:selectedIndex];
	NSLog(@"Image browser selection changed: %@", img.path);
	
	const char *textureName = [[img.path stringByReplacingOccurrencesOfString:[NSString stringWithUTF8String:FileSystem_BaseDir()]
																   withString:@""] UTF8String];
	if (textureName)
	{
		[InterfaceBuilder sharedInstance]->SetPaletteTexture(textureName);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:kSelectedTextureImageChanged 
														object:nil];
}


- (void) updateDatasource
{
    [mImageBrowser reloadData];
}


- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
	hdPrintf("Images: %d\n", [mImages count]);
    return [mImages count];
}



- (id) imageBrowser:(IKImageBrowserView *) view itemAtIndex:(NSUInteger) index
{
    return [mImages objectAtIndex:index];
}

@end
