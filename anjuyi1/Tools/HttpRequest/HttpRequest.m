//
//  HttpRequest.m
//
//  Created by Micheal on 15/7/13.
//  Copyright (c) 2015年 Micheal. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (void) checkReachabilityStatus:(void (^)(NSString *status))netStatus{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case 0:
                netStatus(@"无连接");
                break;
            case 1:
                netStatus(@"3G/4G网络");
                break;
            case 2:
                netStatus(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
}
+(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
   
    manager.securityPolicy  = securityPolicy;
    
    // 超时时间
//    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
  manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式

    
 [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json",@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
    

    return manager;
}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id  responseObject))success
    failure:(void (^)(NSError *  error))failure{
    //    AFHTTPRequestOperationManager *manager   = [AFHTTPRequestOperationManager manager];
    
    AFHTTPSessionManager *mana = [self manager];
    
    [mana GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}


+ (void) POST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id))success
      failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *mana = [self manager];
    
    if (UTOKEN) {
        [mana.requestSerializer setValue:UTOKEN forHTTPHeaderField:@"token"];
    }
    
    [mana POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTWithHeader:(NSDictionary *)header
                   url:(NSString *_Nullable)URLString
            parameters:(id _Nullable )parameters
               success:(void (^_Nullable)(id _Nullable responseObject))success
               failure:(void (^_Nullable)(NSError * _Nullable error))failure{
    
    AFHTTPSessionManager *mana = [self manager];
    
    for (NSString * key in header.allKeys) {
        [mana.requestSerializer setValue:[header valueForKey:key] forHTTPHeaderField:key];
    }
    
    [mana POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void) uploadFileWithInferface:(NSString *)URLString
                      parameters:(id)parameters
                        fileData:(NSData *)fileData
                      serverName:(NSString *)serverName
                        saveName:(NSString *)saveName
                        mimeType:(mimeFileType )mimeType
                        progress:(void (^)(float progress))progress
                         success:(void(^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *mana = [self manager];
    
    [mana POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        //        NSData *imageData = [[NSData alloc] init];
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        
        if (mimeType == MCMP4FileType) {
            fileName  = [NSString  stringWithFormat:@"%@.mp4", dateString];
        }
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        //        [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"];
        
        
        NSString *typeString = [[self class] uploadFileMineType:mimeType];
        [formData appendPartWithFileData:fileData name:serverName fileName:fileName mimeType:typeString];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        CGFloat p = ((CGFloat)totalBytesWritten / totalBytesExpectedToWrite) * 100;
        
        if (progress) {
            
            progress(uploadProgress.fractionCompleted);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
    
    
}


+ (void) downloadFileWithInferface:(NSString*)URLString
                         savedPath:(NSString*)savedPath
                 completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
                          progress:(void (^)(float progress))progress{
    
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //        // 下载地址
        //        NSLog(@"默认下载地址%@",targetPath);
        //        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        //       NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:savedPath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        completionHandler(response,filePath,error);
        
    }];
    
    // 5.启动下载任务
    [task resume];
}


+ (NSString *) uploadFileMineType:(mimeFileType)type{
    
    // -- mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
    
    NSString *typeString = nil;
    
    switch (type) {
        case MCZipFileType:
            typeString = @"application/zip";
            break;
        case MCJPEGImageFileType:
            typeString = @"image/jpeg";
            break;
        case MCPNGImageFileType:
            typeString = @"image/png";
            break;
        case MCJSONFileType:
            typeString = @"application/json";
            break;
        case MCTXTFileType:
            typeString = @"text/plain";
            break;
        case MCMP4FileType:
            typeString = @"video/mp4";
            break;
            
        default:
            break;
    }
    
    return typeString;
}


@end
