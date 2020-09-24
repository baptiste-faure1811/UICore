//
//  Banner.swift
//  UIKit+
//
//  Created by Baptiste Faure on 23/09/2020.
//

import UIKit

public final class UIBanner : UIView {
    
    private let alertBackground = UIColor(named: "alertBackground")
    private var keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    private var type : BannerType = .message
    public static var defaultTintColor : UIColor = .systemBlue
    
    // Init Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    /// Create an instance of UIBanner.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - image: The optional image that will appear next to the message.
    ///   - type: The type of the banner.
    public init(message: String, image: UIImage? = nil, type: BannerType = .message) {
        super.init(frame: CGRect.zero)
        self.label.setTitle("  " + message + "  ", for: .normal)
        self.label.setImage(image?.applyingSymbolConfiguration(.init(textStyle: .headline, scale: .large)), for: .normal)
        self.type = type
        setUpView()
    }
    
    /// The type of the banner - changes the color and the haptic feedback intensity
    public enum BannerType {
        case message
        case info
        case warning
        case alert
    }
    
    private let label : MultiLineButton = {
        let label = MultiLineButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        label.titleLabel?.adjustsFontForContentSizeCategory = true
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.numberOfLines = 0
        label.isUserInteractionEnabled = false
        return label
    }()
    
    // Set up the view
    private func setUpView() {
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let backView = UIView()
        backView.alpha = 0.8
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backView)
        backView.anchorSize(to: self)
        
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurredEffectView)
        blurredEffectView.anchorSize(to: self)
        
        switch self.type {
        case .message:
            backView.backgroundColor = UIBanner.defaultTintColor
            label.setTitleColor(UIBanner.defaultTintColor, for: .normal)
            label.tintColor = UIBanner.defaultTintColor
        case .alert:
            backView.backgroundColor = .systemRed
            label.setTitleColor(.systemRed, for: .normal)
            label.tintColor = .systemRed
        case .info:
            backView.backgroundColor = .systemBlue
            label.setTitleColor(.systemBlue, for: .normal)
            label.tintColor = .systemBlue
        case .warning:
            backView.backgroundColor = .systemOrange
            label.setTitleColor(.systemOrange, for: .normal)
            label.tintColor = .systemOrange
        }

        self.addSubview(label)
        label.layoutIfNeeded()
        label.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 12, left: 20, bottom: 12, right: 20))
    }
    
    /// Shows the banner on the key window.
    /// - Parameters:
    ///   - duration: The duration before the banner disappears. Default is 1.2.
    ///   - delay: The delay before displaying the banner. Default is 0.2.
    ///   - hapticFeedback: If true the banner will produce a haptic feedback when displayed. Default is false.
    ///   - hapticIntensity: The haptic feedback intensity. Default is based on banner type (.info and .message -> light, .warning and .error -> error).
    ///   - completion: Called when the banner disappeared.
    /// - Returns: completion block called when banner will disappear
    public func showBanner(duration: Double = 1.2, delay: Double = 0.2, hapticFeedback: Bool = false, completion: @escaping (()->()) = {}) {
        
        if let keyWindow = self.keyWindow {
            // Add to subview
            keyWindow.addSubview(self)
            self.leadingAnchor.constraint(greaterThanOrEqualTo: keyWindow.leadingAnchor, constant: 20).isActive = true
            self.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
            let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
            width.priority = UILayoutPriority(rawValue: 1000)
            width.isActive = true
            
            layoutIfNeeded()
            layoutSubviews()
            
            alpha = 0
            transform = transform.scaledBy(x: 0.8, y: 0.8)
            
            
            // Animate to show
            UIView.animate(withDuration: 0.3, delay: delay, animations: {
                if hapticFeedback {
                    switch self.type {
                    case .alert:
                        UINotificationFeedbackGenerator.init().notificationOccurred(.error)
                        break
                    case .warning:
                        UIImpactFeedbackGenerator.init(style: .heavy).impactOccurred()
                        break
                    case .info, .message:
                        UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
                        break
                    }
                }
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }, completion: { [self] _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    self.dismiss()
                    completion()
                }
            })
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }

}


public final class MultiLineButton: UIButton {

    override public var intrinsicContentSize: CGSize {
        get {
            if let title = titleLabel {
                return CGSize(width: title.intrinsicContentSize.width, height: title.intrinsicContentSize.height+5)
            } else {
                return .zero
            }
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.size.width ?? 0
        super.layoutSubviews()
    }

}
