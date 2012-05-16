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
//  FlipsideViewController.h
//  BrowseSample
//
//  Created by Chris Davis on 06/05/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iThemeFramework/ThemeFramework.h>
#import <iThemeFramework/Theme.h>
#import <iThemeFramework/ThemeFrameworkDelegate.h>
#import "JSONKit.h"

#define THEMES_TO_RETURN 10

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ThemeFrameworkDelegate>
{
    IBOutlet UITableView *m_resultsView;
    NSMutableArray *m_content;
    IBOutlet UIImageView *m_background;
    IBOutlet UIButton *nextBtn;
    NSString *cursor;
}
@property (nonatomic, retain) IBOutlet UITableView *ResultsView;
@property (nonatomic,retain) NSMutableArray *Content;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) NSString *cursor;
@property (assign, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)onNextBtnPress:(id)sender;

- (void)changeTheme;
- (UIImage *)returnUIImage:(Theme *)theme keyName:(NSString *)keyName;
- (NSDictionary *)convertJSONToDictionary:(NSString *)json;
- (NSString *)convertDictionaryToJSON:(NSDictionary *)dictionary;

@end
