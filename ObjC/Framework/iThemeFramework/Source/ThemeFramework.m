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
//  ThemeFramework.m
//  iThemeFramework
//
//  Created by Chris Davis on 05/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

#import "ThemeFramework.h"

@implementation ThemeFramework

@synthesize AppKey = m_appKey;
@synthesize ThemeKey = m_themeKey;
@synthesize FrameworkEnabled = m_frameworkEnabled;
@synthesize Folder = m_rootFolder;
@synthesize Delegate = m_delegate;
@synthesize JSONToDictionary = m_jsonToDictionary;
@synthesize DictionaryToJSON = m_dictionaryToJSON;
@synthesize CurrentTheme = m_currentTheme;
@synthesize Target = m_target;

static ThemeFramework* _sharedMySingleton = nil;

+ (ThemeFramework *)instance
{
	@synchronized([ThemeFramework class])
	{
		if (!_sharedMySingleton)
		{
			_sharedMySingleton = [[super alloc] init];
		}
		return _sharedMySingleton;
	}
    
	return nil;
}

- (id)init
{
	self = [super init];
	if (self) {
		// Initialization code here.
	}
    
	return self;
}

- (id)init:(NSString *)appKey
{
	return [self init:appKey folder:kTHEMESFOLDER];
}

- (id)init:(NSString *)appKey folder:(NSString *)folder
{
	self = [super init];
	if (self) {
		m_appKey = appKey;
		m_rootFolder = folder;
	}
	return self;
}

- (void)setCurrentTheme:(Theme *)theme
{
	m_currentTheme = theme;
}

- (BOOL)saveFile:(NSData *)data folder:(NSString *)folder filename:(NSString *)filename
{
	if (m_cancelled)
		return FALSE;
	
	// Get root path.
	NSString *filePath = [self fullBasePath];
    
	// Append folder
	filePath = [filePath stringByAppendingPathComponent:folder];
    
	// Write folder
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:&err];
    
	// Add save file name
	filePath = [filePath stringByAppendingPathComponent:filename];
    
	// save file
	return [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

- (BOOL)downloadFilesForTheme:(NSString *)themeId themeDictionary:(NSDictionary *)themeDictionary immediatesOnly:(BOOL)immediatesOnly;
{
	if (themeDictionary == nil)
		return FALSE;
		
	NSArray* controls = [themeDictionary objectForKey:kKEY_CONTROLS];
	if (controls == nil)
		return FALSE;

	BOOL allOK = TRUE;
	int controlCount = [controls count];
	
	Progress *p = [[Progress alloc] init];
	p.TotalItemsToDownload = controlCount;
	
	int i = 0;
	while (i < controlCount && m_cancelled != TRUE)
	{
		NSDictionary *control = [controls objectAtIndex:i];
		NSNumber *requiresImmediateDownload = [control objectForKey:kKEY_REQUIRESIMMEDIATEDOWNLOAD];
		if (requiresImmediateDownload != nil)
		{
			BOOL rid = [requiresImmediateDownload boolValue];
			if (rid || immediatesOnly==FALSE)
			{
				NSString *assetUrl = [control objectForKey:kKEY_ASSETURL];
				NSString *keyName = [control objectForKey:kKEY_KEYNAME];
				NSString *fileName = [control objectForKey:kKEY_FILENAME];
                
				//If there is no specified filename, save as the key name.
				if (fileName == nil || [fileName isEqualToString:@""])
				{
					fileName = keyName;
				}
                
				if (assetUrl != nil)
				{
					if ([m_target respondsToSelector:m_themeDownloadProgress])
					{
						p.NumberOfItemsDownloaded = i;
						[m_target performSelectorOnMainThread:m_themeDownloadProgress withObject:p waitUntilDone:YES];
					}
					
					allOK = allOK & [self downloadResource:assetUrl 
                                                    folder:themeId
                                              savefilename:fileName];
				}
			}
		}
		i++;
	} 
	
	return allOK;
}

- (BOOL)addTheme:(NSData *)jsonData themeDictionary:(NSDictionary *)themeDictionary immediatesOnly:(BOOL)immediatesOnly
{
	NSString *themeId = [themeDictionary objectForKey:kKEY_THEMEID];
	NSString *shortCode = [themeDictionary objectForKey:kKEY_SHORTCODE];
	NSString *lastEditDateString = [themeDictionary objectForKey:kKEY_LASTEDITDATE];
	NSDate *lastEditDate = [self dateFromString:lastEditDateString];

	[self saveFile:jsonData folder:themeId filename:kTHEMENAME];
	[self downloadFilesForTheme:themeId themeDictionary:themeDictionary immediatesOnly:immediatesOnly];
	[self addThemeEntryToManifest:themeId shortCode:shortCode fullPackage:!immediatesOnly lastEditDate:lastEditDate];
	return TRUE;
}

- (BOOL)addThemeEntryToManifest:(NSString *)themeId shortCode:(NSString *)shortCode fullPackage:(BOOL)fullPackage lastEditDate:(NSDate *)lastEditDate
{
	if (m_cancelled)
		return FALSE;
	
	NSString *filePath = [self fullBasePath];
    
	// create folder if not exist.
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:&err];
    
	filePath = [filePath stringByAppendingPathComponent:kMANIFESTNAME];
    
	NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (dict == nil)
		dict = [[NSMutableDictionary alloc] init];
    
	NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
	[row setValue:themeId forKey:kKEY_THEMEID];
	[row setValue:shortCode forKey:kKEY_SHORTCODE];
	[row setObject:lastEditDate forKey:kKEY_LASTEDITDATE];
	[row setValue:[NSNumber numberWithBool:fullPackage] forKey:kKEY_FULL_PACKAGE];
    
	[dict setObject:row forKey:themeId];
    
	return [dict writeToFile:filePath atomically:YES];
}

