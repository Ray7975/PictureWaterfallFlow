//
//  PictureViewController.h
//  PictureWaterfallFlow
//
//  Created by Admin on 15/11/2.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewController : UIViewController

//列数量
@property (nonatomic, assign) NSInteger columnCount;
//cell子对象间距
@property (nonatomic, assign) CGFloat minItemSpacing;

@end
