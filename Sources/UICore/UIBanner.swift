//
//  Banner.swift
//  UIKit+
//
//  Created by Baptiste Faure on 23/09/2020.
//

import UIKit

public final class UIBanner : UIView {
    public init(keyWindow: UIWindow? = UIApplication.shared.windows.first { $0.isKeyWindow }, type: UIBanner.BannerType = .message) {
        self.keyWindow = keyWindow
        self.type = type
        super.init(frame: .zero)
    }
    
    
    private var keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    private var type : BannerType = .message
    
    /// The type of the banner - changes the color and the haptic feedback intensity
    public enum BannerType {
        case info
        case warning
        case alert
        case message
    }
    
    public enum HapticIntensity {
        case defaultLight
        case defaultError
        case heavy
    }
    
    private let label : MultiLineButton = {
        let label = MultiLineButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        label.titleLabel?.adjustsFontForContentSizeCategory = true
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.numberOfLines = 0
        label.setTitleColor(.accentColor, for: .normal)
        label.isUserInteractionEnabled = false
        return label
    }()
    
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
    ///   - icon: The icon that will appear next to the message. Default is nil.
    ///   - type: The type of the banner.
    public init(message: String, icon: UIImage? = nil, type: BannerType = .message) {
        super.init(frame: CGRect.zero)
        self.label.setTitle("  " + message, for: .normal)
        self.label.setImage(icon?.applyingSymbolConfiguration(.init(textStyle: .headline, scale: .large)), for: .normal)
        self.type = type
        setUpView()
    }
    
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
        case .alert:
            backView.backgroundColor = .systemRed
            label.setTitleColor(.systemRed, for: .normal)
            label.tintColor = .systemRed
        case .info:
            backView.backgroundColor = .link
            label.setTitleColor(.link, for: .normal)
            label.tintColor = .link
        case .warning:
            backView.backgroundColor = .systemOrange
            label.setTitleColor(.systemOrange, for: .normal)
            label.tintColor = .systemOrange
        default:
            backView.backgroundColor = .accentColor
            label.setTitleColor(.accentColor, for: .normal)
            label.tintColor = .accentColor
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
    public func showBanner(duration: Double = 1.2, delay: Double = 0.2, hapticFeedback: Bool = false, hapticIntensity: HapticIntensity? = nil, completion: @escaping (()->()) = {}) {
        
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
                    self.hapticRequired(hapticIntensity: hapticIntensity)
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
    
    private func hapticRequired(hapticIntensity: HapticIntensity?) {
        if hapticIntensity == nil {
            switch self.type {
            case .alert, .warning:
                UINotificationFeedbackGenerator.init().notificationOccurred(.error)
                break
            case .info, .message:
                UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
                break
            }
        } else {
            switch hapticIntensity {
            case .defaultLight:
                UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
                break
            case .defaultError:
                UINotificationFeedbackGenerator.init().notificationOccurred(.error)
                break
            case .heavy:
                UIImpactFeedbackGenerator.init(style: .heavy).impactOccurred()
                break
            default:
                UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
                break
            }
        }
        
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }

}


public class MultiLineButton: UIButton {

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
    
    
    public var originalButtonText: String?
    public var activityIndicator: UIActivityIndicatorView!

    public func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    public func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
