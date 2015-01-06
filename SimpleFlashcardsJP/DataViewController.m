//
//  DataViewController.m
//  SimpleFlashcardsJP
//
//  Created by Teru on 2015/01/03.
//  CopyDown (c) 2015年 Self. All Downs reserved.
//

#import "DataViewController.h"
#import "CardTableViewController.h"
#import "ModelController.h"
#import "CardText.h"
#import "CardNumber.h"

@interface DataViewController ()

@property (nonatomic, strong) CardText *cardTextManager;
@property (nonatomic, strong) CardNumber *dbCardNumber;
@property (nonatomic, strong) NSArray *dbCardNumberInfo;
@property (nonatomic, strong) NSArray *dbCardTextInfo;
@property (nonatomic, strong) NSArray *cardTextCount;
@property (nonatomic, assign) int textNumber;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.backView addSubview:_backButton];
    [self.backView addSubview:_textView];
    [self.backView addSubview:_gearButton];
    [self.backView addSubview:_stopButton];
    [self.backView addSubview:_playButton];
    [self.backView addSubview:_pauseButton];
    [self.backView addSubview:_moveButton];
    [self.backView addSubview:_horizontalView];
    [self.horizontalView addSubview:_movePageSlider];
    [self.horizontalView addSubview:_crossButton];
    
    // Initialize the dbManager object.
    self.cardTextManager = [[CardText alloc] initWithDatabaseFilename:@"CardText.sql"];
    self.dbCardNumber = [[CardNumber alloc] initWithDatabaseFilename:@"CardNumber.sql"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //クエリー作成。
    NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d", 0];
    NSString *queryLoadCN = [NSString stringWithFormat:@"select cardNumberInfoID from cardNumberInfo"];
    
    //データを読み込んで配列に追加。
    self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
    self.dbCardNumberInfo = [[NSArray alloc] initWithArray:[self.dbCardNumber loadDataFromDB:queryLoadCN]];
    
    //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
    NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
    
    //cardTextのpageIndex番目を表示。
    self.textView.text = [NSString stringWithFormat:@"%@", [[self.dbCardTextInfo objectAtIndex:self.pageIndex] objectAtIndex:indexOfText]];
    
    //現在表示しているカード番号と合計数を表示する。
    self.pageCountLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.pageIndex + 1, self.dbCardNumberInfo.count];
    
    //クエリー作成。カード番号のテキストを取得。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。カードのテキスト数を渡す。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    
    self.pageControl.numberOfPages = self.cardTextCount.count;
    self.movePageSlider.minimumValue = 1;
    self.movePageSlider.maximumValue = self.dbCardNumberInfo.count;
    self.textNumber = 0;
    
    if (self.showMoveSlider == 1) {
        self.horizontalView.hidden = NO;
        self.movePageSlider.hidden = NO;
        self.crossButton.hidden = NO;
        
        self.movePageSlider.value = self.pageIndex + 1;
    }else{
        self.showMoveSlider = 0;
    }
    
}

- (IBAction)backAction:(id)sender {
    // 隠していたNavBarを表示。
    [self.navigationController setNavigationBarHidden:NO];
    // コードからNavのBackボタンタップで前画面に戻る。
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textData{
    //クエリー作成。
    NSString *queryLoadCT = [NSString stringWithFormat:@"select cardText from cardTextInfo where textNumber = %d AND cardNumber = %@", self.textNumber, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    //データを読み込んで配列に追加。
    self.dbCardTextInfo = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCT]];
    
    //arrColumnNamesでindexを指定。そうすることでSQLの空白と改行をなくせる。
    NSInteger indexOfText = [self.cardTextManager.arrColumnNames indexOfObject:@"cardText"];
    //cardTextのpageIndex番目を表示。
    self.textView.text = [NSString stringWithFormat:@"%@", [[self.dbCardTextInfo objectAtIndex:0] objectAtIndex:indexOfText]];
    
    self.pageControl.currentPage = self.textNumber;
}

- (IBAction)changeTextAction:(id)sender {
    //クエリー作成。pageIndexに1を足してcardNumberに合わせる。
    NSString *queryLoadCTC = [NSString stringWithFormat:@"select cardText from cardTextInfo where cardNumber = %@", [self.dbCardNumberInfo objectAtIndex:self.pageIndex]];
    
    //データを読み込んで配列に追加。
    self.cardTextCount = [[NSArray alloc] initWithArray:[self.cardTextManager loadDataFromDB:queryLoadCTC]];
    //NSLog(@"count %ld cardNumber %@", self.cardTextCount.count, [self.dbCardNumberInfo objectAtIndex:self.pageIndex]);
    
    if (self.textNumber == 0) {
        self.textNumber = 1;
        [self textData];
        
    }else if (self.textNumber == 1) {
        if (self.cardTextCount.count == 2) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 2;
            [self textData];
        }
        
    }else if (self.textNumber == 2) {
        if (self.cardTextCount.count == 3) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 3;
            [self textData];
        }
        
    }else if (self.textNumber == 3) {
        if (self.cardTextCount.count == 4) {
            self.textNumber = 0;
            [self textData];
            
        }else{
            self.textNumber = 4;
            [self textData];
        }
        
    }else if (self.textNumber == 4) {
            self.textNumber = 0;
            [self textData];
    }
}

- (IBAction)movePageAction:(id)sender {
    self.horizontalView.hidden = NO;
    self.movePageSlider.hidden = NO;
    self.crossButton.hidden = NO;
    
    self.movePageSlider.value = self.pageIndex + 1;
    
    self.showMoveSlider = 1;
}

- (IBAction)crossAction:(id)sender {
    self.horizontalView.hidden = YES;
    self.movePageSlider.hidden = YES;
    self.crossButton.hidden = YES;
    
    self.showMoveSlider = -1;
}

- (IBAction)playAction:(id)sender {
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    self.stopButton.hidden = NO;
}

- (IBAction)pauseAction:(id)sender {
    self.pauseButton.hidden = YES;
    self.playButton.hidden = NO;
}

- (IBAction)stopAction:(id)sender {
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    self.stopButton.hidden = YES;
}

@end
