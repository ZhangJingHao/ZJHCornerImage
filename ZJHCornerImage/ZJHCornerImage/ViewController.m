//
//  ViewController.m
//  ZJHCornerImage
//
//  Created by ZhangJingHao2345 on 2017/12/5.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "ViewController.h"
#import "CustomViewController.h"
#import "FPSIndicatorMgr.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *cellNameArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleArr = @[ @"1、CornerRadius 设置圆角",
                       @"2、Core Graphics 生成圆角图片",
                       @"3、UIBezierPath CAShapeLayer",
                       @"4、覆盖镂空图片",
                       @"5、SDWebImage + Graphics" ];
    
    self.cellNameArr = @[ @"CornerRadiusCell",
                          @"CoreGraphicsCell",
                          @"ShapeLayerCell",
                          @"CoverViewCell",
                          @"SDGraphicsCell" ];
    
    [[FPSIndicatorMgr sharedFPSIndicator] show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_Id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_Id];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomViewController *vc = [CustomViewController new];
    vc.title = self.titleArr[indexPath.row];
    vc.cellName = self.cellNameArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end



