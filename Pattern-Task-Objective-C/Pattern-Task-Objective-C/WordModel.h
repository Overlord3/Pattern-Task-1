//
//  WordModel.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DefinitionModel.h"


NS_ASSUME_NONNULL_BEGIN


@interface WordModel : NSObject

@property (nonatomic,strong)NSString *word; /**< Основное слово */
@property (nonatomic,strong)NSMutableArray<DefinitionModel *> *definitions; /**< Массив определений для слова */

@end

NS_ASSUME_NONNULL_END
