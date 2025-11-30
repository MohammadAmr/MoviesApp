//
//  InfoChipView.swift
//  MoviesApp
//
//  Created by Mohamed Amr ElSaeed, Vodafone on 30/11/2025.
//

import UIKit

final class InfoChipView: UIView {

    private let iconView = UIImageView()
    private let textLabel = UILabel()

    init(iconName: String, tintColor: UIColor) {
        super.init(frame: .zero)
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = tintColor
        iconView.contentMode = .scaleAspectFit

        textLabel.font = .systemFont(ofSize: 13, weight: .medium)
        textLabel.textColor = .label

        let stack = UIStackView(arrangedSubviews: [iconView, textLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        backgroundColor = UIColor.secondarySystemBackground

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            iconView.widthAnchor.constraint(equalToConstant: 14),
            iconView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
}
