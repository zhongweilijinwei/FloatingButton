//
//  JYCWindow.h
//  HOUNOLVJU
//
//  Created by 李金玮
//  Copyright 李金玮. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^PayCentBlock)(void);
typedef void(^PerCentBlock)(void);
typedef void(^LogoutBlock)(void);
typedef void(^UpUserBlock)(void);

@interface JJYWindowManage : NSObject

+(instancetype)defaultManagerWithImageName:(NSString*)name;
// 显示（默认）
- (void)showWindow;
// 隐藏
- (void)dissmissWindow;

-(void)setUserType;

-(void)setOnclickListenerWithPayCent:(PayCentBlock)payBlock PerCentBlock:(PerCentBlock)perBlock LogoutBlock:(LogoutBlock)logoutBlock UpUserBlock:(UpUserBlock)upUserBlock;
@property (nonatomic,copy)PayCentBlock payBlock;
@property (nonatomic,copy)PerCentBlock perBlock;
@property (nonatomic,copy)LogoutBlock logoutBlock;
@property (nonatomic,copy)UpUserBlock upUserBlock;
@end
