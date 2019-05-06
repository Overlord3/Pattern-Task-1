//
//  WordModel.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "WordModel.h"


@implementation WordModel

/**
 Инициализатор для модели слова
 Инициализирует массив определений
 
 @return экземпляр класса
 */
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_definitions = [NSMutableArray new];
	}
	return self;
}

@end
