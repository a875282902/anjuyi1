//
//  RecognizerView.m
//  anjuyi1
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 lsy. All rights reserved.
//

#import "RecognizerView.h"
#import <AliyunNlsSdk/NlsVoiceRecorder.h>
#import <AliyunNlsSdk/NlsSpeechRecognizerRequest.h>
#import <AliyunNlsSdk/RecognizerRequestParam.h>
#import <AliyunNlsSdk/AliyunNlsClientAdaptor.h>
#import <AliyunNlsSdk/AccessToken.h>

@interface RecognizerView ()<NlsSpeechRecognizerDelegate,NlsVoiceRecorderDelegate>
{
    Boolean recognizerStarted;
    UITextField * _textField;
}

@property (nonatomic,strong)UIView                            * speechView;

@property(nonatomic,strong) NlsClientAdaptor *nlsClient;
@property(nonatomic,strong) NlsSpeechRecognizerRequest *recognizeRequest;
@property(nonatomic,strong) NlsVoiceRecorder *voiceRecorder;
@property(nonatomic,strong) RecognizerRequestParam *recognizeRequestParam;

@property(atomic) Boolean record;
@end
@implementation RecognizerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initRecognizer];
        [self setUpUI];
        
    }
    return self;
}

- (void)initRecognizer{
    
    //1.1 初始化识别客户端,将recognizerStarted状态置为false
    _nlsClient = [[NlsClientAdaptor alloc]init];
    recognizerStarted = false;
    //1.2 初始化录音recorder工具
    _voiceRecorder = [[NlsVoiceRecorder alloc]init];
    _voiceRecorder.delegate = self;
    //1.3 初始化识别参数类
    _recognizeRequestParam = [[RecognizerRequestParam alloc]init];
    //1.4 设置log级别
    [_nlsClient setLog:NULL logLevel:LOGINFO];
}

#pragma mark -- 语音识别

 - (void)setUpUI{
    
    UIButton *btn =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setFrame:CGRectMake((KScreenWidth - 200)/2.0, 15, 200,30)];
    [btn setImage:[UIImage imageNamed:@"syuyin"] forState:(UIControlStateNormal)];
    [btn setTitle:@"按着 说出你要找的内容" forState:(UIControlStateNormal)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageWithColor:MDRGBA(255, 181, 0, 1)] forState:(UIControlStateHighlighted)];
    btn.layer.borderColor = MDRGBA(222, 222, 222, 1).CGColor;
    btn.layer.borderWidth = 1;
    [btn setClipsToBounds:YES];
    [btn.layer setCornerRadius:15];
    [btn addTarget:self action:@selector(speechRecognizer:) forControlEvents:(UIControlEventTouchDown)];
    [btn addTarget:self action:@selector(stopRecognizer:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];

}

- (void)speechRecognizer:(UIButton *)sender{
    
    NSLog(@"UIControlEventTouchDown");
    
    NSString *path = [NSString stringWithFormat:@"%@/currency/ali_get_token",KURL];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf creareSpeechRecognizer:responseObject[@"datas"][@"ali_token"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [RequestSever showMsgWithError:error];
    }];

}

