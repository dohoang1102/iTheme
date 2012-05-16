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
//  FlipsideViewController.m
//  ShortCodeSample
//
//  Created by Chris Davis on 06/05/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize background = m_background;
@synthesize downloadButton = m_downloadButton;
@synthesize useButton = m_useButton;
@synthesize txtShortCode = m_txtShortCode;
@synthesize fliptitle = m_fliptitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [ThemeFramework instance].Delegate = self;
    [ThemeFramework instance].JSONToDictionary = @selector(convertJSONToDictionary:);
    [ThemeFramework instance].DictionaryToJSON = @selector(convertDictionaryToJSON:);
    
    m_txtShortCode.returnKeyType = UIReturnKeyDone;
    m_txtShortCode.delegate = self;
    
    [self changeTheme];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)onUsePress:(id)sender
{
    NSError *err = nil;
    Theme *theme = [[ThemeFramework instance] getThemeByShortCode:self.txtShortCode.text error:&err];
    
    if (err != nil)
        [self showError:err];
    
    if (theme == nil)
        return;
    
    [[ThemeFramework instance] setCurrentTheme:theme];
    [self changeTheme];
}

- (IBAction)onDownloadPress:(id)sender
{
    [[ThemeFramework instance] downloadThemeByShortCode:self.txtShortCode.text 
                                                 target:self
                                                success:@selector(themeDownloadSuccess:) 
                                                failure:@selector(themeDownloadFailed:)];
}

- (void)themeDownloadSuccess:(Theme *)theme
{
    [[ThemeFramework instance] setCurrentTheme:theme];
    [self changeTheme];
}

- (void)themeDownloadFailed:(NSError *)error
{
    [self showError:error];
}

- (void)showError:(NSError *)error
{
    NSString *errorText = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:errorText 
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)changeTheme
{
    Theme* currentTheme = [[ThemeFramework instance] CurrentTheme];
    if (currentTheme == nil)
        return;
    
    //Set background
    self.background.image = [self returnUIImage:currentTheme keyName:@"shortCodeBG"];
    
    //Set images
    [self.downloadButton setImage:[self returnUIImage:currentTheme keyName:@"shortCodeDownloadUse"] forState:UIControlStateNormal];
    [self.useButton setImage:[self returnUIImage:currentTheme keyName:@"shortCodeUse"] forState:UIControlStateNormal];

    //Set text
	self.fliptitle.text = [currentTheme returnText:@"shortCodeText"];
}

// Could implement some caching here.
- (UIImage *)returnUIImage:(Theme *)theme keyName:(NSString *)keyName
{
	NSString *imagePath = [theme pathToDataFileForKey:keyName];
	if (imagePath != nil)
		return [UIImage imageWithContentsOfFile:imagePath];
	return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Any additional checks to ensure you have the correct textField here.
    [textField resignFirstResponder];
    return TRUE;
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

@end
