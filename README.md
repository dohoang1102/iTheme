# iTheme

### API Version 1

### Change the theme of your App in realtime

The iTheme service lets you create themes for Apps online.
Here is a Framework that plugs into the iTheme API.

Sections
------------

1. [API](https://github.com/Gameweaver/itheme#api)
2. [Response](https://github.com/Gameweaver/itheme#response)
3. [Framework](https://github.com/GameWeaver/iTheme/tree/master/ObjC/Framework) Code usage
4. [Samples](https://github.com/GameWeaver/iTheme/tree/master/ObjC/Samples)

API
---

**Quick Overview**

* `GET http://api.itheme.com/v1/themes?s=SHORTCODE` Returns a theme
* `GET http://api.itheme.com/v1/themes/THEMEID` Returns a theme
* `GET http://api.itheme.com/v1/apps/APPID/themes` Returns a collection of themes for the APPID
* `HEAD http://api.itheme.com/v1/themes?s=SHORTCODE` Get's the headers for a theme

**Getting a theme by Short Code:**

* `curl -X GET http://api.itheme.com/v1/themes?s=SHORTCODE`

Possible response codes

* `POST 5000` Not Supported
* `GET 5103` Failed
* `GET 5104` Success
* `GET 5105` Theme not Found
* `PUT 5200` Not Supported
* `DELETE 5300` Not Supported

**Getting a theme by ThemeId:**

* `curl -X GET http://api.itheme.com/v1/themes/THEMEID` Returns a theme

Possible response codes

* `POST 4000` Not Supported
* `GET 4103` Failed
* `GET 4104` Success
* `GET 4105` Theme not Found
* `PUT 4200` Not Supported
* `DELETE 4300` Not Supported

**Getting themes for an AppId**

* `curl -X GET http://api.itheme.com/v1/apps/APPID/themes` Returns a collection of themes for the APPID

Possible response codes

* `POST 8000` Not Supported
* `GET 8103` Failed
* `GET 8104` Success
* `PUT 8200` Not Supported
* `DELETE 8300` Not Supported

**Getting the theme headers**

* `curl --head http://api.itheme.com/v1/themes?s=SHORTCODE` Returns HEADERS only of a theme, useful for 
getting the last edit date of the theme.


Response
--------

#### Data Format

iTheme currently returns data in JSON format.

#### Data Structure

All JSON responses have the following structure.

```json
"response":
	{
	"code": Integer
	"header":
		{
			"message": "action status",
			"proposal": "proposed action"
		},
	"body": JSON_BLOCK
	}
```

#### Example Theme Response

Cut down for brevity

```json
{
    "response": {
        "body": {
            "description": "DESCRIPTION",
            "app": {
                "name": "APP_TITLE",
                "appId": "APP_ID"
            },
            "private": false,
            "shortCode": "SHORTCODE",
            "name": "THEME_TITLE",
            "themeId": "THEME_ID",
            "createDate": "2012-08-05 19:51:29",
            "author": {
                "username": "CREATOR_USERNAME"
            },
            "lastEditDate": "2012-08-06 19:37:07",
            "controls": [
                {
                    "description": "Home Background",
                    "name": "home_bg.png",
                    "assetId": "ASSET_ID",
                    "requiresImmediateDownload": true,
                    "fileName": "home_bg-hd.png",
                    "assetUrl": "URL_TO_ASSET",
                    "text": "",
                    "externalUrl": "",
                },
                {
                    "description": "game bg",
                    "name": "bg",
                    "assetId": "ASSET_ID",
                    "requiresImmediateDownload": true,
                    "fileName": "bg-hd.png",
                    "assetUrl": "URL_TO_ASSET",
                    "text": "",
                    "externalUrl": "",
                },
            live": true
        },
        "header": {
            "message": "",
            "proposal": ""
        },
        "code": 5104
    }
}
```

Framework Code Usage
--------------------

#### Framework Initialisation

iTheme does not ship with a JSON Parser, but it does require one to function,
there are so many great ones out there already, you can simply plugin.

```objective-c
#import < iThemeFramework/ThemeFramework.h >
...
[[ThemeFramework instance] init:@"---your---app---key---"];
[ThemeFramework instance].Delegate = self;
[ThemeFramework instance].JSONToDictionary = @selector(convertJSONToDictionary:);
[ThemeFramework instance].DictionaryToJSON = @selector(convertDictionaryToJSON:);
...
// This example uses the JSONKit framework:
- (NSDictionary *)convertJSONToDictionary:(NSString *)json
{
    return [json mutableObjectFromJSONString];
}
- (NSString *)convertDictionaryToJSON:(NSDictionary *)dictionary
{
    return [dictionary JSONString];
}
```



#### Browsing Themes for an App

When Browsing for Themes, please implement the UIViewController< ThemeFrameworkDelegate > Protocol like so:

```objective-c
- (void)browseCallback:(NSArray *)themes cursor:(NSString *)cursor;
- (void)browseFailedCallback:(NSError *)error;
```

Then, use the following code

```objective-c
- (void)init
{
	[[ThemeFramework instance] browseThemes:self limit:10];
}

- (void)browseCallback:(NSArray *)themes cursor:(NSString *)theCursor
{
    //theCursor is a key to the next set of records,
    //themes is an array of Theme Objects
}

- (void)browseFailedCallback:(NSError *)error
{
	// Process error
	NSString *errorText = [error localizedDescription];
}

// Get next themes
- (void)getNextThemes:(NSString *)cursor
{
	[[ThemeFramework instance] browseThemes:self limit:10 cursor:cursor];
}

```

#### Downloading a Theme by Short Code

```objective-c
- (void)init
{
	[[ThemeFramework instance] downloadThemeByShortCode:@"----the----short----code----"
				target:self 
				success:@selector(success:) 
				failure:@selector(failure:) 
				progress:@selector(progress:)];
}	
- (void)success:(Theme *)theme
{
	if (theme == nil)
		return;
	[[ThemeFramework instance] setCurrentTheme:theme];
}
- (void)failure:(NSError *)err
{
	NSLog([err localizedDescription]);
}
- (void)progress:(Progress *)progress
{
	float p = progress.percentage/100;
}
```


#### Downloading a Theme by Theme Id

```objective-c

- (void)init
{
	[[ThemeFramework instance] downloadThemeByThemeId:@"----the----theme----id----"
				target:self 
				success:@selector(success:) 
				failure:@selector(failure:) 
				progress:@selector(progress:)];
}	
- (void)success:(Theme *)theme
{
	if (theme == nil)
		return;
	[[ThemeFramework instance] setCurrentTheme:theme];
}
- (void)failure:(NSError *)err
{
	NSLog([err localizedDescription]);
}
- (void)progress:(Progress *)progress
{
	float p = progress.percentage/100;
}

```

#### Using the Theme in your App

Once you have downloaded and set the Theme for your App, you can start changing
the way your app looks. Here are some examples:

```objective-c

-(void)changeTheme
{
	Theme* currentTheme = [[ThemeFramework instance] CurrentTheme];
	if (currentTheme == nil)
		return;
    
	//Set background image, by key name
	self.background.image = [self returnUIImage:currentTheme keyName:@"shortCodeBG"];

	//Cocos2d example using the fileName as the key
	CCSprite *loadingBar = [CCSprite spriteWithFile:[self iThemePathToFile:@"loadingBar.png"]];
}

// Very basic method to find the correct file,
// will pick a themed file if enabled & found
- (NSString *)iThemePathToFile:(NSString *)filePath
{
	if ([ThemeFramework instance].FrameworkEnabled)
	{
		Theme *theme = [[ThemeFramework instance] CurrentTheme];
		if (theme != nil)
		{
			NSString *themePath = [theme getPathToThemeAsset:filePath];
			if ([[NSFileManager defaultManager] fileExistsAtPath:themePath])
			{
				return themePath;
			}
		}
	}
	
	return [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
}

// Could implement some caching here.
- (UIImage *)returnUIImage:(Theme *)theme keyName:(NSString *)keyName
{
	NSString *imagePath = [theme pathToDataFileForKey:keyName];
	if (imagePath != nil)
		return [UIImage imageWithContentsOfFile:imagePath];
	return nil;
}

```