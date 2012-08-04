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
//  HomeScene.h
//  Cocos2DSampleUsingSettingsBundle
//
//  Created by Chris Davis on 03/08/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "CCLayer.h"
#import "JSONKit.h"

@interface HomeScene : CCLayer
{
	CCSprite *loadingBar;
}
+ (id)scene;
@end
