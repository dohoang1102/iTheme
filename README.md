# iTheme

### Change the theme of your App in realtime

The iTheme service lets you create themes for Apps online, this framework plugs into
the iTheme API to get the Theme into the App.
You can view the sample projects in the /Samples directory

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