- (void)creareSpeechRecognizer:(NSString *)token{
    
    if (recognizerStarted) {
        NSLog(@"already started!");
        return;
    }
    
    //2. 创建请求对象和开始识别
    if(_recognizeRequest!= NULL){
        [_recognizeRequest releaseRequest];
        _recognizeRequest = NULL;
    }
    
    //2.1 创建请求对象，设置NlsSpeechRecognizerDelegate回调
    _recognizeRequest = [_nlsClient createRecognizerRequest];
    _recognizeRequest.delegate = self;
    
    //2.2 设置RecognizerRequestParam请求参数
    [_recognizeRequestParam setFormat:@"opu"];
    [_recognizeRequestParam setEnableIntermediateResult:true];
    //请使用https://help.aliyun.com/document_detail/72153.html 动态生成token
    //或者采用本Demo的_generateTokeng方法获取token
    // <AccessKeyId> <AccessKeySecret> 请使用您的阿里云账户生成 https://ak-console.aliyun.com/
    [_recognizeRequestParam setToken:token];
    //    [_recognizeRequestParam setToken:[self _generateToken:@"AccessKeyId" withSecret:@"AccessKeyId"]];
    //请使用阿里云语音服务管控台(https://nls-portal.console.aliyun.com/)生成您的appkey
    [_recognizeRequestParam setAppkey:@"kfM1o4yU49bldbNH"];
    
    //2.3 传入请求参数
    [_recognizeRequest setRecognizeParams:_recognizeRequestParam];
    
    //2.4 启动录音和识别，将recognizerStarted置为true
    [_voiceRecorder start];
    
    [_recognizeRequest start];
    recognizerStarted = true;
    //2.5 更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
}
- (void)stopRecognizer:(UIButton *)sender{
    
    [_voiceRecorder stop:true];
    [_recognizeRequest stop];
    recognizerStarted = false;
    _recognizeRequest = NULL;
}
/**
 *4. NlsSpeechRecognizerDelegate回调方法
 */
//4.1 识别回调，本次请求失败
-(void)OnTaskFailed:(NlsDelegateEvent)event statusCode:(NSString*)statusCode errorMessage:(NSString*)eMsg{
    [_voiceRecorder stop:true];
    recognizerStarted = false;
    NSLog(@"OnTaskFailed, error message is: %@",eMsg);
    [self.delegate speechRecognitionWithSuccess:NO withString:eMsg];
}

//4.2 识别回调，服务端连接关闭
-(void)OnChannelClosed:(NlsDelegateEvent)event statusCode:(NSString*)statusCode errorMessage:(NSString*)eMsg{
    recognizerStarted = false;
    NSLog(@"OnChannelClosed, statusCode is: %@",statusCode);
    [_voiceRecorder stop:true];
}

//4.3 识别回调，识别结果结束
-(void)OnRecognizedCompleted:(NlsDelegateEvent)event result:(NSString *)result statusCode:(NSString*)statusCode errorMessage:(NSString*)eMsg{
    recognizerStarted = false;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%@", result);
        NSDictionary *dic = [self dictionaryWithJsonString:result];
        
        [self.delegate speechRecognitionWithSuccess:YES withString:dic[@"payload"][@"result"]];
    });
}

//4.4 识别回调，识别中间结果
-(void)OnRecognizedResultChanged:(NlsDelegateEvent)event result:(NSString *)result statusCode:(NSString*)statusCode errorMessage:(NSString*)eMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        NSLog(@"%@", result);
    });
}

/**
 *5. 录音相关回调
 */
- (void)recorderDidStart {
    NSLog(@"Did start recorder!");
    [self.delegate speechRecognitionIsShow:YES];
}

- (void)recorderDidStop {
    NSLog(@"Did stop recorder!");
    [self.delegate speechRecognitionIsShow:NO];
}

- (void)voiceDidFail:(NSError *)error {
    NSLog(@"Did recorder error!");
}

//5.1 录音数据回调
- (void)voiceRecorded:(NSData *)frame {
    if (_recognizeRequest != nil &&recognizerStarted) {
        //录音线程回调的数据传给识别服务
        [_recognizeRequest sendAudio:frame length:(short)frame.length];
    }
}

- (void)voiceVolume:(NSInteger)volume {
    // onVoiceVolume if you need.
}

/**
 *生成AccessToken的iOS实现
 *为安全考虑，我们建议您不要使用这个接口生成token
 *建议您采用服务端生成token，分发到服务端使用。
 *expireTime 为本次token的过期时间
 */

-(NSString*)_generateToken:(NSString*)accessKey withSecret:(NSString*)accessSecret{
    AccessToken *accessToken = [[AccessToken alloc]initWithAccessKeyId:accessKey andAccessSecret:accessSecret];
    [accessToken apply];
    NSLog(@"Token expire time is %ld",[accessToken expireTime]);
    return [accessToken token];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
