//
//  HomeScene.h
//  Cocos2DSampleUsingSettingsBundle
//
//  Created by Chris Davis on 03/08/2012.
//  Copyright (c) 2012 QuantumLogic LTD. All rights reserved.
//

#import "CCLayer.h"
#import "JSONKit.h"

@interface HomeScene : CCLayer
{
	CCSprite *loadingBar;
}
+ (id)scene;
@end
