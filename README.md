# LCResizableView
##效果


![LCResizableView](http://upload-images.jianshu.io/upload_images/1951020-03a49a94e51bee13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##如何引用
直接将 `LCResizableView ` 文件夹下的文件拉进项目中即可

![LCResizableView](http://upload-images.jianshu.io/upload_images/1951020-8bc5f7f58f75db23.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##如何使用
LCResizableView 的使用非常简单，只需两行代码

    let resiable = LCResizableView.init(frame: CGRect.init(x: 50, y: 50, width: 150, height: 150))
    imageView.addSubview(resiable)

另外如果要监测选择框的状态，需实现协议 LCResizableViewDelegate

    func resizableViewBeginEditing()
    func resizableViewEndEditing()
    func resizableViewFrameChanged(rect: CGRect)

##更改选择框风格
针对选择框的风格这里专门封装成了一个 view 类，可在nib 或 用代码修改成自己需要的样式
![LCResizableLayer](http://upload-images.jianshu.io/upload_images/1951020-1750895f66eb7365.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
