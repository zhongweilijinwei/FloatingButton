//
//  JYCWindow.m
//  HOUNOLVJU
//
//  Created by 李金玮 on
//  Copyright  李金玮. All rights reserved.
//

#import "JJYWindowManage.h"
#import "JJYViewHelp.h"

#define kk_WIDTH self.frame.size.width
#define kk_HEIGHT self.frame.size.height

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3       //位置改变动画时间
#define showDuration 0.1          //展开动画时间
#define statusChangeDuration  3.0    //状态改变时间
#define normalAlpha  1.0           //正常状态时背景alpha值
#define sleepAlpha  0.5           //隐藏到边缘时的背景alpha值
#define marginWith  12             //每个item的间隔
#define marginBorderLeft  60             //左边的距离
#define folatViewHeght  55             //浮标的高度
#define folatViewWidth  280             //浮标的宽度
#define padding 5                       //item 距离顶部的距离

#define WZFlashInnerCircleInitialRaius  20

@interface JJYWindowManage ()

@property(nonatomic,strong)UIPanGestureRecognizer *pan;

@property(nonatomic,strong)UIButton *mainImageButton;
@property(nonatomic,strong)UIView *LeftView;//左边的view
@property(nonatomic,strong)UIView *rightView1;//右边的view
@property(nonatomic,assign)BOOL isOpen;//记录是打开还是关闭


//两个个人中心 文本
@property(nonatomic,weak)UILabel *lbUserType1;
@property(nonatomic,weak)UILabel *lbUserType2;

//几个监听点击的view
@property(nonatomic,weak)UIView *logout1;
@property(nonatomic,weak)UIView *logout2;
@property(nonatomic,weak)UIView *percner1;
@property(nonatomic,weak)UIView *percner2;
@property(nonatomic,weak)UIView *payCenr1;
@property(nonatomic,weak)UIView *payCenr2;


@property(nonatomic,strong)UITapGestureRecognizer *logoutTap;
@property(nonatomic,strong)UITapGestureRecognizer *personTap;
@property(nonatomic,strong)UITapGestureRecognizer *paycentTap;

@property(nonatomic,strong)UITapGestureRecognizer *logoutTap1;
@property(nonatomic,strong)UITapGestureRecognizer *personTap1;
@property(nonatomic,strong)UITapGestureRecognizer *paycentTap1;
@end


@implementation JJYWindowManage


-(void)setOnclickListenerWithPayCent:(PayCentBlock)payBlock PerCentBlock:(PerCentBlock)perBlock LogoutBlock:(LogoutBlock)logoutBlock UpUserBlock:(UpUserBlock)upUserBlock
{
    self.payBlock = payBlock;
    self.perBlock = perBlock;
    self.logoutBlock = logoutBlock;
    self.upUserBlock = upUserBlock;
    
}


- (instancetype)initWithImageName:(NSString*)name
{
    
    if(self = [super init])
    {
        
        [self initView];
        
        self.mainImageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mainImageButton setFrame:(CGRect){0, kScreenHeight/2,folatViewHeght*SCALEY, folatViewHeght*SCALEY}];
        [self.mainImageButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        self.mainImageButton.alpha = 0.0;
        [_mainImageButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //添加上屏幕并添加约束
        UIWindow *lastWindow=[UIApplication sharedApplication].keyWindow;
        [lastWindow addSubview:self.LeftView];
        [lastWindow addSubview:self.rightView1];
        [lastWindow addSubview:self.mainImageButton];
        
        
        [self.LeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainImageButton.mas_left);
            make.top.mas_equalTo(self.mainImageButton.mas_top);
        }];
        [self.rightView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mainImageButton.mas_right);
            make.top.mas_equalTo(self.mainImageButton.mas_top);
        }];
        
        //设置监听
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        _pan.delaysTouchesBegan = NO;
        [_mainImageButton addGestureRecognizer:_pan];
        
        
        self.logoutTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutOnclick:)];
        self.personTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personOnclick:)];
        self.paycentTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paycentOnclick:)];
        
        self.logoutTap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutOnclick:)];
        self.personTap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personOnclick:)];
        self.paycentTap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paycentOnclick:)];
        
        [self.logout1 addGestureRecognizer:self.logoutTap];
        [self.logout2 addGestureRecognizer:self.logoutTap1];
        [self.percner1 addGestureRecognizer:self.personTap];
        [self.percner2 addGestureRecognizer:self.personTap1];
        [self.payCenr1 addGestureRecognizer:self.paycentTap];
        [self.payCenr2 addGestureRecognizer:self.paycentTap1];
    }
    return self;
}


