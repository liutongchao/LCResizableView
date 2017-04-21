//
//  LCResizableLayer.swift
//  ResizableView
//
//  Created by 刘通超 on 2017/4/21.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class LCResizableLayer: UIView {

    class func instanceFromNib() -> LCResizableLayer?{
    
        let nib = UINib.init(nibName: "\(self)", bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        let view = views[0] as AnyObject
        if view.isMember(of: self) {
            return view as? LCResizableLayer
        }else{
            return nil
        }
        
    }

}