- (BOOL)deleteTheme:(NSString *)themeId
{
	NSString *filePath = [self fullBasePath];
	filePath = [filePath stringByAppendingPathComponent:themeId];
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[self removeThemeEntryFromManifest:themeId];
	return [fileManager removeItemAtPath:filePath error:&err];
}

- (BOOL)removeThemeEntryFromManifest:(NSString *)themeId
{
	NSString *filePath = [self fullBasePath];
	filePath = [filePath stringByAppendingPathComponent:kMANIFESTNAME];
	NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	[dict removeObjectForKey:themeId];
	return [dict writeToFile:filePath atomically:YES];
}

- (BOOL)themeIsUpToDate:(NSString *)shortCode onlineLastEditDate:(NSDate *)onlineLastEditDate
{
	NSString *filePath = [self fullBasePath];
    
	// create folder if not exist.
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:&err];
	filePath = [filePath stringByAppendingPathComponent:kMANIFESTNAME];
    
	NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	
	if (dict == nil)
		return FALSE;
	
	for (id key in dict)
	{
		NSDictionary *row = [dict objectForKey:key];
		NSString *shortCodeInRow = [row objectForKey:kKEY_SHORTCODE];
		NSDate *lastEditDate = [row objectForKey:kKEY_LASTEDITDATE];
		if (shortCodeInRow != nil && lastEditDate != nil)
		{
			if ([shortCodeInRow isEqualToString:shortCode])
			{
				NSComparisonResult result = [lastEditDate compare:onlineLastEditDate];
				if (result == NSOrderedDescending || result == NSOrderedSame)
				{
					return TRUE;
				}
			}
		}
	}
	return FALSE;
}

- (Theme *)getThemeByShortCode:(NSString *)shortCode error:(NSError **)error
{
	NSString *filePath = [self fullBasePath];
    
	// create folder if not exist.
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:&err];
    
	filePath = [filePath stringByAppendingPathComponent:kMANIFESTNAME];
    
	NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (dict == nil)
	{
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:kKEY_MANIFEST_NOT_FOUND forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:kKEY_ERROR_DOMAIN code:ThemesManifestNotFound userInfo:errorDetail];
		return nil;
	}
    
	for (id key in dict)
	{
		NSDictionary *row = [dict objectForKey:key];
		NSString *shortCodeInRow = [row objectForKey:kKEY_SHORTCODE];
		if (shortCodeInRow != nil)
		{
			if ([shortCodeInRow isEqualToString:shortCode])
			{
				return [self getTheme:key error:error];
			}
		}
	}
    
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
	[errorDetail setValue:kKEY_THEME_BY_SHORTCODE_NOT_FOUND forKey:NSLocalizedDescriptionKey];
	*error = [NSError errorWithDomain:kKEY_ERROR_DOMAIN code:ThemeByShortCodeNotFound userInfo:errorDetail];
	return nil;
}

