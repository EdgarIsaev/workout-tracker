//
//  SliderView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 06.03.2023.
//

import UIKit

protocol SliderViewProtocol: AnyObject {
    func changeValue(type: SliderTypes, value: Int)
}

class SliderView: UIView {
    
    weak var delegate: SliderViewProtocol?
    
    private let numberLabel = UILabel(text: "0",
                                          font: .robotoMedium24(),
                                          textColor: .specialGray)
    
    private let nameLabel = UILabel(text: "name",
                                     font: .robotoMedium18(),
                                     textColor: .specialGray)
    
    private lazy var slider = GreenSlider()
    
    private var stackView = UIStackView()
    
    private var sliderType: SliderTypes?
    
    public var isActive: Bool = true {
        didSet {
            if self.isActive {
                nameLabel.alpha = 1
                numberLabel.alpha = 1
                slider.alpha = 1
            } else {
                nameLabel.alpha = 0.5
                numberLabel.alpha = 0.5
                slider.alpha = 0.5
                slider.value = 0
                numberLabel.text = "0"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String, minimumValue: Float, maximumValue: Float, type: SliderTypes) {
        self.init(frame: .zero)
        nameLabel.text = name
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        sliderType = type
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        let labelStackView = UIStackView(arrangedSubViews: [nameLabel, numberLabel],
                                         axis: .horizontal,
                                         spacing: 10)
        labelStackView.distribution = .equalSpacing
        stackView = UIStackView(arrangedSubViews: [labelStackView, slider],
                                axis: .vertical,
                                spacing: 5)
        addSubview(stackView)
    }
    
    @objc private func sliderChanged() {
        let intValueSlider = (Int(slider.value))
        numberLabel.text = sliderType == .timer ? intValueSlider.getTimeFromSeconds() : "\(intValueSlider)"
        guard let type = sliderType else { return }
        delegate?.changeValue(type: type, value: intValueSlider)
    }
    
    public func resetValues() {
        numberLabel.text = "0"
        slider.value = 0
        isActive = true
    }
}

extension SliderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
