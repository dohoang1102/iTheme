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
//  AsynchronousDownload.h
//  ThemeFramework
//
//  Created by Chris Davis on 26/01/2012.
//  Copyright 2012 GameWeaver LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynchronousDownload : NSObject
{
    @private
    NSMutableData *responseData;  
    id m_target;
    SEL m_callback;
    SEL m_fail;
}

-(void)start:(NSString*)theURL target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
