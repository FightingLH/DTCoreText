//
//  DTHTMLParserNode.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 26.12.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTHTMLParserNode.h"

@implementation DTHTMLParserNode
{
	NSString *_name;
	NSDictionary *_attributes;
	__unsafe_unretained DTHTMLParserNode *_parentNode;
	NSMutableArray *_childNodes;
}


- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes
{
	self = [super init];
	
	if (self)
	{
		_name = [name copy];
		self.attributes = [attributes copy]; // property to allow overriding
	}
	
	return self;
}

- (void)addChildNode:(DTHTMLParserNode *)childNode
{
	// first child creates array
	if (!_childNodes)
	{
		_childNodes = [[NSMutableArray alloc] init];
	}
	
	childNode.parentNode = self;
	[_childNodes addObject:childNode];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ name='%@'>", NSStringFromClass([self class]), _name];
}


- (void)_appendHTMLToString:(NSMutableString *)string indentLevel:(NSUInteger)indentLevel
{
	// indent to the level
	for (int i=0; i<indentLevel; i++)
	{
		[string appendString:@"   "];
	}
	
	// write own name tag open
	[string appendFormat:@"<%@", _name];

	if (![_childNodes count])
	{
		[string appendString:@" \\>\n"];
		return;
	}
	
	// sort attribute names
	NSArray *sortedKeys = [_attributes.allKeys sortedArrayUsingSelector:@selector(compare:)];
	
	for (NSString *oneKey in sortedKeys)
	{
		NSString *attribute = [_attributes objectForKey:oneKey];
		[string appendFormat:@" %@='%@'", oneKey, attribute];
	}
	
	[string appendFormat:@">\n"];
	
	// output attributes
	for (DTHTMLParserNode *childNode in _childNodes)
	{
		[childNode _appendHTMLToString:string indentLevel:indentLevel+1];
	}

	// indent to the level
	for (int i=0; i<indentLevel; i++)
	{
		[string appendString:@"   "];
	}
	
	// write own name tag close
	[string appendFormat:@"</%@>\n", _name];
}

- (NSString *)debugDescription
{
	NSMutableString *tmpString = [NSMutableString string];
	
	[self _appendHTMLToString:tmpString indentLevel:0];
	
	return tmpString;
}

#pragma mark - Properties

@synthesize name = _name;
@synthesize attributes = _attributes;
@synthesize parentNode = _parentNode;
@synthesize childNodes = _childNodes;

@end