- (NSArray *)getThemesInManifest:(BOOL)fullPackagesOnly error:(NSError **)error
{
	NSMutableArray *themes = [[NSMutableArray alloc] init];
	NSString *filePath = [self fullBasePath];
    
	// create folder if not exist.
	NSError *err;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:filePath withIntermediateDirectories:TRUE attributes:nil error:&err];
    
	filePath = [filePath stringByAppendingPathComponent:kMANIFESTNAME];
    
	NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	if (dict == nil)
	{
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:kKEY_MANIFEST_NOT_FOUND forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:kKEY_ERROR_DOMAIN code:ThemesManifestNotFound userInfo:errorDetail];
		return nil;
	}
    
	for (id key in dict)
	{
		NSDictionary *row = [dict objectForKey:key];
		BOOL fullPackage = [[row objectForKey:kKEY_FULL_PACKAGE] boolValue];

		BOOL canAdd = TRUE; //Add Everything
		if (fullPackagesOnly == TRUE)
			canAdd = fullPackage == fullPackagesOnly;
		
		if (canAdd)
		{
			[themes addObject:[self getTheme:key error:error]];
		}

	}
	
	return themes;
}

- (void)browseThemes:(id)target
{
	[self browseThemes:target limit:10];
}

- (void)browseThemes:(id)target limit:(int)limit
{
	[self browseThemes:target limit:limit cursor:@""];
}

- (void)browseThemes:(id)target limit:(int)limit cursor:(NSString *)cursor
{
	m_limit = limit;
	m_cursor = cursor;
	m_target = target;
    
	NSString *url = kAPI_THEMES_PAGED_URL(self.AppKey, limit, cursor);
    
	[self performSelectorInBackground:@selector(browseReceived:) withObject:url];
}

- (void)browseThemes:(id)target limit:(int)limit cursor:(NSString *)cursor userId:(NSString *)userId
{
	m_limit = limit;
	m_cursor = cursor;
	m_target = target;
    
	NSString *url = kAPI_USER_THEMES_FOR_APP_PAGED_URL(userId, self.AppKey, limit, cursor);
    
	[self performSelectorInBackground:@selector(browseReceived:) withObject:url];
}

- (void)browseReceived:(NSString *)theUrl
{
	NSURL *url = [NSURL URLWithString:theUrl];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
	NSError *jsonUrlError = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&jsonUrlError];
    
	if (jsonUrlError != nil)
	{
		return [self browseFailed:jsonUrlError];
	}
    
	NSString *json = [[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding] autorelease];
    
	if ([self.Delegate respondsToSelector:self.JSONToDictionary] == FALSE)
	{
		NSError *error = [self provideError:kKEY_JSONTODICT_NOT_DEFINED errorcode:JSONToDictMethodMissing];
		return [self browseFailed:error];
	}
	
	NSDictionary *resultDic = [self.Delegate performSelector:self.JSONToDictionary withObject:json];
    
	NSDictionary *response = [resultDic objectForKey:kKEY_RESPONSE];
	if (response == nil)
	{
		NSError *error = [self provideError:kKEY_RESPONSE_MISSING errorcode:ResponseMissing];
		return [self browseFailed:error];
	}
    
	NSNumber *code = [response objectForKey:kKEY_CODE];
	if (code == nil)
	{
		NSError *error = [self provideError:kKEY_CODE_MISSING errorcode:CodeMissing];
		return [self browseFailed:error];
	}
    
	int responseCode = [code intValue];
	if (responseCode != ThemeListReadSuccess)
	{
		NSError *error = [self provideError:kKEY_CODE_INCORRECT errorcode:IncorrectCode];
		return [self browseFailed:error];
	}

	NSMutableArray *themes = [[NSMutableArray alloc] init];
	NSDictionary *body = [response objectForKey:kKEY_BODY];
    
	// Paging info
	NSDictionary *paging = [body objectForKey:kKEY_PAGING];
	m_cursor = [paging objectForKey:kKEY_PAGING_NEXT];
    
	// Results array
	NSArray *results = [body objectForKey:kKEY_RESULTS];
	int resultCount = [results count];
	
	Progress *progress = [[Progress alloc] init];
	progress.TotalItemsToDownload = resultCount;
	
	for (int i = 0; i < resultCount; i++)
	{
		NSDictionary *themeDictionary = [results objectAtIndex:i];
		
		if ([self.Delegate respondsToSelector:self.DictionaryToJSON] == FALSE)
		{
			NSError *error = [self provideError:kKEY_DICTTOJSON_NOT_DEFINED errorcode:DictToJSONMethodMissing];
			return [self browseFailed:error];
		}
		
		NSString *json = [self.Delegate performSelector:self.DictionaryToJSON withObject:themeDictionary];
		NSData* themeData=[json dataUsingEncoding:NSUTF8StringEncoding];
		
		[self addTheme:themeData themeDictionary:themeDictionary immediatesOnly:TRUE];
        
		[themes addObject:[[Theme alloc] initFromDictionary:themeDictionary folder:[self fullBasePath]]];
		
		if ([m_target respondsToSelector:@selector(browseProgressCallback:)])
		{
			progress.NumberOfItemsDownloaded = i;
			[m_target performSelectorOnMainThread:@selector(browseProgressCallback:) withObject:progress waitUntilDone:YES];
		}
	}

	if ([m_target respondsToSelector:@selector(browseCallback:cursor:)])
	{
		[m_target performSelector:@selector(browseCallback:cursor:) withObject:themes withObject:m_cursor];
	}
}

