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
//  AsynchronousDownload.m
//  ThemeFramework
//
//  Created by Chris Davis on 26/01/2012.
//  Copyright 2012 GameWeaver LTD. All rights reserved.
//

#import "AsynchronousDownload.h"

@implementation AsynchronousDownload

-(void)start:(NSString*)theURL target:(id)target success:(SEL)success failure:(SEL)failure
{
    m_target = target;
    m_callback = success;
    m_fail = failure;
    NSURL *url = [NSURL URLWithString:theURL];

	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [responseData release];
    [connection release];
    if ([m_target respondsToSelector:m_fail])
    {
        [m_target performSelector:m_fail];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [m_target performSelector:m_callback withObject:responseData];
}

@end
