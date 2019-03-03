//
//  RadioButton.swift
//
//  Created by Ahmed Moussa on 3/3/19.
// 

import UIKit

@IBDesignable class RadioButton: UIControl {
    // MARK: IB Values
    @IBInspectable public var borderWidth: CGFloat = 2
    @IBInspectable public var checkmarkSize: CGFloat = 0.4
    @IBInspectable public var uncheckedBorderColor: UIColor = UIColor.black
    @IBInspectable public var checkedBorderColor: UIColor = UIColor.black
    @IBInspectable public var checkmarkColor: UIColor = UIColor.black
    @IBInspectable public var checkboxBackgroundColor: UIColor = .white
    @IBInspectable public var increasedTouchRadius: CGFloat = 5
    
    public var valueChanged: ((_ isChecked: Bool) -> Void)?
    
    public var isChecked: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var useHapticFeedback: Bool = true
    // MARK: Varibles
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    // MARK: init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaults()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDefaults()
    }
    
    private func setupDefaults() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        addGestureRecognizer(tapGesture)
        
        if (self.useHapticFeedback) {
            self.feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            self.feedbackGenerator?.prepare()
        }
    }
    
    // MARK: Draw
    override public func draw(_ rect: CGRect) {
        let adjustedRect = CGRect(x: (self.borderWidth / 2), y: (self.borderWidth / 2), width: (rect.width - self.borderWidth), height: (rect.height - self.borderWidth))
        self.circleBorder(rect: adjustedRect)
        if (self.isChecked) {
            let checkMarkAdjustedRect = self.checkmarkRect(in: rect)
            self.circleCheckmark(rect: checkMarkAdjustedRect)
        }
    }
    
    private func circleBorder(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        if (self.isChecked) {
            self.checkedBorderColor.setStroke()
        } else {
            self.uncheckedBorderColor.setStroke()
        }
        
        ovalPath.lineWidth = self.borderWidth / 2
        ovalPath.stroke()
        self.checkboxBackgroundColor.setFill()
        ovalPath.fill()
    }
    
    // MARK: Draw - Checkmark
    private func checkmarkRect(in rect: CGRect) -> CGRect {
        let width = rect.maxX * self.checkmarkSize
        let height = rect.maxY * self.checkmarkSize
        let adjustedRect = CGRect(x: (rect.maxX - width) / 2, y: (rect.maxY - height) / 2, width: width, height: height)
        return adjustedRect
    }
    
    private func circleCheckmark(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        self.checkmarkColor.setFill()
        ovalPath.fill()
    }
    
    @objc private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        self.isChecked = !self.isChecked
        self.valueChanged?(self.isChecked)
        sendActions(for: .valueChanged)
        
        if (self.useHapticFeedback) {
            // Trigger impact feedback.
            self.feedbackGenerator?.impactOccurred()
            // Keep the generator in a prepared state.
            self.feedbackGenerator?.prepare()
        }
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.insetBy(dx: -self.increasedTouchRadius * 2, dy: -self.increasedTouchRadius * 2)
        return hitFrame.contains(point)
    }
}
