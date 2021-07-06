//
//  CHMusicView.m
//  CloudHub Active
//
//  Created by fzxm on 2021/4/25.
//

#import "CHMusicView.h"
#import "CHMusicTableViewCell.h"

static  NSString * const   CHMusicTableViewCellID     = @"CHMusicTableViewCell";

@interface CHMusicView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UITableView *musicListTableView;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (nonatomic, assign) NSInteger lastSelectIndex;

@end


@implementation CHMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = CHWhiteColor;
        self.musicList = [NSMutableArray new];
        self.lastSelectIndex = -1;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setupUI
{
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.text = CH_Localized(@"Music.Background_music");
    titleLable.font = CHFont12;
    titleLable.textColor = CHColor_6D7278;
    titleLable.textAlignment  = NSTextAlignmentCenter;
    self.titleLable = titleLable;
    [self addSubview:titleLable];
    
    self.musicListTableView = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStylePlain];
    [self addSubview:self.musicListTableView];
    self.musicListTableView.delegate   = self;
    self.musicListTableView.dataSource = self;
    self.musicListTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.musicListTableView.backgroundColor = UIColor.clearColor;
    self.musicListTableView.separatorColor  = [UIColor clearColor];
    self.musicListTableView.showsHorizontalScrollIndicator = NO;
    self.musicListTableView.showsVerticalScrollIndicator = NO;
    
    [self.musicListTableView registerClass:[CHMusicTableViewCell class] forCellReuseIdentifier:CHMusicTableViewCellID];
    
    for (NSUInteger i = 0; i < 3; i++)
    {
        CHMusicModel *model = [[CHMusicModel alloc] init];
        model.name = [NSString stringWithFormat:@"背景音乐%@",@(i+1)];
        model.isPlay = NO;
        model.path = [NSString stringWithFormat:@"background_music%@.mp3",@(i+1)];
        model.soundId = i+1000;
        [self.musicList addObject:model];
    }
    [self.musicListTableView reloadData];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.titleLable.frame = CGRectMake(0, 17.0f, self.ch_width, 17.0f);
    self.musicListTableView.frame = CGRectMake(0, self.titleLable.ch_bottom + 5.0f, self.ch_width, 110.0f);
    [self.musicListTableView ch_setTop:self.titleLable.ch_bottom + 5.0f bottom:self.ch_height];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHMusicTableViewCellID];
    if(indexPath.row < self.musicList.count)
    {
        CHMusicModel * model = self.musicList[indexPath.row];
        cell.musicModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectIndex != -1)
    {
        CHMusicModel *lastModel = self.musicList[self.lastSelectIndex];
        if (self.lastSelectIndex == indexPath.row)
        {
            if (lastModel.isPlay)
            {
                [RtcEngine stopEffect:(int)lastModel.soundId];
                lastModel.isPlay = NO;
                
                [tableView reloadData];
                
                return;
            }
        }
        else
        {
            lastModel.isPlay = NO;
            [RtcEngine stopEffect:(int)lastModel.soundId];
        }
    }
    
    self.lastSelectIndex = indexPath.row;
    CHMusicModel *lastModel = self.musicList[self.lastSelectIndex];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] resourcePath]];
    NSString *filePath = [[bundle resourcePath] stringByAppendingPathComponent:lastModel.path];
    [RtcEngine playEffect:(int)lastModel.soundId filePath:filePath loopCount:0 pitch:1 pan:0 gain:0 publish:YES startTimeMS:0 endTimeMS:0];
            
    lastModel.isPlay = YES;

    [tableView reloadData];
}

@end
