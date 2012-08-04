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
//  HomeScene.m
//  Cocos2DSampleUsingSettingsBundle
//
//  Created by Chris Davis on 03/08/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "HomeScene.h"

@implementation HomeScene

+ (id) scene
{
	CCScene* s = [CCScene node];
	id node = [HomeScene node];
	[s addChild:node];
	return s;
}

- (id) init
{
	if ((self = [super init]))
	{
		
		if ([ThemeFramework instance].FrameworkEnabled)
		{
			[self initThemeFramework];
		}
			
		CCSprite *sp = [CCSprite spriteWithFile:[self iThemePathToFile:@"itemBG.png"]];
		sp.anchorPoint = ccp(0,0);
		[self addChild:sp];
	}
	return self;
}

- (void)initThemeFramework
{
	// Sample ShortCode: qeUUEpbB
	
	[ThemeFramework instance].Delegate = self;
	[ThemeFramework instance].JSONToDictionary = @selector(convertJSONToDictionary:);
	[ThemeFramework instance].DictionaryToJSON = @selector(convertDictionaryToJSON:);
	
	NSString *themeKey = [ThemeFramework instance].ThemeKey;
	
	// Get date from remote server of last edit
	NSDate *dt = [[ThemeFramework instance] lastEditDateOfRemoteThemeByShortCode:themeKey];
	// Compare this to what we have locally, if it exists at all.
	BOOL themeIsUpToDate = [[ThemeFramework instance] themeIsUpToDate:themeKey onlineLastEditDate:dt];
	
	if (themeIsUpToDate == FALSE)
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		loadingBar = [CCSprite spriteWithFile:[self iThemePathToFile:@"loadingBar.png"]];
		loadingBar.position = ccp(winSize.width/2,winSize.height/2);
		loadingBar.scaleX = 0.0;
		[self addChild:loadingBar];
		
		[[ThemeFramework instance] downloadThemeByShortCode:themeKey
													 target:self 
													success:@selector(success:) 
													failure:@selector(failure:) 
												   progress:@selector(progress:)];
	} 
	else {
		Theme *theme = [[ThemeFramework instance] getThemeByShortCode:themeKey error:nil];
		if (theme != nil)
		{
			[[ThemeFramework instance] setCurrentTheme:theme];
		}
	}

}

- (void)success:(Theme*)theme
{
	[self removeChild:loadingBar cleanup:YES];
	
	if (theme == nil)
        return;
    [[ThemeFramework instance] setCurrentTheme:theme];
}
- (void)failure:(NSError*)err
{
}
- (void)progress:(Progress*)progress
{
	loadingBar.scaleX = progress.percentage/100;
}

// This is a method with the signature:
// Input: NSString, Output: NSDictionary.
// Set this as the JSON Converter.
- (NSDictionary *)convertJSONToDictionary:(NSString *)json
{
    return [json mutableObjectFromJSONString];
}
- (NSString *)convertDictionaryToJSON:(NSDictionary *)dictionary
{
    return [dictionary JSONString];
}

// Very basic method to find the correct file,
// will pick a themed file if enabled & found
- (NSString *)iThemePathToFile:(NSString *)filePath
{
	if ([ThemeFramework instance].FrameworkEnabled)
	{
		Theme *theme = [[ThemeFramework instance] CurrentTheme];
		if (theme != nil)
		{
			NSString *themePath = [theme getPathToThemeAsset:filePath];
			if ([[NSFileManager defaultManager] fileExistsAtPath:themePath])
			{
				return themePath;
			}
		}
	}
	
	return [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
}

@end
