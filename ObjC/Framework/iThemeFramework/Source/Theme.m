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
//  ThemeFramework
//
//  Created by Chris Davis on 07/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "Theme.h"
#import "ThemeFramework.h"

@implementation Theme
@synthesize m_themeId;
@synthesize Contents = m_contents;
@synthesize Controls = m_controls;

- (Theme *)initFromDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(self) {
		m_contents = dictionary;
		m_themeId = [dictionary objectForKey:kKEY_THEMEID];
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
			return [[ThemeFramework instance] getThemeFilePath:m_themeId fileName:fileName];
		}
		return [[ThemeFramework instance] getThemeFilePath:m_themeId fileName:keyName];
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

@end
