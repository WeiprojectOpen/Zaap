# Zaap
Zaap is an Open Source iOS App Development Framework

Zaap Framework是面向DIYer的开源的iOS App快速开发框架，帮助业余团队快速的实现界面原型，获得可以利用本地伪数据展现交互的Demo版本。与绝大部分原型设计软件不同的是，此Demo可以直接提交和发布到苹果App Store。

对于开发团队而言，Zaap Framework可以帮助贯彻MVC的软件设计思想。MVC中的View（视图）部分，完全可以交由对于界面设计和交互更有感觉的产品经理、交互工程师或美工去完成。Zaap Framework的目标是将80%以上View（视图）处理（含界面交互逻辑、动画特效），全部经由非程序员通过配置plist文件的方式完成。这样，产品经理、交互工程师或美工们可以深入参与到App开发中来，缩短整个App开发的周期。

剩下的20%怎么办？我的控制器（Controller）怎样操控界面，捕捉界面交互？不用担心，Zaap Framework提供了丰富的API。对于常规视图对象，比如UIView, UIImageView, UIButton等，可以通过层级路径（Path）直接获取并替换其伪数据。对于表格（UITableView）、九宫格（UICollectionView）等，则采用代理（Protocal）的方式进行Hook，完美的对单元格（Cell）中的伪数据进行替换。

Zaap Framework的近期目标是能够累积足够的资金，开发一个Sketch同等品质的拖拽式视图编辑器，替代现在通过xcode配置plist的模式，进一步降低选择门槛。

如果您对资助Zaap Framework感兴趣，请联系我们。

北京微光恒兴科技有限公司
flannian@weiproject.com
