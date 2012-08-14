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
//  ThemeFramework.h
//  iThemeFramework
//
//  Created by Chris Davis on 05/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "ThemeFrameworkDelegate.h"
#import "Constants.h"
#import "Progress.h"

@interface ThemeFramework : NSObject
{
	NSString *m_appKey;
	NSString *m_themeKey;
	BOOL m_frameworkEnabled;
	NSString *m_rootFolder;
	id<ThemeFrameworkDelegate> m_delegate;
	SEL m_jsonToDictionary;			//- (NSDictionary *)convertJSONToDictionary:(NSString *)json {}
	SEL m_dictionaryToJSON;			//- (NSString *)convertDictionaryToJSON:(NSDictionary *)dictionary {}
    
	SEL m_themeDownloadSuccess;		//- (void)success:(Theme *)theme {}
	SEL m_themeDownloadFailure;		//- (void)failure:(NSError *)error {}
	SEL m_themeDownloadProgress;	//- (void)update:(Progress *)progress {}
	SEL m_themeDownloadCancelled;	//- (void)cancelled {}
	
	BOOL m_cancelled;
    
	id m_target;
	int m_limit;
	NSString *m_cursor;
    
	Theme* m_currentTheme;
}
@property (nonatomic, retain) NSString *AppKey;
@property (nonatomic, retain) NSString *ThemeKey;
@property (nonatomic) BOOL FrameworkEnabled;
@property (nonatomic, retain) NSString *Folder;
@property (nonatomic,assign) id<ThemeFrameworkDelegate> Delegate;
@property (nonatomic) SEL JSONToDictionary;
@property (nonatomic) SEL DictionaryToJSON;
@property (nonatomic, retain) Theme* CurrentTheme;
@property (nonatomic,assign) id Target;

// Public: Themes Singleton, usefor access like this:
// [[ThemeFramework instance] methodCall];
+ (ThemeFramework *)instance;

// Public: Initalize the Themes Framework with your app's unique identifier
- (id)init:(NSString *)appKey;

// Public: Initalize the Themes Framework with your app's unique identifier
// and specify which folder within ~/Documents you wish to save the 
// themes to.
- (id)init:(NSString *)appKey folder:(NSString *)folder;

// Public: Sets the current theme
- (void)setCurrentTheme:(Theme *)theme;

// Private: Saves a file to a particular file within the root folder
- (BOOL)saveFile:(NSData *)data folder:(NSString *)folder filename:(NSString *)filename;
// Private: Any files that require immediate download, like promotional items are saved by this method
- (BOOL)downloadFilesForTheme:(NSString *)themeId themeDictionary:(NSDictionary *)themeDictionary immediatesOnly:(BOOL)immediatesOnly;
// Private: save the theme and log it to the manifest
- (BOOL)addTheme:(NSData *)jsonData themeDictionary:(NSDictionary *)themeDictionary immediatesOnly:(BOOL)immediatesOnly;
// Private: add a theme to the manifest, store a reference to the themeId and
// the shortcode so that we can do quicker lookups
- (BOOL)addThemeEntryToManifest:(NSString *)themeId shortCode:(NSString *)shortCode fullPackage:(BOOL)fullPackage lastEditDate:(NSDate *)lastEditDate;
// Private: delete a theme
- (BOOL)deleteTheme:(NSString *)themeId;
// Private: remove a theme from the manifest
- (BOOL)removeThemeEntryFromManifest:(NSString *)themeId;
// Public: Check if the theme online is newer than the one we have.
- (BOOL)themeIsUpToDate:(NSString *)shortCode onlineLastEditDate:(NSDate *)onlineLastEditDate;
// Public: Get all themes in manifest, optionally fully downloaded only.
- (NSArray *)getThemesInManifest:(BOOL)fullPackagesOnly error:(NSError **)error;
// Public: Reads a theme off of disk by shortcode.
- (Theme *)getThemeByShortCode:(NSString *)shortCode error:(NSError **)error;

// Public: Browse Themes will return all themes for the current app id.
- (void)browseThemes:(id)target;
// Public: Browse themes for appId and limit the results, default is 10
- (void)browseThemes:(id)target limit:(int)limit;
// Public: Browse themes for appId, limit the results and provide a cursor,
// the cursor is a value to get the next x records from the database
- (void)browseThemes:(id)target limit:(int)limit cursor:(NSString *)cursor;
// Public, Browse themes for a specific user
- (void)browseThemes:(id)target limit:(int)limit cursor:(NSString *)cursor userId:(NSString *)userId;
// Private: Download list of themes.
- (void)browseReceived:(NSString *)theUrl;
// Private: an error occured when getting the themes
- (void)browseFailed:(NSError *)error;

// Public: Download a theme by shortcode
- (void)downloadThemeByShortCode:(NSString *)shortCode target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)downloadThemeByShortCode:(NSString *)shortCode target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress;
- (void)downloadThemeByShortCode:(NSString *)shortCode target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress cancelled:(SEL)cancelled;
// Public: Download a theme by themeId
- (void)downloadThemeByThemeId:(NSString *)themeId target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)downloadThemeByThemeId:(NSString *)themeId target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress;
- (void)downloadThemeByThemeId:(NSString *)themeId target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress cancelled:(SEL)cancelled;
// Private: Calls themeDownload, sets callback methods
- (void)downloadThemeByUrl:(NSString *)url success:(SEL)success failure:(SEL)failure progress:(SEL)progress cancelled:(SEL)cancelled;
// Private: Downloads a theme
- (void)themeDownload:(NSString *)theUrl;
// Private: an error occured when getting the theme
- (void)themeDownloadFailed:(NSError *)error;

// Private: Synchronously downloads a resource
- (BOOL)downloadResource:(NSString *)theURL folder:(NSString *)folder savefilename:(NSString *)savefilename;

// Private: Gets the full base path to the root folder
- (NSString*)fullBasePath;

// Public: Get a theme by themeId
- (Theme *)getTheme:(NSString *)themeId error:(NSError **)error;

// Private: Returns an error object.
- (NSError *)provideError:(NSString *)message errorcode:(int)errorcode;

// Private: Returns a date as string
- (NSDate *)dateFromString:(NSString *)dateAsString;

// Public: Returns the last edit date of a theme on a remote
// server by the shortCode
- (NSDate *)lastEditDateOfRemoteThemeByShortCode:(NSString *)shortCode;

// Public: Returns the headers from a HEAD request to a URL
- (NSDictionary *)headRequest:(NSString *)theURL;

// Public: Cancels a theme download
- (void)cancelThemeDownload;

@end
