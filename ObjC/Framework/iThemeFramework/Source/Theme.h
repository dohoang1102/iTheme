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
}

@property (nonatomic, retain) NSString *m_themeId;
@property (nonatomic, retain) NSDictionary *Contents;
@property (nonatomic, retain) NSMutableDictionary *Controls;

// Public Initalize a theme from a dictionary,
- (Theme *)initFromDictionary:(NSDictionary *)dictionary;
// Private
- (void)setupControls;
// Public Returns the full path to a file on disk
// named by it's key
- (id)pathToDataFileForKey:(NSString *)keyName;
// Public Helper, returns the 'text' dictionary value
// for a named key.
- (NSString *)returnText:(NSString *)keyName;

@end
