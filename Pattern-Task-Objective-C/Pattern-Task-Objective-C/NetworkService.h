//
//  NetworkService.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceProtocol.h"


@interface NetworkService : NSObject<NetworkServiceInputProtocol, NSURLSessionDelegate>


/**
 Инициализатор сервиса
 
 @return Объект NetworkService
 */
+ (instancetype)initService;

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> outputDelegate; /**< Делегат внешних событий */

@end
