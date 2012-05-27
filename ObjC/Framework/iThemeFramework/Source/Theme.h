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
//  Theme.h
//  ThemeFramework
//
//  Created by Chris Davis on 07/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Theme : NSObject
{
	@private
	NSString *m_themeId;
	NSDictionary *m_contents;
	NSMutableDictionary *m_controls;
	NSString *m_rootFolder;
}

@property (nonatomic, retain) NSString *ThemeId;
@property (nonatomic, retain) NSDictionary *Contents;
@property (nonatomic, retain) NSMutableDictionary *Controls;
@property (nonatomic, retain) NSString *Folder;

// Public Initalize a theme from a dictionary, including the resource root
- (Theme *)initFromDictionary:(NSDictionary *)dictionary folder:(NSString *)folder;
// Private
- (void)setupControls;
// Public Returns the full path to a file on disk
// named by it's key
- (id)pathToDataFileForKey:(NSString *)keyName;
// Public Helper, returns the 'text' dictionary value
// for a named key.
- (NSString *)returnText:(NSString *)keyName;
// Public Returns a path to an asset for the theme
- (NSString *)getPathToThemeAsset:(NSString *)fileName;
// Public get a theme key data as a dictionary;
- (NSDictionary *)getKeyInfo:(NSString *)keyName;

@end
