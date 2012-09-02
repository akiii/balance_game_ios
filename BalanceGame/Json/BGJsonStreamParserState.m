/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "BGJsonStreamParserState.h"
#import "BGJsonStreamParser.h"

#define SINGLETON \
+ (id)sharedInstance { \
    static id state = nil; \
    if (!state) state = [[self alloc] init]; \
    return state; \
}

@implementation BGJsonStreamParserState

+ (id)sharedInstance { return nil; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	return NO;
}

- (BGJsonStreamParserStatus)parserShouldReturn:(BGJsonStreamParser*)parser {
	return BGJsonStreamParserWaitingForData;
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {}

- (BOOL)needKey {
	return NO;
}

- (NSString*)name {
	return @"<aaiie!>";
}

- (BOOL)isError {
    return NO;
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateStart

SINGLETON

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	return token == BGJson_token_array_start || token == BGJson_token_object_start;
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {

	BGJsonStreamParserState *state = nil;
	switch (tok) {
		case BGJson_token_array_start:
			state = [BGJsonStreamParserStateArrayStart sharedInstance];
			break;

		case BGJson_token_object_start:
			state = [BGJsonStreamParserStateObjectStart sharedInstance];
			break;

		case BGJson_token_array_end:
		case BGJson_token_object_end:
			if (parser.supportMultipleDocuments)
				state = parser.state;
			else
				state = [BGJsonStreamParserStateComplete sharedInstance];
			break;

		case BGJson_token_eof:
			return;

		default:
			state = [BGJsonStreamParserStateError sharedInstance];
			break;
	}


	parser.state = state;
}

- (NSString*)name { return @"before outer-most array or object"; }

@end

#pragma mark -

@implementation BGJsonStreamParserStateComplete

SINGLETON

- (NSString*)name { return @"after outer-most array or object"; }

- (BGJsonStreamParserStatus)parserShouldReturn:(BGJsonStreamParser*)parser {
	return BGJsonStreamParserComplete;
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateError

SINGLETON

- (NSString*)name { return @"in error"; }

- (BGJsonStreamParserStatus)parserShouldReturn:(BGJsonStreamParser*)parser {
	return BGJsonStreamParserError;
}

- (BOOL)isError {
    return YES;
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateObjectStart

SINGLETON

- (NSString*)name { return @"at beginning of object"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	switch (token) {
		case BGJson_token_object_end:
		case BGJson_token_string:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateObjectGotKey

SINGLETON

- (NSString*)name { return @"after object key"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	return token == BGJson_token_keyval_separator;
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateObjectSeparator sharedInstance];
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateObjectSeparator

SINGLETON

- (NSString*)name { return @"as object value"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	switch (token) {
		case BGJson_token_object_start:
		case BGJson_token_array_start:
		case BGJson_token_true:
		case BGJson_token_false:
		case BGJson_token_null:
		case BGJson_token_number:
		case BGJson_token_string:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateObjectGotValue sharedInstance];
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateObjectGotValue

SINGLETON

- (NSString*)name { return @"after object value"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	switch (token) {
		case BGJson_token_object_end:
		case BGJson_token_separator:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateObjectNeedKey sharedInstance];
}


@end

#pragma mark -

@implementation BGJsonStreamParserStateObjectNeedKey

SINGLETON

- (NSString*)name { return @"in place of object key"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
    return BGJson_token_string == token;
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateArrayStart

SINGLETON

- (NSString*)name { return @"at array start"; }

- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	switch (token) {
		case BGJson_token_object_end:
		case BGJson_token_keyval_separator:
		case BGJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateArrayGotValue

SINGLETON

- (NSString*)name { return @"after array value"; }


- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	return token == BGJson_token_array_end || token == BGJson_token_separator;
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	if (tok == BGJson_token_separator)
		parser.state = [BGJsonStreamParserStateArrayNeedValue sharedInstance];
}

@end

#pragma mark -

@implementation BGJsonStreamParserStateArrayNeedValue

SINGLETON

- (NSString*)name { return @"as array value"; }


- (BOOL)parser:(BGJsonStreamParser*)parser shouldAcceptToken:(BGJson_token_t)token {
	switch (token) {
		case BGJson_token_array_end:
		case BGJson_token_keyval_separator:
		case BGJson_token_object_end:
		case BGJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(BGJsonStreamParser*)parser shouldTransitionTo:(BGJson_token_t)tok {
	parser.state = [BGJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

