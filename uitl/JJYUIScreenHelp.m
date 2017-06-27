//
//  JJYUIScreenHelp.m
//  JjyxSdk
//
//  Created by Mac on 2017/5/23.
//  Copyright © 2017年 wanqi. All rights reserved.
//

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width


#import "JJYUIScreenHelp.h"



@implementation JJYUIScreenHelp





-(void)initAutoSize
{
    
    //当屏幕方向变化的时候 ，需要重新计算
    if (self.currentScreenWidth!=SCREENWIDTH) {
        
        self.currentScreenWidth=SCREENWIDTH;
        
        //因为屏幕方向问题， 高度不一定一最大的
        NSInteger max=SCREENWIDTH>SCREENHEIGHT?SCREENWIDTH:SCREENHEIGHT;
        
        
        if(max!=667)
        {
            /**
             *以iPhone6/6s为基准,若是5/5s
             则myDelegate.autoSizeScaleX=SCREENWIDTH/375;
             即为myDelegate.autoSizeScaleX=320/375;
             */
            if (max==480) {
                //对4进行特例处理
                self.autoSizeScaleX=0.85;
                self.autoSizeScaleY=0.85;
            }else{
                self.autoSizeScaleX=(SCREENWIDTH<SCREENHEIGHT?SCREENWIDTH:SCREENHEIGHT)/375;
                self.autoSizeScaleY=(SCREENWIDTH>SCREENHEIGHT?SCREENWIDTH:SCREENHEIGHT)/667;
            }
        }else {
            
            /**
             *否则即为iPhone6
             */
            self.autoSizeScaleX=1.0;
            self.autoSizeScaleY=1.0;
            
        }
        
    }
    
}




//一下为单例代码

static JJYUIScreenHelp *_instace;

+(instancetype)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instace ==nil) {
            _instace=[[JJYUIScreenHelp alloc]init];
            
        }
    });
    
    return _instace;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instace==nil) {
        _instace=[super allocWithZone:zone];
        [_instace initAutoSize];
    }
    return _instace;
    
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return _instace;
}

-(id)copy
{
    return _instace;
}

-(id)mutableCopy
{
    return _instace;
}


@end
