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
//  MainViewController.m
//  LocalisationSample
//
//  Created by Chris Davis on 23/05/2012.
//  Copyright (c) 2012 QuantumLogic LTD. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize txtTitle = m_txtTitle;
@synthesize txtDescription = m_txtDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    [self changeTheme];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;;
    [self presentModalViewController:controller animated:YES];
}

- (void)changeTheme
{
    Theme* currentTheme = [[ThemeFramework instance] CurrentTheme];
    if (currentTheme == nil)
        return;
    
    self.txtTitle.text = [currentTheme returnText:@"title"];
    self.txtDescription.text = [currentTheme returnText:@"description"];
}

@end