- (void)browseFailed:(NSError *)error
{
	if ([m_target respondsToSelector:@selector(browseFailedCallback:)])
	{
		[m_target performSelector:@selector(browseFailedCallback:) withObject:error];
	}
}

#pragma mark - ShortCode methods

- (void)downloadThemeByShortCode:(NSString *)shortCode target:(id)target success:(SEL)success failure:(SEL)failure
{
	[self downloadThemeByShortCode:shortCode target:target success:success failure:failure progress:nil];
}

- (void)downloadThemeByShortCode:(NSString *)shortCode target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress
{
	[self downloadThemeByShortCode:shortCode target:target success:success failure:failure progress:progress cancelled:nil];
}

- (void)downloadThemeByShortCode:(NSString *)shortCode 
						  target:(id)target 
						 success:(SEL)success 
						 failure:(SEL)failure 
						progress:(SEL)progress
						cancelled:(SEL)cancelled
{
	NSString *url = kSHORTCODE_URL(shortCode);
	m_target = target;
	[self downloadThemeByUrl:url success:success failure:failure progress:progress cancelled:cancelled];
}

#pragma mark - ThemeId methods

- (void)downloadThemeByThemeId:(NSString *)themeId target:(id)target success:(SEL)success failure:(SEL)failure
{
	[self downloadThemeByThemeId:themeId target:target success:success failure:failure progress:nil];
}

- (void)downloadThemeByThemeId:(NSString *)themeId target:(id)target success:(SEL)success failure:(SEL)failure progress:(SEL)progress
{
	[self downloadThemeByThemeId:themeId target:target success:success failure:failure progress:progress cancelled:nil];
}

- (void)downloadThemeByThemeId:(NSString *)themeId 
						target:(id)target 
					   success:(SEL)success 
					   failure:(SEL)failure 
					  progress:(SEL)progress
					 cancelled:(SEL)cancelled
{
	NSString *url = kAPI_THEME_URL(themeId);
	m_target = target;
	[self downloadThemeByUrl:url success:success failure:failure progress:progress cancelled:cancelled];
}

- (void)downloadThemeByUrl:(NSString *)url success:(SEL)success failure:(SEL)failure progress:(SEL)progress cancelled:(SEL)cancelled
{
	m_themeDownloadSuccess = success;
	m_themeDownloadFailure = failure;
	m_themeDownloadProgress = progress;
	m_themeDownloadCancelled = cancelled;
	m_cancelled = FALSE;
    
	[self performSelectorInBackground:@selector(themeDownload:) withObject:url];
}
     
