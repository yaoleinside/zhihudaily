# 知乎日报
采用MVC设计模式仿写了知乎日报app.

使用block封装了网络层,数据层并实现了数据本地持久化.

网络层使用AFNetworking第三方框架进行GET请求,图片加载使用了SDWebImage框架.

API分析参考了<https://github.com/izzyleung/ZhihuDailyPurify/wiki/%E7%9F%A5%E4%B9%8E%E6%97%A5%E6%8A%A5-API-%E5%88%86%E6%9E%90>.

---

#主页

* 实现上拉自动加载更多数据
	> 使用`-(void)scrollViewDidScroll:(UIScrollView *)scrollView`代理  
	监听`scrollView.contentOffset.y`  
	当该值与`scrollView.bounds.size.height`之和大于`contentSize`就加载更多.
	
- 点击进入对应文章
	>用`didSelectRowAtIndexPath`确定点击位置;
- 自定义导航栏 

	>透明状态栏
	>>用图形上下文绘制一个1*1的透明图片设置为NaviBar的背景图片

	>下拉渐变导航栏效果
	>>给导航条添加一个UIImageView并设置颜色,根据`scrollView.contentOffset.y`来计算设置导航条图片的alpha值
	
- JSON解析字典转模型
	>根据JSON结构,创建Model,并实现initWithDict方法

- 使用手势实现动画加载/退回文章页面
	>用`UISwipeGestureRecognizer`实现手势  
	通过`UIView`的`animateWithDuration`block设置webview的frame来实现动画效果
- 使用代理传值实现点击横幅图片进入对应文章
	>在BannerView里自定义Protocol创建传值代理,把被选中的图片序号传给Controller.
- 所有的数据请求封装在YaoleDateSource类里,网络请求封装在YaoleNetWorkingTool类了,降低耦合方便维护.均使用block封装,方便调用传值.