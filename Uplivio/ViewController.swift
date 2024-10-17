//
//  ViewController.swift
//  Uplivio
//
//  Created by Sümeyra Demirtaş on 10/15/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    // Custom color for background
    let peachColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0)

    // Motivational message label
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading motivational message..."
        label.textAlignment = .center
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()



    // OpenAPIService
    let openAPIService = OpenAPIService()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        setupUI()
        fetchDailyMotivationMessage()
//        fetchBackgroundImage()
    }

    // MARK: - Functions
    


    // Fetch Motivational Message
    func fetchDailyMotivationMessage() {
        openAPIService.fetchMotivationalMessage { [weak self] message in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let message = message {
                    self.updateMessageLabel(with: message)
                } else {
                    self.updateMessageLabel(with: "Failed to fetch message")
                }
            }
        }
    }

    // Update Message Label
    func updateMessageLabel(with message: String) {
        messageLabel.text = message
    }

    

}





//--------------------------------------------------------
/* Cancelled.
// Background Image
let backgroundImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
}()
 */


/* Cancelled.
// Fetch Background Image
func fetchBackgroundImage() {
    openAPIService.generateBackgroundImage { [weak self] image in
        DispatchQueue.main.async {
            if let image = image {
                self?.backgroundImage.image = image
            } else {
                print("Failed to set background image")
            }
        }
    }
}
 */

/* Cancelled. It includes background image.
// Setup UI
func setupUI() {
    view.addSubview(backgroundImage)


    NSLayoutConstraint.activate([
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    view.sendSubviewToBack(backgroundImage)

    view.addSubview(messageLabel)

    NSLayoutConstraint.activate([
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
    ])
}
 */