- (void)themeDownload:(NSString *)theUrl
{
	if (m_cancelled)
		return;
	
	NSURL *url = [NSURL URLWithString:theUrl];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
	NSError *jsonUrlError = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&jsonUrlError]; 
    
	if (jsonUrlError != nil)
	{
		return [self browseFailed:jsonUrlError];
	}
    
	NSString *json = [[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding] autorelease];
    
	if ([self.Delegate respondsToSelector:self.JSONToDictionary] == FALSE)
	{
		NSError *error = [self provideError:kKEY_JSONTODICT_NOT_DEFINED errorcode:JSONToDictMethodMissing];
		return [self themeDownloadFailed:error];
	}
    
	NSDictionary *resultDic = [self.Delegate performSelector:self.JSONToDictionary withObject:json];
	
	NSDictionary *response = [resultDic objectForKey:kKEY_RESPONSE];
	if (response == nil)
	{
		NSError *error = [self provideError:kKEY_RESPONSE_MISSING errorcode:ResponseMissing];
		return [self themeDownloadFailed:error];
	}
	
	NSNumber *code = [response objectForKey:kKEY_CODE];
	if (code == nil)
	{
		NSError *error = [self provideError:kKEY_CODE_MISSING errorcode:CodeMissing];
		return [self themeDownloadFailed:error];
	}
	
	int responseCode = [code intValue];
	if (responseCode != ThemeReadSuccess && responseCode != ThemeShortCodeReadSuccess)
	{
		NSError *error = [self provideError:kKEY_CODE_INCORRECT errorcode:IncorrectCode];
		return [self themeDownloadFailed:error];
	}
    
	NSDictionary *themeDictionary = [response objectForKey:kKEY_BODY];
	NSString *themeJson = [self.Delegate performSelector:self.DictionaryToJSON withObject:themeDictionary];
	NSData* themeData=[themeJson dataUsingEncoding:NSUTF8StringEncoding];
    
	if (m_cancelled)
		return;
	
	[self addTheme:themeData themeDictionary:themeDictionary immediatesOnly:FALSE];
	
	if ([m_target respondsToSelector:m_themeDownloadSuccess])
	{
		[m_target performSelector:m_themeDownloadSuccess withObject:[[Theme alloc] initFromDictionary:themeDictionary folder:[self fullBasePath]]];
	}
}

- (void)themeDownloadFailed:(NSError *)error
{
	if ([m_target respondsToSelector:m_themeDownloadFailure])
	{
		[m_target performSelector:m_themeDownloadFailure withObject:error];
	}
}

- (BOOL)downloadResource:(NSString *)theURL folder:(NSString *)folder savefilename:(NSString *)savefilename
{
	NSURL *url = [NSURL URLWithString:theURL];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
	NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
	
	if (theData == nil)
		return FALSE;
	
	return [self saveFile:theData folder:folder filename:savefilename];
}

- (NSString *)fullBasePath
{
	NSArray *path = (NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES));
	NSString *filePath = [path objectAtIndex:0];
	return [filePath stringByAppendingPathComponent:m_rootFolder];
}

- (Theme *)getTheme:(NSString *)themeId error:(NSError **)error
{
	NSString *filePath = [self fullBasePath];
	filePath = [filePath stringByAppendingPathComponent:themeId];
	filePath = [filePath stringByAppendingPathComponent:kTHEMENAME];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSString *json = [[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding] autorelease];
    
	NSDictionary *dic = nil;
	Theme *theme = nil;
    
	if ([self.Delegate respondsToSelector:self.JSONToDictionary] == FALSE)
	{
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:kKEY_JSONTODICT_NOT_DEFINED forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:kKEY_ERROR_DOMAIN code:JSONToDictMethodMissing userInfo:errorDetail];
	} else {
		dic = [self.Delegate performSelector:self.JSONToDictionary withObject:json];
		theme = [[Theme alloc] initFromDictionary:dic folder:[self fullBasePath]];
	}

	return theme;
}

- (NSError *)provideError:(NSString *)message errorcode:(int)errorcode
{
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
	[errorDetail setValue:message forKey:NSLocalizedDescriptionKey];
	return [NSError errorWithDomain:kKEY_ERROR_DOMAIN code:errorcode userInfo:errorDetail];   
}

- (NSDate *)dateFromString:(NSString *)dateAsString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kDATE_FORMAT];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:kUTC]];
	NSDate *dateFromString = [[NSDate alloc] init];
	dateFromString = [dateFormatter dateFromString:dateAsString];
	return dateFromString;
}

- (NSDate *)lastEditDateOfRemoteThemeByShortCode:(NSString *)shortCode
{
	NSString *url = kSHORTCODE_URL(shortCode);
	NSDictionary *dic = [self headRequest:url];
	if (dic == nil)
		return nil;
		
	return [self dateFromString:[dic objectForKey:kLAST_MODIFIED]];
}

- (NSDictionary *)headRequest:(NSString *)theURL
{
	NSURL *url = [NSURL URLWithString:theURL];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest  requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
	[theRequest setHTTPMethod:kHTTP_HEAD];
	NSHTTPURLResponse *response = nil;
	[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
	
	if (response != nil)
	{
		return [response allHeaderFields];
	}
	
	return nil;
}

- (void)cancelThemeDownload
{
	m_themeDownloadSuccess = nil;
	m_themeDownloadFailure = nil;
	m_themeDownloadProgress = nil;
	
	if ([m_target respondsToSelector:m_themeDownloadCancelled])
	{
		[m_target performSelector:m_themeDownloadCancelled];
	}
}

@end
