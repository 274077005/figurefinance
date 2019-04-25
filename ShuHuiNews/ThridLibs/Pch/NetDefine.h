//
//  NetDefine.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#ifndef NetDefine_h
#define NetDefine_h

#define NPayStatus                   @"NotificationPayStatus"  //支付的回调

#define JHomeMenu                   @"zixun/column_name"  //获取首页种类

#define JNewsList                   @"zixun/get_api"  //获取资讯

#define JFlashList                   @"zixun/flashList"  //快讯列表

#define JFlashPraise                 @"zixun/flashHits"    //对快讯点赞

#define JLogin                      @"zx/login_v1"     //登陆

#define JWeChatLogin                @"zixun/weinotify"     //微信登陆

#define JSinaLogin                @"zixun/weibo_notify"     //微博登陆

#define JGetVerifyNum               @"zx/note_code_v1"    //获取验证码

#define JRegister                   @"zx/registerOrBound_v1"    //手机号注册

#define JNoPWLogin                   @"zixun/check_regist_v1"    //免密登录

#define JBindPhone                  @"zixun/tel_bound"    //第三方登陆绑定手机号

#define JIndustry                   @"zx/industry_label"    //industry标签数据

#define JSaveTag                    @"zx/person_company_register"    //保存昵称和标签信息

#define JLostPw                     @"zx/amend_pwssawd_v1"    //忘记密码

#define JAllColumn                  @"zixun/type_leavel"    //获取所有栏目分类

#define JSaveColumn                 @"zixun/user_channel"    //保存用户栏目分类

#define JGetHotSearch               @"zixun/hot_search"    //获取热门搜索

#define JSearchkey                  @"zixun/home_search"    //搜索某个词

#define JSpecialList                @"zixun/more_special"    //专题列表

#define JSpecialDetail              @"zixun/special"    //专题详情

#define JChoiceRoot                 @"zixun/book_list_index"    //精选页面

#define JChoiceList                 @"zixun/more_book_list"    //书籍列表

#define JChoiceDetail               @"zixun/course_list"    //精选详情

#define JMainRoot                   @"zixun/like_num"    //我的页面

#define JActicityList               @"scan/activities"    //活动列表

#define JApplyOne                   @"scan/apply"    //报名某个活动

#define JMainInfo                   @"zixun/user_message"    //个人资料

#define JSaveMainInfo               @"zixun/amend_one"    //保存个人资料

#define JBellList                   @"zixun/feekback_msg"    //消息列表

#define JSavePersonProve            @"zx/person_register"    //保存个人认证

#define JSaveCompanyProve           @"zx/company_register"    //保存公司认证

#define JGetProveData               @"zx/get_register"    //获取认证信息

#define JMainWorkList              @"zixun/auth_more_assay"    //我的文章

#define JCollectWork              @"zixun/click_collect"    //收藏某个文章

#define JRemoveCollect              @"zixun/remove_collect"    //删除某个收藏

#define JAddComment              @"zixun/emit_essay"    //添加评论

#define JDelComment              @"zixun/emit_cancel"    //删除评论

#define JPraiseComment              @"zixun/praise"    //点赞评论

#define JCollectList              @"zixun/mine_collect"    //收藏列表

#define JColumnList              @"zixun/columnist"    //专栏列表


#define JFansList              @"zixun/mine_fans"    //粉丝列表

#define JLikeList              @"zixun/mine_atten"    //关注列表

#define JFansSome              @"zixun/attention"    //粉某个人


#define JRingMenu            @"zx/weo_column"    //微圈栏目

#define JRingRoot            @"zx/weo_index"    //微圈首页

#define JShareTell            @"zixun/share_num_append"    //分享某个文章告诉后台

#define JRingMoreList         @"zx/company_person_arr"    //认证更多

#define JRingWriteList         @"zx/article_list"    //微圈文章的列表

#define JRingDetail             @"zixun/user_once_msg_v2"    //微圈某个详情

#define JVideoNews             @"zixun/correlation_video"    //某个视频页面的资讯

#define JQAList             @"zx/indexQuestions"    //问答列表

#define JQADetail            @"zx/questionDetail"    //问题详情

#define JQADoPraise           @"zx/doPraise"    //对答案评价

#define JQADoAnswer           @"zx/doAnswer"    //回答某个问题

#define JReplyMe          @"zx/answerMe"    //问答中回复我的

#define JQCommentOther       @"zx/myAnswers"    //问答中我发出的

#define JMyQAList          @"zx/myQuestions"    //我的问答列表

#define JCreateQ          @"zx/addQuestion"    //发布问题

#define JMyWallet         @"zixun/balance"    //钱包余额

#define JBuyDou           @"zx/ios_pay"    //内购

#define JTradRecord       @"zixun/tran_log"    //交易记录

#define JBookDetail       @"zixun/getBookDetail"    //图书详情

#define JOrderDetail      @"zixun/order_detail"    //订单信息

#define JSubmitOrder      @"zixun/save_order"    //提交订单

#define JAddAddress      @"zixun/operate_address"    //新增收货地址

#define JDelAddress      @"zixun/delete_address"    //删除收货地址   

#define JAddressList      @"zixun/address_list"    //收货地址列表

#define JOrderList      @"zixun/order_list"    //订单列表

#define JCalendarList      @"zixun/calendarData"    //日历页面

#define JChainMenu       @"zixun/moneyType"  //获取区块链市场种类

#define JMarketList       @"zixun/getUrlData"  //获取某个品种的所有市场交易价格

#define JMainCenter       @"zixun/personCenter"    //个人中心

#define JSaveBasicInfo      @"zixun/editBasicInfo"    //保存简介

#define JSavePersonalBasicInfo      @"zixun/editPerBasic"    //保存个人简介

#define JSavePersonalAttestation      @"zixun/editPerAttestation"    //保存个人基础信息

#define JSaveContact       @"zixun/editContact"    //保存用户联系方式

#define JSaveEnvironment      @"zixun/operateEnvironment"    //保存交易环境

#define JDeleteEnvironment      @"zixun/deleteEnvironment"    //删除交易环境

#define JSaveCompanyUrl      @"zixun/editUrls"    //保存网址信息

#define JSaveAttestation      @"zixun/editAttestation"    //保存网址信息

#define JSaveCompanyComment      @"zixun/addComment"    //评论某个公司

#define JCompanyCommentPraise    @"zixun/addHits"    //公司评论

#define JDelCompanyComment    @"zixun/delComment"    //删除公司评论

#define JCompanyMoreComment    @"zixun/moreComments"    //公司评论列表

#define JSaveAdvert         @"zixun/operateAd"    //保存广告

#define JDeleteAdvert      @"zixun/deleteAd"    //删除广告

#define JSaveRegulatory        @"zixun/operateRegulatory"    //保存监管信息

#define JDeleteRegulatory      @"zixun/deleteRegulatory"    //删除监管信息

#define JGetLaunchAdvert      @"zixun/getScreenAd"    //获取启动广告

#define JAddFlash      @"zixun/addFlash"    //新增快讯

#define JMyReadListUrl @"zixun/authorSubList" //获取订阅列表

#define JMyReadStatus  @"zixun/authorSub" // 订阅/取消订阅

#define JMyPayBuyListUrl @"zixun/payBuyList" //我的订购-我的购买

#endif /* NetDefine_h */
