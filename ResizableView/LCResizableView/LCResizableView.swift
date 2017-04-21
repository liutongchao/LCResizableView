//
//  LCResizableView.swift
//  ResizableView
//
//  Created by 刘通超 on 2017/4/21.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

enum ResizableViewArea {//响应区分为九大区域
    case upLeft
    case left
    case downLeft
    case down
    case downRight
    case right
    case upRight
    case up
    case center
}

fileprivate let minWidth: CGFloat = 20
fileprivate let minHeight: CGFloat = 20

protocol LCResizableViewDelegate {
    func resizableViewBeginEditing()
    func resizableViewEndEditing()
    func resizableViewFrameChanged(rect: CGRect)
}

class LCResizableView: UIView {

    fileprivate var startPoint: CGPoint?
    fileprivate var touchArea: ResizableViewArea?
    fileprivate var shade = LCResizableLayer.instanceFromNib()
    
    var delegate: LCResizableViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shade?.frame = self.bounds
        guard shade != nil else {
            return
        }
        self.addSubview(shade!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: touch相关
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        guard touchPoint != nil else {
            return
        }
        
        delegate?.resizableViewBeginEditing()
        
        touchArea = checkPointInArea(point: touchPoint!)
        if touchArea == .center {
            startPoint = touch?.location(in: self)
        }else{
            startPoint = touch?.location(in: self.superview)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchArea == .center {
            let touch = touches.first
            let movePoint = touch?.location(in: self)
            guard movePoint != nil else {
                return
            }
            translate(movePoint: movePoint!)
        }else{
            let touch = touches.first
            let movePoint = touch?.location(in: self.superview)
            guard movePoint != nil else {
                return
            }
            resizable(movePoint: movePoint!)
        }
        
        delegate?.resizableViewFrameChanged(rect: self.frame)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resizableViewEndEditing()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resizableViewEndEditing()
    }
    
}

//视图 frame 动态相关
extension LCResizableView{
    //touch 在中心区域，只移动视图
    fileprivate func translate(movePoint: CGPoint) {
        guard startPoint != nil else {
            return
        }
        guard self.superview != nil else {
            return
        }
        var newCenterX = self.center.x + movePoint.x - startPoint!.x
        var newCenterY = self.center.y + movePoint.y - startPoint!.y
        
        if newCenterX < self.bounds.width/2 {
            newCenterX = self.bounds.width/2
        }
        if newCenterX + self.bounds.width/2 > self.superview!.bounds.width {
            newCenterX = self.superview!.bounds.width - self.bounds.width/2
        }
        
        if newCenterY < self.bounds.height/2 {
            newCenterY = self.bounds.height/2
        }
        if newCenterY + self.bounds.height/2 > self.superview!.bounds.height {
            newCenterY = self.superview!.bounds.height - self.bounds.height/2
        }
        self.center = CGPoint.init(x: newCenterX, y: newCenterY)
        
    }
    //touch 在非中心区域
    fileprivate func resizable(movePoint: CGPoint) {
        guard startPoint != nil else {
            return
        }
        guard self.superview != nil else {
            return
        }
        var newX = self.frame.origin.x
        var newY = self.frame.origin.y
        var newWidth = self.bounds.width
        var newHeight = self.bounds.height
        
        let subWidth = self.superview!.bounds.width
        let subHeight = self.superview!.bounds.height
        
        let diffX = movePoint.x - startPoint!.x
        let diffY = movePoint.y - startPoint!.y
        
        switch touchArea! {
        case .upLeft:
            newX += diffX
            newWidth = newX > 0 ? newWidth - diffX : newWidth

            newY += diffY
            newHeight = newY > 0 ? newHeight - diffY : newHeight

            break
            
        case .left:
            newX += diffX
            newWidth = newX > 0 ? newWidth - diffX : newWidth
            break
            
        case .downLeft:
            newX += diffX
            newWidth = newX > 0 ? newWidth - diffX : newWidth

            newHeight += diffY
            break
            
        case .down:
            newHeight += diffY
            break
            
        case .downRight:
            newWidth += diffX
            newHeight += diffY
            break
            
        case .right:
            newWidth += diffX
            break
            
        case .upRight:
            newWidth += diffX
            newY += diffY
            newHeight = newY > 0 ? newHeight - diffY : newHeight

            break
        case .up:
            newY += diffY
            newHeight = newY > 0 ? newHeight - diffY : newHeight

            break
        default:
            break
        }
        
        newX = newX < 0 ? 0: newX;
        newY = newY < 0 ? 0: newY;
        newWidth = (newX + newWidth > subWidth) ? (subWidth - newX) : newWidth
        newHeight = (newY + newHeight > subHeight) ? (subHeight - newY) : newHeight
        
        newWidth = newWidth < minWidth ? minWidth: newWidth
        newHeight = newHeight < minHeight ? minHeight: newHeight

        
        self.frame = CGRect.init(x: newX, y: newY, width: newWidth, height: newHeight)
        
        startPoint = movePoint
    }
    
    //检测 touch 在哪个区域
    fileprivate func checkPointInArea(point:CGPoint) -> ResizableViewArea {
        let coord = getPointCoord(point: point)
        
        switch coord {
            //左区域
        case (1,1):
            return .upLeft
        case (1,2):
            return .left
        case (1,3):
            return .downLeft
            //中区域
        case (2,1):
            return .up
        case (2,2):
            return .center
        case (2,3):
            return .down
            //右区域
        case (3,1):
            return .upRight
        case (3,2):
            return .right
        case (3,3):
            return .downRight
            
        default:
            return .center
        }
    }
    
    //获取 touch 所在视图的坐标，用(3,3)元组标识出 九大区域
    fileprivate func getPointCoord(point:CGPoint) -> (Int, Int) {
        let selfWidth = self.bounds.width
        let selfHeight = self.bounds.height
        let pointX = point.x
        let pointY = point.y
        
        var coordX = 1
        var coordY = 1
        
        if pointX < selfWidth/3 {
            coordX = 1
        }else if pointX >= selfWidth/3 && pointX <= 2*selfWidth/3{
            coordX = 2
        }else if pointX > 2*selfWidth/3{
            coordX = 3
        }
        
        if pointY < selfHeight/3 {
            coordY = 1
        }else if pointY >= selfHeight/3 && pointY <= 2*selfHeight/3{
            coordY = 2
        }else if pointY > 2*selfHeight/3{
            coordY = 3
        }
        
        return (coordX, coordY)
    }

}

