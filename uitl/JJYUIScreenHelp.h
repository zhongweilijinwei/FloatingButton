//
//  JJYUIScreenHelp.h
//  JjyxSdk
//
//  Created by Mac on 2017/5/23.
//  Copyright © 2017年 wanqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCALEX [JJYUIScreenHelp shareInstance].autoSizeScaleX
#define SCALEY [JJYUIScreenHelp shareInstance].autoSizeScaleY

@interface JJYUIScreenHelp : NSObject

+(instancetype)shareInstance;



@property(assign,nonatomic)CGFloat autoSizeScaleX;

@property(assign,nonatomic)CGFloat autoSizeScaleY;

@property(assign,nonatomic)NSInteger currentScreenWidth;//记录当前宽度
@end
