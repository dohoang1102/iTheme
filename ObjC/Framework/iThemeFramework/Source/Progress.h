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
//  Progress.h
//  iThemeFramework
//
//  Created by Chris Davis on 09/06/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Progress : NSObject
{
	float m_totalItemsToDownload;
	float m_numberOfItemsDownloaded;
}
@property (nonatomic) float TotalItemsToDownload;
@property (nonatomic) float NumberOfItemsDownloaded;

// Gives the percentage of the download.
- (float)percentage;
@end