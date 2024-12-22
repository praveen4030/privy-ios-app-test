import UIKit

class PrivyViewController: UIViewController {
    private var emailTextField: UITextField!
    private var otpTextField: UITextField!
    private var statusLabel: UILabel!
    private var isOtpSent = false
    private var isInitialized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Privy UI"
        
        setupUI()
    }
    
    private func setupUI() {
        statusLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 30))
        statusLabel.text = "Privy SDK not initialized"
        view.addSubview(statusLabel)
        
        emailTextField = UITextField(frame: CGRect(x: 20, y: 140, width: 280, height: 40))
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        view.addSubview(emailTextField)
        
        otpTextField = UITextField(frame: CGRect(x: 20, y: 190, width: 280, height: 40))
        otpTextField.placeholder = "OTP"
        otpTextField.borderStyle = .roundedRect
        otpTextField.isHidden = true
        view.addSubview(otpTextField)
        
        let initializeButton = UIButton(type: .system)
        initializeButton.frame = CGRect(x: 20, y: 240, width: 280, height: 40)
        initializeButton.setTitle("Initialize Privy", for: .normal)
        initializeButton.addTarget(self, action: #selector(initializePrivy), for: .touchUpInside)
        view.addSubview(initializeButton)
        
        // Add more buttons: Send OTP, Verify OTP, etc.
        // Each button should have a corresponding action method.
    }
    
    @objc private func initializePrivy() {
        // Dummy function - replace with real initialization logic
        // Assuming we have a PrivyHelper class that handles the initialization
        PrivyHelper.initializePrivy(appId: "YourAppId", clientId: "YourClientId") { [weak self] success in
            DispatchQueue.main.async {
                self?.isInitialized = success
                self?.statusLabel.text = success ? "Privy SDK initialized" : "Initialization failed"
            }
        }
    }
    
    // Example method for sending OTP
    @objc private func sendOtp() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter an email")
            return
        }
        PrivyHelper.sendOTP(email) { [weak self] success in
            DispatchQueue.main.async {
                self?.isOtpSent = success
                self?.otpTextField.isHidden = !success
                self?.showAlert(message: success ? "OTP sent" : "Failed to send OTP")
            }
        }
    }
    
    // Helper function for showing alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Privy", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Additional functions for OTP verification, wallet operations, etc.
}