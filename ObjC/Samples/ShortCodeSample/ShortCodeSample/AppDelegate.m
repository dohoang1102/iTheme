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
//  AppDelegate.m
//  ShortCodeSample
//
//  Created by Chris Davis on 06/05/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ThemeFramework instance] init:@"1bbe05309f9b11e199b2c30b9b1fdb3a"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
