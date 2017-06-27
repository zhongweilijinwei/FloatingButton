//
//  JJYViewHelp.m
//  JjyxSdk
//
//  Created by Mac on 2017/5/25.
//  Copyright © 2017年 wanqi. All rights reserved.
//

#import "JJYViewHelp.h"


@implementation JJYViewHelp

+(UIImageView *)MakeLogoImageView
{
    UIImageView *imageLogo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo_jjyx.png"]];
    
    [imageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130*SCALEY, 40*SCALEY));
    }];
    
    return imageLogo;
}






//创建 imageview
+(UIImageView *)MakeImageView:(CGFloat)wide high:(CGFloat)high imageName:(NSString *)name
{
    UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",name]]];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(wide*SCALEX, high*SCALEY));
    }];
    
    return imageview;
    
}

//创建 button
+(UIButton *)MakeUIButton:(CGFloat)wide high:(CGFloat)high NormalImageName:(NSString *)name SelectedImageName:(NSString*) sname
{
    UIButton *Bt=[[UIButton alloc] init];
    [Bt setImage:[UIImage imageNamed:
                  [NSString stringWithFormat:@"%@",name]] forState:UIControlStateNormal];
    [Bt setImage:[UIImage imageNamed:
                  [NSString stringWithFormat:@"%@",sname]] forState:UIControlStateSelected];
    
    [Bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(wide*SCALEX, high*SCALEY));
    }];
    
    return Bt;

}



+(UIColor *)RGBStringDecode:(NSString *)rgb
{
    // 十六进制数字字符串转十进制数字
    
    NSString *s1 = [rgb substringWithRange:NSMakeRange(1, 2)];
    unsigned long c1 = strtoul([s1 UTF8String], 0, 16);
    
    NSString *s2 = [rgb substringWithRange:NSMakeRange(3, 2)];
    unsigned long c2 = strtoul([s2 UTF8String], 0, 16);
    
    NSString *s3 = [rgb substringWithRange:NSMakeRange(5, 2)];
    unsigned long c3 = strtoul([s3 UTF8String], 0, 16);
    
    // Red，green，blue 值的范围是 0 ～ 1，alpha：透明度，1 不透明
    UIColor *color5 = [UIColor colorWithRed:c1/255.0 green:c2/255.0 blue:c3/255.0 alpha:1];
    
    return color5;
}

+(UIColor *)ARGBStringDecode:(NSString *)argb
{
    // 十六进制数字字符串转十进制数字
    NSString *s0 = [argb substringWithRange:NSMakeRange(1, 2)];
    unsigned long c0 = strtoul([s0 UTF8String], 0, 16);
    
    NSString *s1 = [argb substringWithRange:NSMakeRange(3, 2)];
    unsigned long c1 = strtoul([s1 UTF8String], 0, 16);
    
    NSString *s2 = [argb substringWithRange:NSMakeRange(5, 2)];
    unsigned long c2 = strtoul([s2 UTF8String], 0, 16);
    
    NSString *s3 = [argb substringWithRange:NSMakeRange(7, 2)];
    unsigned long c3 = strtoul([s3 UTF8String], 0, 16);
    
    // Red，green，blue 值的范围是 0 ～ 1，alpha：透明度，1 不透明
    UIColor *color5 = [UIColor colorWithRed:c1/255.0 green:c2/255.0 blue:c3/255.0 alpha:c0/255.0];
    
    return color5;
}


@end
