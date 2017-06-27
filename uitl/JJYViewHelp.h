//
//  JJYViewHelp.h
//  JjyxSdk
//
//  Created by Mac on 2017/5/25.
//  Copyright © 2017年 wanqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "JJYUIScreenHelp.h"

#define LINE @"#c5c6c7" //线条的颜色
#define BALCK50_TEXT @"#6b6b6c"
#define THEME_TEXT @"#f86900" //主题文本颜色


@interface JJYViewHelp : NSObject

+(UIImageView *)MakeLogoImageView;

+(UIButton *)MakeBackButton;
+(UIButton *)MakeColseButton;

+(UIImageView *)MakeImageView:(CGFloat) wide high:(CGFloat) high imageName:(NSString *)name;

+(UIButton *)MakeUIButton:(CGFloat)wide high:(CGFloat)high NormalImageName:(NSString *)name SelectedImageName:(NSString*) sname;

+(UIColor *)RGBStringDecode:(NSString *)rgb;
+(UIColor *)ARGBStringDecode:(NSString *)argb;
@end
