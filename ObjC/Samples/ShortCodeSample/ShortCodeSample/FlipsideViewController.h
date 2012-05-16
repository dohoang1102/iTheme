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
//  ShortCodeSample
//
//  Created by Chris Davis on 06/05/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iThemeFramework/ThemeFramework.h>
#import <iThemeFramework/Theme.h>
#import "JSONKit.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController<ThemeFrameworkDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *m_background;
    IBOutlet UIButton *m_downloadButton;
    IBOutlet UIButton *m_useButton;
    IBOutlet UITextField *m_txtShortCode;
    IBOutlet UILabel *m_fliptitle;   
}

@property (assign, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *background;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIButton *useButton;
@property (nonatomic, retain) IBOutlet UITextField *txtShortCode;
@property (nonatomic, retain) IBOutlet UILabel *fliptitle;

- (IBAction)done:(id)sender;
- (IBAction)onUsePress:(id)sender;
- (IBAction)onDownloadPress:(id)sender;

- (void)themeDownloadSuccess:(Theme *)theme;
- (void)themeDownloadFailed:(NSError *)error;
- (void)showError:(NSError *)error;
- (void)changeTheme;

- (UIImage *)returnUIImage:(Theme *)theme keyName:(NSString *)keyName;

- (NSDictionary *)convertJSONToDictionary:(NSString *)json;
- (NSString *)convertDictionaryToJSON:(NSDictionary *)dictionary;

@end
