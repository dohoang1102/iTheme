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
//  LocalisationSample
//
//  Created by Chris Davis on 23/05/2012.
//  Copyright (c) 2012 QuantumLogic LTD. All rights reserved.
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
    [[ThemeFramework instance] init:@"eeb73d47a44711e19aff5bf35e099b02"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainViewController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
