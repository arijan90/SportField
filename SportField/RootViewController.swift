//
//  RootViewController.swift
//  SportField
//
//  Created by Arijan Ljoki on 29. 05. 16.
//  Copyright © 2016 Arijan Ljoki. All rights reserved.
//

import Foundation
import UIKit


protocol MatchPitchProtocol {
    func setResultForHome(home: NSNumber, andAway away: NSNumber)
}

class RootViewController: UIViewController {
    
    enum FieldIndex: Int {
        case FootballTab = 0
        case BasketballTab
        case TennisTab
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeScoreTextField: UITextField!
    @IBOutlet weak var awayScoreTextField: UITextField!
    
    weak var currentViewController: FieldViewController?
    
    lazy var footballVC: FootballFieldViewController? = {
        let footballVC = self.storyboard?.instantiateViewControllerWithIdentifier(FootballFieldViewController.identifier) as! FootballFieldViewController
        return footballVC
    }()
    lazy var basketballVC : BasketballFieldViewController? = {
        let basketballVC = self.storyboard?.instantiateViewControllerWithIdentifier(BasketballFieldViewController.identifier) as! BasketballFieldViewController
        return basketballVC
    }()
    lazy var tennisVC : TennisFieldViewController? = {
        let tennisVC = self.storyboard?.instantiateViewControllerWithIdentifier(TennisFieldViewController.identifier) as! TennisFieldViewController
        return tennisVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = FieldIndex.FootballTab.rawValue
        displayCurrentTab(FieldIndex.FootballTab.rawValue)
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func unregisterFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: Outlet connections
    @IBAction func fieldChanged(sender: AnyObject) {
        
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        guard let home = Int(homeScoreTextField.text!) else {
            return
        }
        
        guard let away = Int(awayScoreTextField.text!) else {
            return
        }
        
        currentViewController?.setResultForHome(home, andAway: away)
    }
    
    // MARK: Private
    private func displayCurrentTab(tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            vc.didMoveToParentViewController(self)
            self.addChildViewController(vc)
            
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    private func viewControllerForSelectedSegmentIndex(index: Int) -> FieldViewController? {
        var vc: FieldViewController?
        switch index {
        case FieldIndex.FootballTab.rawValue :
            vc = footballVC
        case FieldIndex.BasketballTab.rawValue :
            vc = basketballVC
        case FieldIndex.TennisTab.rawValue :
            vc = tennisVC
        default:
            return nil
        }
        
        return vc
    }
    
    // MARK: Handling keyboard notifications
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardView: UIView = parentViewController?.view ?? view
        
        let info = notification.userInfo!
        let keyboardScreenEndFrame = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let keyboardViewEndFrame = keyboardView.convertRect(keyboardScreenEndFrame!, fromView: keyboardView)
        let keyboardFrame = CGRectIntersection(keyboardView.bounds, keyboardViewEndFrame)
        let keyboardHeight = keyboardFrame.size.height
        
        keyboardHeightWillChange(keyboardHeight, animationDuration: duration!)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationCurveUserInfoKey]?.doubleValue
        keyboardHeightWillChange(0, animationDuration: duration!)
    }
    
    func keyboardHeightWillChange(keyboardHeight: CGFloat, animationDuration: Double) {
        if automaticallyAdjustsScrollViewInsets {
            var inset = scrollView.contentInset
            inset.bottom = keyboardHeight
            scrollView.contentInset = inset
            scrollView.scrollIndicatorInsets = inset
        }
    }
}