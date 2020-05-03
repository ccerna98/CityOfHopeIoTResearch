//
//  WellnessTableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class WellnessTableViewCell: UITableViewCell {

    public var colorTheme: UIColor!
    public var questionNumber: Int!
    public var question: String!
    public var isSlider: Bool!
    
    public var boolResult: Bool?
    public var sliderResult = Float(5.0)
    
    private var numberLabel = UILabel()
    private var questionLabel = UILabel()
    let yesButton = UIButton()
    let noButton = UIButton()
    let slider = UISlider()
    private let minLabel = UILabel()
    private let midLabel = UILabel()
    private let maxLabel = UILabel()
    
    var wellnessCellDelegate: WellnessTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateQuestionCell(color: UIColor, questionNum: Int, text: String, slider: Bool, yes: Bool?, sliderVal: Float) {
        colorTheme = color
        questionNumber = questionNum
        question = text
        isSlider = slider
        boolResult = yes
        sliderResult = sliderVal
        setupViews()
        setupConstraints()
    }
    
    func updateQuestion(color: UIColor, questionNum: Int, text: String, slider: Bool){
        colorTheme = color
        questionNumber = questionNum
        question = text
        isSlider = slider
        setupViews()
        setupConstraints()
    }
}

// MARK: button actions
extension WellnessTableViewCell {
    @objc func sliderSlide(_ sender: UISlider) {
        wellnessCellDelegate?.sliderInteract(sender.tag, Float(sender.value.rounded(.up)))
    }
    
    @objc func yesPressed(_ sender: UIButton) {
        wellnessCellDelegate?.yesInteract(sender.tag)
    }
    
    @objc func noPressed(_ sender: UIButton) {
        wellnessCellDelegate?.noInteract(sender.tag)
    }
}

extension WellnessTableViewCell: ViewConstraintProtocol {
    internal func setupViews() {
        
        numberLabel.setLabelParams(color: .gray, string: "\(questionNumber ?? 99).", ftype: "Arial", fsize: 16, align: .left)
        questionLabel.setLabelParams(color: .gray, string: question, ftype: "Arial", fsize: 16, align: .left)
        
        setButtonColors(bool: boolResult)

        self.addSubview(numberLabel)
        self.addSubview(questionLabel)
        
        if isSlider {
            slider.frame = CGRect(x: 0, y: 0, width: 250, height: 35)
            slider.minimumTrackTintColor = hsbShadeTint(color: colorTheme, sat: 0.3)
            slider.maximumTrackTintColor = nil
            slider.thumbTintColor = nil
            slider.maximumValue = 10
            slider.minimumValue = 0
            slider.setValue(sliderResult, animated: false)
            slider.addTarget(self, action: #selector(sliderSlide), for: .valueChanged)
            
            minLabel.setLabelParams(color: .gray, string: "0", ftype: "Arial", fsize: 14, align: .center)
            midLabel.setLabelParams(color: .gray, string: "5", ftype: "Arial", fsize: 14, align: .center)
            maxLabel.setLabelParams(color: .gray, string: "10", ftype: "Arial", fsize: 14, align: .center)
            
            self.addSubview(slider)
            self.addSubview(minLabel)
            self.addSubview(midLabel)
            self.addSubview(maxLabel)
        } else {
            slider.removeFromSuperview()
            minLabel.removeFromSuperview()
            midLabel.removeFromSuperview()
            maxLabel.removeFromSuperview()
        }
    }
    
    func setButtonColors(bool: Bool?) {
        let yesColor: UIColor!
        let noColor: UIColor!
        
        if let b = bool {
            if b {
                yesColor = hsbShadeTint(color: colorTheme, sat: 0.3)
                noColor = .gray
            } else {
                yesColor = .gray
                noColor = hsbShadeTint(color: colorTheme, sat: 0.3)
            }
        } else {
            yesColor = .gray
            noColor = .gray
        }
        
        setupCustomButtons(yesColor, noColor)
        self.addSubview(yesButton)
        self.addSubview(noButton)
    }
    
    private func setupCustomButtons(_ yesColor: UIColor, _ noColor: UIColor) {
        yesButton.setButtonParams(color: yesColor, string: "Yes", ftype: "Arial", fsize: 16, align: .center)
        yesButton.setButtonFrame(borderWidth: 1.0, borderColor: yesColor, cornerRadius: yesButton.frame.height/2, fillColor: .clear, inset: 5)
        yesButton.addTarget(self, action: #selector(yesPressed), for: .touchUpInside)
        
        noButton.setButtonParams(color: noColor, string: "No", ftype: "Arial", fsize: 16, align: .center)
        noButton.setButtonFrame(borderWidth: 1.0, borderColor: noColor, cornerRadius: noButton.frame.height/2, fillColor: .clear, inset: 5)
        noButton.addTarget(self, action: #selector(noPressed), for: .touchUpInside)
    }
    
    internal func setupConstraints() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: numberLabel.frame.height).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        noButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        noButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.topAnchor.constraint(equalTo: numberLabel.topAnchor).isActive = true
        yesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        yesButton.trailingAnchor.constraint(equalTo: noButton.leadingAnchor, constant: -10).isActive = true
        yesButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        if isSlider {
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            slider.widthAnchor.constraint(equalToConstant: slider.frame.width).isActive = true
            slider.topAnchor.constraint(equalTo: questionLabel.topAnchor, constant: 50).isActive = true
            slider.heightAnchor.constraint(equalToConstant: slider.frame.height).isActive = true
            
            minLabel.translatesAutoresizingMaskIntoConstraints = false
            minLabel.centerXAnchor.constraint(equalTo: slider.leadingAnchor).isActive = true
            minLabel.widthAnchor.constraint(equalToConstant: minLabel.frame.width).isActive = true
            minLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            minLabel.heightAnchor.constraint(equalToConstant: minLabel.frame.height).isActive = true
            
            midLabel.translatesAutoresizingMaskIntoConstraints = false
            midLabel.centerXAnchor.constraint(equalTo: slider.centerXAnchor).isActive = true
            midLabel.widthAnchor.constraint(equalToConstant: midLabel.frame.width).isActive = true
            midLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            midLabel.heightAnchor.constraint(equalToConstant: midLabel.frame.height).isActive = true
            
            maxLabel.translatesAutoresizingMaskIntoConstraints = false
            maxLabel.centerXAnchor.constraint(equalTo: slider.trailingAnchor).isActive = true
            maxLabel.widthAnchor.constraint(equalToConstant: maxLabel.frame.width).isActive = true
            maxLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
            maxLabel.heightAnchor.constraint(equalToConstant: maxLabel.frame.height).isActive = true
        }
    }
}
