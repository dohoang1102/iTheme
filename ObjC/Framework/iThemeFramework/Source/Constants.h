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
//  Constants.h
//  iThemeFramework
//
//  Created by Chris Davis on 05/04/2012.
//  Copyright (c) 2012 GameWeaver LTD. All rights reserved.
//

extern NSString * const kMANIFESTNAME;
extern NSString * const kTHEMENAME;
extern NSString * const kTHEMESFOLDER;
extern NSString * const kKEY_CONTROLS;
extern NSString * const kKEY_THEMEID;
extern NSString * const kKEY_RESPONSE;
extern NSString * const kKEY_CODE;
extern NSString * const kKEY_BODY;
extern NSString * const kKEY_RESULTS;
extern NSString * const kKEY_PAGING;
extern NSString * const kKEY_PAGING_NEXT;
extern NSString * const kKEY_KEYNAME;
extern NSString * const kKEY_LASTEDITDATE;
extern NSString * const kKEY_REQUIRESIMMEDIATEDOWNLOAD;
extern NSString * const kKEY_ERROR_DOMAIN;
extern NSString * const kKEY_RESPONSE_MISSING;
extern NSString * const kKEY_CODE_MISSING;
extern NSString * const kKEY_BODY_MISSING;
extern NSString * const kKEY_CODE_INCORRECT;
extern NSString * const kKEY_JSONTODICT_NOT_DEFINED;
extern NSString * const kKEY_DICTTOJSON_NOT_DEFINED;
extern NSString * const kKEY_ASSETURL;
extern NSString * const kKEY_APPREQUIREMENTID;
extern NSString * const kKEY_SHORTCODE;
extern NSString * const kKEY_HEADER;
extern NSString * const kKEY_HEADER_MESSAGE;
extern NSString * const kKEY_HEADER_PROPOSAL;
extern NSString * const kKEY_MANIFEST_NOT_FOUND;
extern NSString * const kKEY_THEME_BY_SHORTCODE_NOT_FOUND;
extern NSString * const kKEY_FILENAME;
extern NSString * const kKEY_TEXT;
extern NSString * const kDATE_FORMAT;
extern NSString * const kHTTP_HEAD;
extern NSString * const kLAST_MODIFIED;
extern NSString * const kUTC;

#define TIMEOUT 30
#define kAPI_THEME_URL(__themeId__) [NSString stringWithFormat:@"http://api.itheme.com/v1/themes/%@", __themeId__];
#define kAPI_THEMES_PAGED_URL(__appId__,__limit__,__cursor__) [NSString stringWithFormat:@"http://api.itheme.com/v1/apps/%@/themes?limit=%d&cursor=%@", __appId__,__limit__,__cursor__];
#define kAPI_USER_THEMES_FOR_APP_PAGED_URL(__userId__,__appId__,__limit__,__cursor__) [NSString stringWithFormat:@"http://api.itheme.com/v1/users/%@/apps/%@/themes?limit=%d&cursor=%@", __userId__,__appId__,__limit__,__cursor__];
#define kSHORTCODE_URL(__shortCode__) [NSString stringWithFormat:@"http://api.itheme.com/v1/themes?s=%@", __shortCode__];

// Response codes for different requests
typedef enum {
    ThemeReadFailed = 4103,
    ThemeReadSuccess = 4104,
    ThemeReadNotFound = 4105,
    
    ThemeListReadFailed = 8103,
    ThemeListReadSuccess = 8104,
    
    ThemeShortCodeReadFailed = 5103,
    ThemeShortCodeReadSuccess = 5104,
    ThemeShortCodeNotFound = 5105
} ReturnCode;

// Codes not tied to a response
// used for general logic
typedef enum {
    ResponseMissing,
    CodeMissing,
    BodyMissing,
    IncorrectCode,
    JSONToDictMethodMissing,
    DictToJSONMethodMissing,
    ThemeByShortCodeNotFound,
    ThemesManifestNotFound
} ParseCode;
