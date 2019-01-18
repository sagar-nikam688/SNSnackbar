//
//  SNSnackbar.swift
//  SNSnackbar
//
//  Created by sagar.nikam on 18/01/19.
//  Copyright © 2019 sagar.nikam. All rights reserved.
//

import UIKit

public class SNSnackbar: UIView {

    @IBOutlet private weak var headingTextLabel: UILabel!
    @IBOutlet private weak var subTitleTextLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let nibName = "SNSnackbar"
    var contentView: UIView!
    var timer: Timer?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(onScreenRotateNotification),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        let superViewWidth = (superview?.frame.width)
        let superViewTop = UIApplication.shared.statusBarFrame.height
        self.contentView.frame = CGRect(x: 0, y: superViewTop, width: superViewWidth ?? UIApplication.shared.keyWindow?.bounds.width ?? 300, height: 90)
        addSubview(contentView)
           // To get View in Center of SuperView
        //contentView.center = self.center
        //contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        headingTextLabel.text = ""
        subTitleTextLabel.text = ""
        self.containerView.backgroundColor = .clear
    }
    
//    public func set(image: UIImage) {
//        self.statusImage.image = image
//    }
    
    public func set(headline text: String) {
        self.headingTextLabel.text = text
    }
    public func set(subheading text: String) {
        self.subTitleTextLabel.text = text
    }
    public func set(setContainer_BackgroundColor color: UIColor) {
        self.containerView.backgroundColor = color
    }
    
    public override func didMoveToSuperview() {
        UIView.animate(withDuration: 0.15, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 5, options: .allowUserInteraction,
                       animations: {
                        () -> Void in
                        self.timer = Timer.scheduledTimer(
                            timeInterval: TimeInterval(2.0),
                            target: self,
                            selector: #selector(self.removeSelf),
                            userInfo: nil,
                            repeats: false)
                        self.superview?.layoutIfNeeded()
        }, completion: nil)

    }
    @objc private func removeSelf() {
        // Animate removal of view
        UIView.animate(withDuration: 0.15, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 5, options: .allowUserInteraction,
                       animations: {
                        () -> Void in
                        self.removeFromSuperview()
                        self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }
    





    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
private extension SNSnackbar {
    @objc func onScreenRotateNotification() {
        let superViewWidth = (superview?.frame.width)
        self.contentView.frame = CGRect(x: 0, y: 40, width: superViewWidth ?? UIApplication.shared.keyWindow?.bounds.width ?? 300, height: 90)
        layoutIfNeeded()
    }
}
