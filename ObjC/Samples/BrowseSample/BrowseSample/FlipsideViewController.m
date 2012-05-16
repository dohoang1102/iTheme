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
//  BrowseSample
//
//  Created by Chris Davis on 06/05/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController
@synthesize ResultsView = m_resultsView;
@synthesize Content = m_content;
@synthesize background = m_background;
@synthesize nextBtn;
@synthesize cursor;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ThemeFramework instance].Delegate = self;
    [ThemeFramework instance].JSONToDictionary = @selector(convertJSONToDictionary:);
    [ThemeFramework instance].DictionaryToJSON = @selector(convertDictionaryToJSON:);
    
    self.Content = [[NSMutableArray alloc] init];
    m_resultsView.dataSource = self;
    m_resultsView.delegate = self;
    
    [[ThemeFramework instance] browseThemes:self limit:THEMES_TO_RETURN];
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

- (IBAction)onNextBtnPress:(id)sender
{
    [[ThemeFramework instance] browseThemes:self limit:THEMES_TO_RETURN cursor:self.cursor];
}

- (void)browseCallback:(NSArray *)themes cursor:(NSString *)theCursor
{
    self.cursor = theCursor;
    [self.Content addObjectsFromArray:themes];
    [self.ResultsView reloadData];
}

- (void)browseFailedCallback:(NSError *)error
{
    NSString *errorText = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:errorText 
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.Content count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return 44;
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Theme* theme = [self.Content objectAtIndex:indexPath.row];
    if (theme == nil)
        return;
    [[ThemeFramework instance] setCurrentTheme:theme];
	[self changeTheme];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:@"MyIdentifier"] autorelease];
    }
    
    Theme* theme = [self.Content objectAtIndex:indexPath.row];
    if (theme == nil)
        return cell;
    
    UIImage *img = [self returnUIImage:theme keyName:@"browseRow"];

    cell.backgroundView = [[UIImageView alloc] initWithImage:img];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:img];

	return cell;
}

- (void)changeTheme
{
    Theme* currentTheme = [[ThemeFramework instance] CurrentTheme];
    if (currentTheme == nil)
        return;
    
    self.background.image = [self returnUIImage:currentTheme keyName:@"browseBG"];
}

// Could implement some caching here.
- (UIImage *)returnUIImage:(Theme *)theme keyName:(NSString *)keyName
{
	NSString *imagePath = [theme pathToDataFileForKey:keyName];
	if (imagePath != nil)
		return [UIImage imageWithContentsOfFile:imagePath];
	return nil;
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