//初始化左右的view
-(void)initView
{
    
    
    
    //#############右边的view
    self.rightView1=[[UIView alloc] init];
    self.rightView1.backgroundColor=[UIColor whiteColor];
    //设置圆角
    self.rightView1.layer.cornerRadius = (folatViewHeght/2*SCALEY);//最重要的是这个地方要设成imgview高的一半
    self.rightView1.layer.masksToBounds = YES;
    self.rightView1.layer.borderWidth=1;
    self.rightView1.layer.borderColor=[[JJYViewHelp RGBStringDecode:LINE] CGColor];
    [self.rightView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewWidth*SCALEX, folatViewHeght*SCALEY));
    }];
    
    [self.rightView1 setAlpha:0];
    
    //注销的view
    UIView *logoutView1=[[UIView alloc]init];
    self.logout1=logoutView1;
    
    [self.rightView1 addSubview:logoutView1];
    [logoutView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.right.mas_equalTo(self.rightView1.mas_right).offset(-marginBorderLeft*SCALEX);
        make.top.mas_equalTo(self.rightView1.mas_top);
    }];
    
    UIImageView *righticon1=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_zhuxiao_jjyx.png"];
    [logoutView1 addSubview:righticon1];
    [righticon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(logoutView1.mas_centerX);
        make.top.mas_equalTo(logoutView1.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *rightlb1=[[UILabel alloc] init];
    rightlb1.font=[UIFont systemFontOfSize:12.0*SCALEY];
    rightlb1.text=@"注销";
    [logoutView1 addSubview:rightlb1];
    [rightlb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(logoutView1.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(logoutView1.mas_centerX);
    }];
    
    
    
    //竖线
    UIView *rightline=[[UIView alloc] init];
    rightline.backgroundColor=[JJYViewHelp RGBStringDecode:LINE];
    [self.rightView1 addSubview:rightline];
    [rightline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.rightView1.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.rightView1.mas_bottom).offset(-(10*SCALEY));
        make.right.mas_equalTo(logoutView1.mas_left).offset(-marginWith/2 *SCALEX);
    }];
    
    
    
    //账户的view
    UIView *userView1=[[UIView alloc]init];
    self.percner1=userView1;
    
    [self.rightView1 addSubview:userView1];
    [userView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.right.mas_equalTo(rightline.mas_left).offset(-marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.rightView1.mas_top);
        
    }];
    UIImageView *righticon2=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_zhanghuaq_jjyx.png"];
    [userView1 addSubview:righticon2];
    [righticon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userView1.mas_centerX);
        make.top.mas_equalTo(userView1.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *rightlb2=[[UILabel alloc] init];
    self.lbUserType1=rightlb2;
    rightlb2.font=[UIFont systemFontOfSize:12.0*SCALEY];
    rightlb2.text=@"个人中心";
    [userView1 addSubview:rightlb2];
    [rightlb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userView1.mas_centerX);
        make.bottom.mas_equalTo(userView1.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
    }];
    
    
    
    //竖线
    UIView *rightline2=[[UIView alloc] init];
    rightline2.backgroundColor=[JJYViewHelp RGBStringDecode:LINE];
    [self.rightView1 addSubview:rightline2];
    [rightline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.rightView1.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.rightView1.mas_bottom).offset(-(10*SCALEY));
        make.right.mas_equalTo(userView1.mas_left).offset(-marginWith/2 *SCALEX);
    }];
    
    
    //充值中心的view
    UIView *payView1=[[UIView alloc]init];
    self.payCenr1=payView1;
    [self.rightView1 addSubview:payView1];
    [payView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.right.mas_equalTo(rightline2.mas_left).offset(-marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.rightView1.mas_top);
    }];
    UIImageView *rigthicon3=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_chongzhi_jjyx.png"];
    [payView1 addSubview:rigthicon3];
    [rigthicon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(payView1.mas_centerX);
        make.top.mas_equalTo(payView1.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *rightlb3=[[UILabel alloc] init];
    rightlb3.font=[UIFont systemFontOfSize:12.0*SCALEY];
    rightlb3.text=@"充值中心";
    [payView1 addSubview:rightlb3];
    [rightlb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(payView1.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(payView1.mas_centerX);
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //#############左边的view
    self.LeftView=[[UIView alloc] init];
    self.LeftView.backgroundColor=[UIColor whiteColor];
    //设置圆角
    self.LeftView.layer.cornerRadius = (folatViewHeght/2*SCALEY);//最重要的是这个地方要设成imgview高的一半
    self.LeftView.layer.masksToBounds = YES;
    self.LeftView.layer.borderWidth=1;
    self.LeftView.layer.borderColor=[[JJYViewHelp RGBStringDecode:LINE] CGColor];
    [self.LeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewWidth*SCALEX, folatViewHeght*SCALEY));
    }];
    
    [self.LeftView setAlpha:0];
    
    //注销的view
    UIView *logoutView=[[UIView alloc]init];
    self.logout2=logoutView;
    [self.LeftView addSubview:logoutView];
    [logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.left.mas_equalTo(self.LeftView.mas_left).offset(marginBorderLeft*SCALEX);
        make.top.mas_equalTo(self.LeftView.mas_top);
    }];
    UIImageView *icon1=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_zhuxiao_jjyx.png"];
    [logoutView addSubview:icon1];
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(logoutView.mas_centerX);
        make.top.mas_equalTo(logoutView.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *lb1=[[UILabel alloc] init];
    lb1.font=[UIFont systemFontOfSize:12.0*SCALEY];
    lb1.text=@"注销";
    [logoutView addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(logoutView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(logoutView.mas_centerX);
    }];
    
    
    
    //竖线
    UIView *line=[[UIView alloc] init];
    line.backgroundColor=[JJYViewHelp RGBStringDecode:LINE];
    [self.LeftView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.LeftView.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.LeftView.mas_bottom).offset(-(10*SCALEY));
        make.left.mas_equalTo(logoutView.mas_right).offset(marginWith/2 *SCALEX);
    }];
    
    
    
    //账户的view
    UIView *userView=[[UIView alloc]init];
    self.percner2=userView;
    [self.LeftView addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.left.mas_equalTo(line.mas_right).offset(marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.LeftView.mas_top);
        
    }];
    UIImageView *icon2=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_zhanghuaq_jjyx.png"];
    [userView addSubview:icon2];
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userView.mas_centerX);
        make.top.mas_equalTo(userView.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *lb2=[[UILabel alloc] init];
    self.lbUserType2=lb2;
    lb2.font=[UIFont systemFontOfSize:12.0*SCALEY];
    lb2.text=@"个人中心";
    [userView addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(userView.mas_centerX);
        make.bottom.mas_equalTo(userView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
    }];
    
    
    
    //竖线
    UIView *line2=[[UIView alloc] init];
    line2.backgroundColor=[JJYViewHelp RGBStringDecode:LINE];
    [self.LeftView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1*SCALEX);
        make.top.mas_equalTo(self.LeftView.mas_top).offset(10*SCALEY);
        make.bottom.mas_equalTo(self.LeftView.mas_bottom).offset(-(10*SCALEY));
        make.left.mas_equalTo(userView.mas_right).offset(marginWith/2 *SCALEX);
    }];
    
    
    //充值中心的view
    UIView *payView=[[UIView alloc]init];
    self.payCenr2=payView;
    [self.LeftView addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(folatViewHeght*SCALEX, folatViewHeght*SCALEY));
        make.left.mas_equalTo(line2.mas_right).offset(marginWith/2 *SCALEX);
        make.top.mas_equalTo(self.LeftView.mas_top);
    }];
    UIImageView *icon3=[JJYViewHelp MakeImageView:folatViewHeght/2*SCALEY high:folatViewHeght/2*SCALEY imageName:@"ic_chongzhi_jjyx.png"];
    [payView addSubview:icon3];
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(payView.mas_centerX);
        make.top.mas_equalTo(payView.mas_top).offset(padding*SCALEY);
    }];
    
    UILabel *lb3=[[UILabel alloc] init];
    lb3.font=[UIFont systemFontOfSize:12.0*SCALEY];
    lb3.text=@"充值中心";
    [payView addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(payView.mas_bottom).offset(-padding*SCALEY);
        make.height.mas_equalTo(16*SCALEY);
        make.centerX.mas_equalTo(payView.mas_centerX);
    }];
    
    
    
    
    
    
    
    
}



