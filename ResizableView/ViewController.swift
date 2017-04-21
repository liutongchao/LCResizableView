//
//  ViewController.swift
//  ResizableView
//
//  Created by 刘通超 on 2017/4/21.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let resiable = LCResizableView.init(frame: CGRect.init(x: 50, y: 50, width: 150, height: 150))
        resiable.delegate = self
        imageView.addSubview(resiable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: LCResizableViewDelegate{
    func resizableViewBeginEditing() {
        print("resizableView touch begin")
    }
    
    func resizableViewEndEditing() {
        print("resizableView touch end")
    }
    
    func resizableViewFrameChanged(rect: CGRect) {
        print("resizableView frame changed:\(rect)")
    }
}

