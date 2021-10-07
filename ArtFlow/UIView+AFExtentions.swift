//
//  UIView+ANTExtentiosn.swift
//  ArtFlow
//
//  Created by Quinn on 11/03/21.
//

import UIKit

extension UIView {
    //MARK: Border
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth =  newValue
        }
    }

    @IBInspectable var borderColor : UIColor {
        get {
            let c = layer.borderColor ?? (self.backgroundColor?.cgColor ?? UIColor.clear.cgColor) //either border color or view background color or clear color
            return UIColor(cgColor: c)
        }
        set {
            layer.borderColor =  newValue.cgColor
        }
    }
    
    //MARK: Corner
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            layer.cornerRadius =  newValue
        }
    }
    
    //MARK: Shadow
    @IBInspectable var shadowRadius : CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            layer.shadowRadius =  newValue
        }
    }

    @IBInspectable var shadowOpacity : Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity =  newValue
        }
    }

    
    @IBInspectable var shadowColor : UIColor? {
        get {
            if let c = layer.shadowColor {return UIColor(cgColor: c)}
            return nil
        }
        set {
            if let c = newValue {
                layer.shadowColor = c.cgColor
            }else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var shadowOffset : CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}