- (void)dissmissWindow{
    self.isOpen=NO;
    [self.mainImageButton setAlpha:0.0];
    [self.LeftView setAlpha:0.0];
    [self.rightView1 setAlpha:0.0];
}


- (void)showWindow{
    
    [self.mainImageButton setAlpha:1.0];
    [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
}




- (void)changBoundsabovePanPoint:(CGPoint)panPoint{
    
    //设置y方向不可隐藏
    if (panPoint.y<(folatViewHeght*SCALEY)/2 || panPoint.y>kScreenHeight-(folatViewHeght*SCALEY)/2) {
        if(panPoint.y<(folatViewHeght*SCALEY)/2){
            panPoint.y=(folatViewHeght*SCALEY)/2;
        }else{
            panPoint.y=kScreenHeight-(folatViewHeght*SCALEY)/2;
            
        }
    }
    
    
    if(panPoint.x <= kScreenWidth/2)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake((folatViewHeght*SCALEY)/2, panPoint.y);
        }];
    }
    
    else
    {
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(kScreenWidth-(folatViewHeght*SCALEY)/2, panPoint.y);
        }];
    }
    
}
//改变位置
- (void)locationChange:(UIPanGestureRecognizer*)p
{
    if(self.isOpen) return;
    
    CGPoint panPoint = [p locationInView:[UIApplication sharedApplication].keyWindow];
    
    
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        _mainImageButton.alpha = normalAlpha;
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.mainImageButton.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        [self changBoundsabovePanPoint:panPoint];
        
    }
}

