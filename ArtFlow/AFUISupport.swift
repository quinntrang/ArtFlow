//
//  AFUISupport.swift
//  ArtFlow
//
//  Created by Quinn on 02/05/21.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}


struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
    
    static func clearTabBar(forBar tabBar: UITabBar) {
        tabBar.backgroundImage = UIColor.clear.image()
    }
}

class AFNCMain : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        System.clearNavigationBar(forBar: navigationBar)
        
        navigationBar.setBackgroundImage(UIImage(named:"Background"), for: .default)
        if #available(iOS 11.0, *) {
            //navigationBar.prefersLargeTitles = true
        }
    }
}

class AFVCMain : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9846286178, green: 0.9790651202, blue: 1, alpha: 1)
    }
    
    func setLargeHeader() {
        let iv = UIImageView.init(image: UIImage(named:"Background"))
        var frame = iv.frame
        frame.origin.y = 0
        iv.frame = frame
        self.view.insertSubview(iv, at: 0)
    }
}

class AFTVCMain : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = #colorLiteral(red: 0.9846286178, green: 0.9790651202, blue: 1, alpha: 1)
    }
    
    func setLargeHeader() {
        let iv = UIImageView.init(image: UIImage(named:"Background"))
        var frame = iv.frame
        frame.origin.y = 0
        iv.frame = frame
        self.view.insertSubview(iv, at: 0)
    }
}


class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

