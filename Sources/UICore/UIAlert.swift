//
//  UIAlert.swift
//  UIKit+
//
//  Created by Baptiste Faure on 23/09/2020.
//

import UIKit

public final class UIAlert : UIView {
    public init(keyWindow: UIWindow? = UIApplication.shared.windows.first { $0.isKeyWindow }, color: UIColor = .accentColor, buttons: [MultiLineButton] = []) {
        self.keyWindow = keyWindow
        self.color = color
        self.buttons = buttons
        super.init(frame: .zero)
    }
    
    
    private var keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    
    // Init Methods 
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private var color : UIColor = .accentColor
    
    /// Create an instance of UIBanner.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - icon: The icon that will appear next to the message. Default is nil.
    ///   - type: The type of the banner.
    public init(title: String, message: String, dismissButtonTitle: String, dismissButtonTintColor: UIColor? = .accentColor) {
        super.init(frame: CGRect.zero)
        self.titleLabel.text = title
        self.bodyLabel.text = message
        self.button.setTitle(dismissButtonTitle, for: .normal)
        self.color = dismissButtonTintColor ?? .accentColor
        setUpView()
    }
    
    private let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Alert title"
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel : UILabel = {
        let label = UILabel()
        label.text = "Alert body"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let button : MultiLineButton = {
        let btn = MultiLineButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout).bold()
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("Alert button", for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private var buttons : [MultiLineButton] = []
    
    public func addButton(title: String, action: UIAction, buttonTintColor: UIColor? = .accentColor) {
        let passedButton = MultiLineButton(type: .system)
        passedButton.setTitle(title, for: .normal)
        passedButton.addAction(action, for: .touchUpInside)
        passedButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertArrangedSubview(passedButton, at: 0)
        passedButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 38).isActive = true
        passedButton.backgroundColor = buttonTintColor?.withAlphaComponent(0.25)
        passedButton.setTitleColor(buttonTintColor, for: .normal)
        layoutButtons()
    }
    
    private func layoutButtons() {
        for view in stackView.arrangedSubviews {
            if let view = view as? MultiLineButton {
                view.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout).bold()
                view.titleLabel?.adjustsFontForContentSizeCategory = true
                view.titleLabel?.textAlignment = .center
                view.titleLabel?.numberOfLines = 0
                view.layer.cornerRadius = 10
                view.addAction(UIAction(handler: { _ in
                    self.dismiss()
                }), for: .touchUpInside)
            }
        }
        stackView.axis = stackView.arrangedSubviews.count > 2 ? .vertical : .horizontal
    }
    
    public func setDismissButtonAction(action: UIAction) {
        self.button.addAction(action, for: .touchUpInside)
    }
    
    private func setUpView() {
        
        self.backgroundColor = .alertBackground
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 12, left: 16, bottom: 0, right: 16))
        
        self.addSubview(bodyLabel)
        bodyLabel.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        self.addSubview(stackView)
        stackView.anchor(top: bodyLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 15, left: 10, bottom: 10, right: 10))
        
        stackView.addArrangedSubview(button)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 38).isActive = true
        button.addAction(UIAction(handler: { _ in
            self.dismiss()
        }), for: .touchUpInside)
        button.backgroundColor = self.color.withAlphaComponent(0.25)
        button.setTitleColor(self.color, for: .normal)
    }
    
    
    public func showAlert(completion: @escaping (()->()) = {}) {
        
        if stackView.axis == .horizontal {
            stackView.removeArrangedSubview(button)
            stackView.insertArrangedSubview(button, at: 0)
        } else {
            stackView.removeArrangedSubview(button)
            stackView.insertArrangedSubview(button, at: stackView.arrangedSubviews.count)
        }
        
        if let keyWindow = self.keyWindow {
            
            keyWindow.addSubview(backgroundView)
            backgroundView.anchorSize(to: keyWindow)
            
            keyWindow.addSubview(self)
            self.leadingAnchor.constraint(greaterThanOrEqualTo: keyWindow.leadingAnchor, constant: 20).isActive = true
            self.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 285)
            width.priority = UILayoutPriority(rawValue: 1000)
            width.isActive = true
            
            layoutIfNeeded()
            layoutSubviews()
            
            alpha = 0
            transform = transform.scaledBy(x: 0.8, y: 0.8)
            
            // Animate to show
            UIView.animate(withDuration: 0.22, delay: 0.0, animations: {
                self.backgroundView.alpha = 0.45
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }, completion: { _ in
                completion()
            })
        }
        
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.22, animations: {
            self.backgroundView.alpha = 0
            self.alpha = 0
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { finished in
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
    }
}
