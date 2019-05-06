//
//  DefinitionTableViewCell.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "DefinitionTableViewCell.h"


@implementation DefinitionTableViewCell

/**
 Инициализатор ячейки
 
 @param style стиль
 @param reuseIdentifier идентификатор
 @return экземпляр класса ячейки
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	_definitionLabel = [UILabel new];
	_authorLabel = [UILabel new];
	_exampleLabel = [UILabel new];
	_dateLabel = [UILabel new];
	return self;
}

/**
 Расстановка элементов UI в ячейке
 */
- (void)layoutSubviews
{
	//Всего высота -
	[super layoutSubviews];
	//Допустим такое расположение:
	//Определение, ниже пример, ниже автор и дата помельче
	CGFloat width = self.bounds.size.width;
	CGFloat border = 8;
	CGFloat shift = 5;
	
	CGSize maximumLabelSize = CGSizeMake(width - 2*border, 9999);
	
	//Лейбл для определения
	self.definitionLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
	self.definitionLabel.textAlignment = NSTextAlignmentLeft;
	self.definitionLabel.numberOfLines = 0;
	//вычисляем размер
	CGSize expectedLabelSize = [self.definitionLabel sizeThatFits:maximumLabelSize];
	self.definitionLabel.frame = CGRectMake(border, border, width - border*2, expectedLabelSize.height);
	[self.contentView addSubview:self.definitionLabel];
	
	//Лейбл для примера использования
	self.exampleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
	self.exampleLabel.textAlignment = NSTextAlignmentLeft;
	self.exampleLabel.numberOfLines = 0;
	//вычисляем размер
	expectedLabelSize = [self.exampleLabel sizeThatFits:maximumLabelSize];
	self.exampleLabel.frame = CGRectMake(border, shift + CGRectGetMaxY(self.definitionLabel.frame), width - border*2, expectedLabelSize.height);
	[self.contentView addSubview:self.exampleLabel];
	
	
	//Лейбл для примера использования
	self.authorLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
	self.authorLabel.textAlignment = NSTextAlignmentLeft;
	self.authorLabel.numberOfLines = 0;
	//вычисляем размер
	expectedLabelSize = [self.authorLabel sizeThatFits:maximumLabelSize];
	self.authorLabel.frame = CGRectMake(border, shift + CGRectGetMaxY(self.exampleLabel.frame), width - border*2, expectedLabelSize.height);
	[self.contentView addSubview:self.authorLabel];
	
	//Лейбл для примера использования
	self.dateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
	self.dateLabel.textAlignment = NSTextAlignmentLeft;
	self.dateLabel.numberOfLines = 0;
	//вычисляем размер
	expectedLabelSize = [self.dateLabel sizeThatFits:maximumLabelSize];
	self.dateLabel.frame = CGRectMake(border, shift + CGRectGetMaxY(self.authorLabel.frame), width - border*2, expectedLabelSize.height);
	[self.contentView addSubview:self.dateLabel];
}

/**
 Функция для вычисления высоты ячейки, на основе параметров
 
 @param definition Текст определения
 @param example Текст примера
 @param author Текст автора
 @param date Текст даты
 @return Высота ячейки
 */
+ (CGFloat)calculateHeightWithDefinition:(NSString *)definition example:(NSString *)example author:(NSString *)author date:(NSString *)date
{
	CGFloat width = UIScreen.mainScreen.bounds.size.width;
	CGFloat border = 8;
	CGFloat shift = 5;
	CGSize maximumLabelSize = CGSizeMake(width - 2*border, 9999);
	UILabel *testLabel = [UILabel new];
	
	CGFloat cellHeight = 0;
	
	//Общие настройки
	testLabel.textAlignment = NSTextAlignmentLeft;
	testLabel.numberOfLines = 0;
	
	//Лейбл для определения
	testLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
	testLabel.text = definition;
	cellHeight += border + [testLabel sizeThatFits:maximumLabelSize].height;
	
	//Лейбл для примера использования
	testLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
	testLabel.text = example;
	cellHeight += shift + [testLabel sizeThatFits:maximumLabelSize].height;
	
	//Лейбл для автора
	testLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
	testLabel.text = author;
	cellHeight += shift + [testLabel sizeThatFits:maximumLabelSize].height;
	
	//Лейбл для даты
	testLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
	testLabel.text = date;
	cellHeight += shift + [testLabel sizeThatFits:maximumLabelSize].height;
	
	cellHeight += border;
	
	return cellHeight;
}

@end
