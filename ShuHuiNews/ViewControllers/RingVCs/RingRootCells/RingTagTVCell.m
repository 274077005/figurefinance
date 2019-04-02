//
//  RingTagTVCell.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingTagTVCell.h"
#import "RingMoreListVC.h"
@implementation RingTagTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
    // Initialization code
}
- (IBAction)companyMoreBtnClick:(UIButton *)sender {
    
    RingMoreListVC * listVC = [[RingMoreListVC alloc]init];
    listVC.listType = @"1";
    listVC.statusModel = _statusModel;
    [self.viewContoller.navigationController pushViewController:listVC animated:YES];
    
}

- (void)updateWithRingModel
{
    [self.collectionV reloadData];
}
-(UICollectionViewFlowLayout *)createLayout
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //item尺寸
    //    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 50)/4, 60);
    //组的四周边距上左下右咯
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    return layout;
}
-(void)setupCollectionView{
    
    //注册cell类型及复用标识
    [self.collectionV registerNib:[UINib nibWithNibName:@"RingTagCVCell" bundle:nil] forCellWithReuseIdentifier:@"IndustryCellId"];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.collectionViewLayout = [self createLayout];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//设置collectionView的item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 60)/4,44);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_statusModel.companyAll) {
        return _ringModel.company_tag.count + 1;
    }else{
        return 8;
    }
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RingTagCVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndustryCellId" forIndexPath:indexPath];
    cell.backgroundColor = RGBCOLOR(244, 246, 248);
    
    
    
    if (_statusModel.companyAll) {
        if (indexPath.row == _ringModel.company_tag.count) {
            cell.titleLab.text = @"收起⇡";
        }else{
            RingTagModel * tagModel = _ringModel.company_tag[indexPath.row];
            NSString * titleStr = tagModel.name;
            cell.titleLab.text = titleStr;
        }
    }else{
        RingTagModel * tagModel = _ringModel.company_tag[indexPath.row];
        NSString * titleStr = tagModel.name;
        cell.titleLab.text = titleStr;
        if (indexPath.row == 7) {
            cell.titleLab.text = @"全部⇣";
        }
    }
    
    if ([_statusModel.sCompanyTag isEqualToString:cell.titleLab.text]) {
        cell.backgroundColor = WD_BLUE;
        cell.titleLab.textColor =  [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGBCOLOR(244, 246, 248);
        cell.titleLab.textColor =  [UIColor blackColor];
    }
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_statusModel.companyAll) {
        
        if (indexPath.row == _ringModel.company_tag.count) {
            _statusModel.companyAll = NO;
            NSIndexPath* cellIndex = [self.tableView indexPathForCell:self];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{

            RingTagModel * tagModel = _ringModel.company_tag[indexPath.row];
            //如果已经是选中的了
            if ([_statusModel.sCompanyTag isEqualToString:tagModel.name]) {
                _statusModel.sCompanyTag = @"";
                _statusModel.sCompanyId = @"";
            }else{
                
                
                _statusModel.sCompanyTag = tagModel.name;
                _statusModel.sCompanyId = tagModel.theId;
            }
            self.refreshBlock();
            [self.collectionV reloadData];
        }
    }else{
        if (indexPath.row == 7) {
            
            _statusModel.companyAll = YES;
            NSIndexPath* cellIndex = [self.tableView indexPathForCell:self];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            RingTagModel * tagModel = _ringModel.company_tag[indexPath.row];
            //如果已经是选中的了
            if ([_statusModel.sCompanyTag isEqualToString:tagModel.name]) {
                _statusModel.sCompanyTag = @"";
                _statusModel.sCompanyId = @"";
            }else{
                
                _statusModel.sCompanyTag = tagModel.name;
                _statusModel.sCompanyId = tagModel.theId;
            }
            self.refreshBlock();
            [self.collectionV reloadData];
        }
    }
    
}

@end
