import Foundation
import PrivySDK

class PrivyHelper {
    static var privy: Privy?
    
    static func initializePrivy(_ appId: String,_ clientId: String) {
        do {
            let config = PrivyConfig(appId: appId, appClientId: clientId)
            privy = PrivySdk.initialize(config: config)
            guard let privy = privy else {
                return
            }
            privy.embeddedWallet.setEmbeddedWalletStateChangeCallback { state in
                print("Privy embedded wallet state is: \(state)")
            }
            privy.setAuthStateChangeCallback { state in
                print("Privy auth state changed: \(state)")
            }
        }
    }
    
    static func logout() {
        guard let privy = privy else {
            return
        }
        Task {
            do {
                await privy.logout()
                print("Privy user logged out")
            }
        }
    }
    
    static func sendOTP(_ emailId: String) {
        guard let privy = privy else {
            return
        }
        
        Task {
            do {
                let otpSentSuccessfully: Bool = await privy.email.sendCode(to: emailId)
       
            }
        }
    }
    
    static func authenticateWithOtp(_ emailId: String,_ otp: String) {
        guard let privy = privy else {
            return
        }
        
        Task {
            do {
                let authState = try await privy.email.loginWithCode(otp, sentTo: emailId)
                if case .authenticated(_) = authState {
                    return;
                }
            } catch {
            }
        }
    }
    
    static func generateEvmWallet() {
        guard let privy = privy else {
            return
        }
        
        Task {
            do {
                let ethereumWallet = try await privy.embeddedWallet.createWallet(chainType: .ethereum)
                print("Privy embedded wallet address is: \(ethereumWallet.address)")
            } catch {
                print("evm wallet error: \(error)")
            }
        }
    }
    
    static func generateSolanaWallet() {
        guard let privy = privy else {
            return
        }
        
        Task {
            do {
                let solanaEmbeddedWallet = try await privy.embeddedWallet.createWallet(chainType: .solana)
                print("Privy created slana wallet: \(solanaEmbeddedWallet.address)")
            } catch {
                print("Privy solana wallet error: \(error)")
            }
        }
    }
    
    static func getWallets() {
        guard let privy = privy else {
            return
        }
        
        Task {
            // Fetch wallets from the SDK or some service
            do {
                guard case .authenticated = privy.authState else {
                    return
                }
                try await privy.refreshSession();
                try await privy.embeddedWallet.connectWallet()
                // Assuming 'getWallets()' is a method that fetches a list of wallets
                        // ensure user is authenticated first
                guard case .connected(let wallets) = privy.embeddedWallet.embeddedWalletState else {
                    print("Privy Wallets not connected")
                    return
                }
                print("Privy Wallets list: \(wallets)")
                try await privy.embeddedWallet.connectWallet()
                // If that succeed, check embedded wallet state again
                if case .connected(let wallets) = privy.embeddedWallet.embeddedWalletState {
                    var ethereumWalletAddress: String? = nil
                    var solanaWalletAddress: String? = nil

                    if let ethereumWallet = wallets.first(where: { $0.chainType == .ethereum }) {
                        print("User's Ethereum wallet: \(ethereumWallet)")
                        ethereumWalletAddress = ethereumWallet.address
                    }

                    if let solanaWallet = wallets.first(where: { $0.chainType == .solana }) {
                        print("User's Solana wallet: \(solanaWallet)")
                        solanaWalletAddress = solanaWallet.address
                    }
                } else {
                    // wallets still not connected, throw an error
                    throw PrivyEmbeddedWalletError.walletNotConnected
                }
            } catch {
            }
        }
    }
    
    static func sendEthTransaction(_ method: String,_ txString: String) {
        guard let privy = privy else {
            return
        }
        // ensure user is authenticated first
        guard case .connected(let wallets) = privy.embeddedWallet.embeddedWalletState else {
            print("Wallet not connected")
            return
        }
        
        guard let wallet = wallets.first, wallet.chainType == .ethereum else {
              print("No Ethereum wallets available")
              return
          }
        print("here is wallets list: \(wallets) wallet: \(wallet)")
        let ethereumWalletAddress = wallets.first(where: { $0.chainType == .ethereum })
        
        Task {
            do {
                let provider = try privy.embeddedWallet.getEthereumProvider(for: wallet.address)
                let transactionHash = try await provider.request(
                    RpcRequest(
                        method: method,
                        params: [txString]
                    )
                )
                debugPrint("wallet: \(transactionHash)") // Print the latency
            } catch {
            }
        }
    }
    
    static func sendSolanaTransaction(_ method: String,_ txString: String) {
        guard let privy = privy else {
            return
        }
        // ensure user is authenticated first
        guard case .connected(let wallets) = privy.embeddedWallet.embeddedWalletState else {
            print("Wallet not connected")
            return
        }
        
        guard let wallet = wallets.first, wallet.chainType == .solana else {
              print("No Ethereum wallets available")
              return
          }
        print("here is wallets list: \(wallets) wallet: \(wallet)")
        
        Task {
            do {
                let provider = try privy.embeddedWallet.getSolanaProvider(for: wallet.address)
                // let transactionHash = try await solana.sendTransaction(transaction: txString)
                // debugPrint("wallet: \(transactionHash)") // Print the latency
            } catch {
                print("error in solana send transaction: \(error)")
            }
        }
    }
}