//点击事件
- (void)click:(id)sender
{
    
    UIView *animeView;
    
    if(self.mainImageButton.center.x <= kScreenWidth/2)//判断是哪一边
    {
        //左
        animeView=self.LeftView;
        //恢复位置
        self.mainImageButton.center = CGPointMake((folatViewHeght*SCALEY)/2, self.mainImageButton.center.y);
        
    }else{
        //右
        animeView=self.rightView1;
        //恢复位置
        self.mainImageButton.center = CGPointMake(kScreenWidth-(folatViewHeght*SCALEY)/2, self.mainImageButton.center.y);
        
    }
    
    
    self.mainImageButton.alpha = normalAlpha;
    //判断是打开还是关闭
    if (self.isOpen) {
        self.isOpen=NO;
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        [UIView animateWithDuration:0.1 animations:^{
            [animeView setAlpha:1];
            [animeView setAlpha:0];
            [animeView setTransform:CGAffineTransformMakeScale(0.8, 1)];
        }];
        
    }else{
        //显示关键字
        [self setUserType];
        //关闭倒计时
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        self.isOpen=YES;
        [UIView animateWithDuration:0.1  animations:^{
            [animeView setAlpha:0];
            [animeView setAlpha:1];
            
            [animeView setTransform:CGAffineTransformMakeScale(1, 1)];
        }];
        
    }
    
}



- (void)changeStatus
{
    
    if (self.isOpen|| self.mainImageButton.alpha<=0.1) {
        return;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        _mainImageButton.alpha = sleepAlpha;
    }];
    
    if(self.mainImageButton.center.x <= kScreenWidth/2)//判断是哪一边
    {
        //左
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(0, self.mainImageButton.center.y);
        }];
        
    }else{
        //右
        [UIView animateWithDuration:animateDuration animations:^{
            self.mainImageButton.center = CGPointMake(kScreenWidth, self.mainImageButton.center.y);
        }];
        
    }
    
}




-(void)setUserType
{
    self.lbUserType1.text=@"个人中心";
    self.lbUserType2.text=@"个人中心";
    
    
    
}




//点击的监听
-(void)logoutOnclick:(UITapGestureRecognizer *)re
{
    self.logoutBlock();
    
}


-(void)personOnclick:(UITapGestureRecognizer *)re
{
    
    self.perBlock();
    
}

-(void)paycentOnclick:(UITapGestureRecognizer *)re
{
    self.payBlock();
    
}

















//一下为单例代码

static JJYWindowManage *_instace;

+(instancetype)defaultManagerWithImageName:(NSString *)name
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instace ==nil) {
            _instace=[[JJYWindowManage alloc]initWithImageName:name];
        }
    });
    
    return _instace;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instace==nil) {
        _instace=[super allocWithZone:zone];
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



