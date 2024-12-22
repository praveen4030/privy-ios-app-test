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
        
        let sendOtpButton = UIButton(type: .system)
        sendOtpButton.frame = CGRect(x: 20, y: 290, width: 280, height: 40)
        sendOtpButton.setTitle("Send OTP", for: .normal)
        sendOtpButton.addTarget(self, action: #selector(sendOtp), for: .touchUpInside)
        view.addSubview(sendOtpButton)
        
        let verifyOtpButton = UIButton(type: .system)
        verifyOtpButton.frame = CGRect(x: 20, y: 340, width: 280, height: 40)
        verifyOtpButton.setTitle("Verify OTP", for: .normal)
        verifyOtpButton.addTarget(self, action: #selector(verifyOtp), for: .touchUpInside)
        view.addSubview(verifyOtpButton)
        
        let generateEvmWalletButton = UIButton(type: .system)
        generateEvmWalletButton.frame = CGRect(x: 20, y: 390, width: 280, height: 40)
        generateEvmWalletButton.setTitle("Generate EVM Wallet", for: .normal)
        generateEvmWalletButton.addTarget(self, action: #selector(generateEvmWallet), for: .touchUpInside)
        view.addSubview(generateEvmWalletButton)

        let generateSolanaWalletButton = UIButton(type: .system)
        generateSolanaWalletButton.frame = CGRect(x: 20, y: 440, width: 280, height: 40)
        generateSolanaWalletButton.setTitle("Generate Solana Wallet", for: .normal)
        generateSolanaWalletButton.addTarget(self, action: #selector(generateSolanaWallet), for: .touchUpInside)
        view.addSubview(generateSolanaWalletButton)

        let getWalletsButton = UIButton(type: .system)
        getWalletsButton.frame = CGRect(x: 20, y: 490, width: 280, height: 40)
        getWalletsButton.setTitle("Get Wallets", for: .normal)
        getWalletsButton.addTarget(self, action: #selector(getWallets), for: .touchUpInside)
        view.addSubview(getWalletsButton)
        
        let logoutButton = UIButton(type: .system)
        logoutButton.frame = CGRect(x: 20, y: 540, width: 280, height: 40)
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    @objc private func initializePrivy() {
        PrivyHelper.initializePrivy("clv6fw8s306zb9ubei8siuud9", "client-WY2kGjAV9PduKgHvw16ZbZqqk8HPSPCBaeBFQiEw79YMu")
        // Update the status label
        statusLabel.text = "Initialization Called"
    }
    
    @objc private func sendOtp() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter an email")
            return
        }
        PrivyHelper.sendOTP(email)
        // Update to reflect OTP sent
        isOtpSent = true
        otpTextField.isHidden = false
        showAlert(message: "OTP Sent")
    }
    
    @objc private func verifyOtp() {
        guard let email = emailTextField.text, !email.isEmpty,
              let otp = otpTextField.text, !otp.isEmpty else {
            showAlert(message: "Please enter both email and OTP")
            return
        }
        PrivyHelper.authenticateWithOtp(email, otp)
        showAlert(message: "OTP Verified")
    }
    
    @objc private func generateEvmWallet() {
        PrivyHelper.generateEvmWallet()
        showAlert(message: "EVM Wallet Generation Initiated")
    }
    
    @objc private func generateSolanaWallet() {
        PrivyHelper.generateSolanaWallet()
        showAlert(message: "Solana Wallet Generation Initiated")
    }
    
    @objc private func getWallets() {
        PrivyHelper.getWallets()
        showAlert(message: "Wallet Retrieval Called")
    }
    
    @objc private func logout() {
        PrivyHelper.logout()
        showAlert(message: "Logged Out")
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Privy", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
