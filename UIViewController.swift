//
//  UIViewController.swift
//  SOSCarePartner
//
//  Created by Admin on 02/05/20.
//  Copyright © 2020 MACOS-Mojave1. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigation(with backgroundColor: UIColor = .white, title: String = "", titleColor: UIColor = .white, showBackButton: Bool, action: Selector?) {
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        
        let textAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: titleColor,
                                                              NSAttributedString.Key.font: UIFont(name: constant.Font.raleWayBold,
                                                                                                  size: constant.FontSize.size24)!]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let navItem = UINavigationItem(title: title)
        if showBackButton {
            let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: nil, action: action)
            backButton.tintColor = .white
            backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: -2)
            navItem.leftBarButtonItem = backButton
        }
        navigationController?.navigationBar.setItems([navItem], animated: false)
    }
    
    func pushVC(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func popToBackVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func popToRootVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setStatusBar() {
        
        let statusBar = UIView()
        statusBar.backgroundColor = constant.Color.navyBlue
        self.view.addSubview(statusBar)
        
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        statusBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    
    func pop(from vc: UIViewController, to main: AnyObject) {
        if let viewControllers = self.navigationController?.viewControllers {
            for controller  in viewControllers where controller.isKind(of: main as! AnyClass) {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    func onNeedHelpTap() {
        guard let url = URL(string: "https://wa.me/919111891118?text=Hi") else { return }
        UIApplication.shared.open(url)
    }
    
    func showAlertWithAction(title: String?, msg: String?, okText: String = "OK", cancelText: String = "Cancel", OkAction: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okText, style: .default, handler: OkAction)
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showMedicineReminderNotification(dict: [[String: Any]]) {
        
        let window = UIApplication.shared.keyWindow!
        let vwMedicineReminder = MedicineReminderView.instanceFromNib(nibName: "MedicineReminderView") as! MedicineReminderView
        vwMedicineReminder.frame = self.view.frame
        vwMedicineReminder.setUpData(medicineDetail: dict)
        let subViews = window.subviews.filter({$0.isKind(of: MedicineReminderView.self)})
        if subViews.isEmpty {
            window.addSubview(vwMedicineReminder)
        }
    }
    
    func showZoomNotification(zoom_meeting_Id:Int,zoom_meeting_Password:Int) {
        let vc = ZoomViewController()
        vc.isDirect = true
        vc.Zoom_Meeting_Id = "\(zoom_meeting_Id)"
        vc.Zoom_Meeting_Password = "\(zoom_meeting_Password)"
        vc.hidesBottomBarWhenPushed = true
        if let topVC = UIApplication.getTopViewController() {
            topVC.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    /// Add Webview on any controller by just passing url
    /// - Parameter url: url to be open in webview
    func WebView(url:String) {
        let userNewDashboardSB = UIStoryboard(name: "UserNewDashboard", bundle: nil)
        if let vc = userNewDashboardSB.instantiateViewController(withIdentifier: "UserNewWebViewController") as? UserNewWebViewController {
            vc.webUrl = url
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    /// To add bottomViewSlider View and  Add blackview tapgesture on called viewController and in tapgesture function call hideBottomSheetGeneric() function to hide openView
    /// - Parameter viewShow: The View to be shown in bottomsheet
    /// - Parameter black: The View to be hidden whenBottomSheet is open state
    func SetupSelectLocationViewGeneric<T:UIView>(viewShow:T,black:T,heightMultiplier:Double) {
        // Add blackview tapgesture on called viewController and in tapgesture function call hideBottomSheetGeneric() function to hide openView
        viewShow.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height / CGFloat(heightMultiplier))
        black.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
        viewShow.backgroundColor = UIColor.white
        black.alpha = 0
        black.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        self.view.addSubview(black)
        self.view.addSubview(viewShow)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            viewShow.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height - (self.view.frame.height / CGFloat(heightMultiplier)), width: self.view.frame.width, height: CGFloat(self.view.frame.height / CGFloat(heightMultiplier)))
            viewShow.alpha = 1
            black.alpha = 1
        }) { _ in
            //view.removeFromSuperview()
            viewShow.makeBorderWithCornerRadius(corners: [.topLeft,.topRight], radius: 30, borderColor: UIColor.init(hex: "#33B7DF")!, borderWidth: 1.0)
        }
    }
    
    func hideBottomSheetGeneric(viewShow:UIView,black:UIView,heightMultiplier:Double) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            viewShow.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height / CGFloat(heightMultiplier))
        }) { _ in
            //view.removeFromSuperview()
            viewShow.alpha = 0
            black.alpha = 0
        }
        
    }
    
}



public extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
