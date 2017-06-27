//
//  ViewController.m
//  FloatingButton
//
//  Created by Mac on 2017/6/27.
//  Copyright © 2017年 lJW. All rights reserved.
//博客：http://www.jianshu.com/u/c69840ccbd29
//

#import "ViewController.h"
#import "JJYWindowManage.h"

@interface ViewController ()

@property(nonatomic,strong)JJYWindowManage *folatManage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化不可以放到这里，因为放到这里 [UIApplication sharedApplication].keyWindow 还是nil
    
}
- (IBAction)onclickShow:(id)sender {
    self.folatManage=[JJYWindowManage defaultManagerWithImageName:@"ic_icon_jjyx.png"];
    //浮标的监听
    [self.folatManage setOnclickListenerWithPayCent:^{
        //支付中心
    } PerCentBlock:^{
        //个人中心
    } LogoutBlock:^{
        //注销
    } UpUserBlock:^{
        //账户升级
    }];

    //显示浮标
    [self.folatManage showWindow];
    
}
- (IBAction)onclickHint:(id)sender {
    //隐藏浮标
    [self.folatManage dissmissWindow];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
