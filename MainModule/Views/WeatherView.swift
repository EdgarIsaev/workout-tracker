//
//  WeatherView.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 22.02.2023.
//

import UIKit


class WeatherView: UIView {
    
    private let weatherTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Cолнечно"
        titleLabel.font = .robotoMedium18()
        titleLabel.textColor = .specialGray
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let descriptionWeatherLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Хорошая погода, чтобы позаниматься на улице"
        descriptionLabel.font = .robotoMedium14()
        descriptionLabel.textColor = .specialGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Sun")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        addShadowOnView()
        
        addSubview(weatherTitleLabel)
        addSubview(descriptionWeatherLabel)
        addSubview(weatherImage)
    }
    
    public func updateImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        weatherImage.image = image
    }
    
    func updateLabels(model: WeatherModel) {
        weatherTitleLabel.text = model.weather[0].myDescription + " \(model.main.temperatureCelsius)°C"
        
        switch model.weather[0].weatherDescription {
        case "clear sky":
            descriptionWeatherLabel.text = "Отличная погода для тренировки на улице"
        case "few clouds":
            descriptionWeatherLabel.text = "Отличная погода для тренировки на улице"
        case "scattered clouds":
            descriptionWeatherLabel.text = "Отличная погода для тренировки на улице"
        case "broken clouds":
            descriptionWeatherLabel.text = "Неплохая погода для тренировки на улице"
        case "shower rain":
            descriptionWeatherLabel.text = "Не самая лучшая погода для тренировки на улице"
        case "rain":
            descriptionWeatherLabel.text = "Не самая лучшая погода для тренировки на улице"
        case "thunderstorm":
            descriptionWeatherLabel.text = "Не самая лучшая погода для тренировки на улице"
        case "snow":
            descriptionWeatherLabel.text = "Отличная погода для тренировки на улице"
        case "mist":
            descriptionWeatherLabel.text = "Отличная погода для тренировки на улице"
        case "overcast clouds":
            descriptionWeatherLabel.text = "Не самая лучшая погода для тренировки на улице"
        case "shower snow":
            descriptionWeatherLabel.text = "Не самая лучшая погода для тренировки на улице"
        default:
            descriptionWeatherLabel.text = "У природы нет плохой погоды"
        }
    }
}

extension WeatherView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            weatherTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherTitleLabel.bottomAnchor.constraint(equalTo: descriptionWeatherLabel.topAnchor, constant: 0),
            weatherTitleLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -5),
            
            descriptionWeatherLabel.topAnchor.constraint(equalTo: weatherTitleLabel.bottomAnchor, constant: 0),
            descriptionWeatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionWeatherLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            descriptionWeatherLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -5),
            
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImage.widthAnchor.constraint(equalToConstant: 60),
            weatherImage.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
