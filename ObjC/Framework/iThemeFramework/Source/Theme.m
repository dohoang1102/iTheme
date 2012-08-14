//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License. You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
//  License for the specific language governing permissions and limitations under
//  the License.
//
//  Theme.m
//  iThemeFramework
//
//  Created by Chris Davis on 07/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "Theme.h"
#import "ThemeFramework.h"

@implementation Theme
@synthesize ThemeId = m_themeId;
@synthesize Contents = m_contents;
@synthesize Controls = m_controls;
@synthesize Folder = m_rootFolder;

- (Theme *)initFromDictionary:(NSDictionary *)dictionary folder:(NSString *)folder
{
	self = [super init];
	if(self) {
		m_contents = [dictionary retain];
		m_themeId = [[dictionary objectForKey:kKEY_THEMEID] retain];
		m_rootFolder = [folder retain];
		[self setupControls];
	}
	return self;
}

- (void)setupControls
{
	m_controls = [[NSMutableDictionary alloc] init];
	NSArray *controls = [m_contents objectForKey:kKEY_CONTROLS];
	int controlCount = [controls count];
	for (int i = 0; i < controlCount; i++)
	{
		NSMutableDictionary *control = [controls objectAtIndex:i];
		NSObject *keyName = [control objectForKey:kKEY_KEYNAME];
		if (keyName != nil)
		{
			[m_controls setObject:control forKey:keyName];
		}
	}
}

//Does the theme have a filename for this key?
//If so, use this, otherwise use the keyname.
- (id)pathToDataFileForKey:(NSString *)keyName
{
	NSDictionary *keyDict = [m_controls objectForKey:keyName];
	if (keyDict != nil)
	{
		NSString *fileName = [keyDict objectForKey:kKEY_FILENAME];
		if (fileName != nil && [fileName isEqualToString:@""] == FALSE)
		{
			return [self getPathToThemeAsset:fileName];
		}
		return [self getPathToThemeAsset:keyName];
	}
	return nil;
}

- (NSString *)returnText:(NSString*)keyName
{
	NSDictionary *keyDict = [m_controls objectForKey:keyName];
	if (keyDict != nil)
	{
		NSString *text = [keyDict objectForKey:kKEY_TEXT];
		if (text != nil)
		{
			return text;
		}
	}
	return nil;
}

- (NSString *)getPathToThemeAsset:(NSString *)fileName
{
	NSString *filePath = m_rootFolder;
	filePath = [filePath stringByAppendingPathComponent:m_themeId];
	return [filePath stringByAppendingPathComponent:fileName];
}

- (NSDictionary *)getKeyInfo:(NSString *)keyName
{
	return [m_controls objectForKey:keyName];
}

- (NSString *)shortCode
{
	NSString *sc = [m_contents objectForKey:kKEY_SHORTCODE];
	if (sc != nil)
	{
		return sc;
	}
	return nil;
}

@end
