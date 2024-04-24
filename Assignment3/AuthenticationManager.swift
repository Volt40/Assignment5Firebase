import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthenticationManager {
    func authenticate(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let usersRef = FirebaseManager.shared.db.collection("users")
        let userDocRef = usersRef.document("2fqmeWAfxK2FAhP4p7cH")
        userDocRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document:", error.localizedDescription)
                completion(false, error)
                return
            }
            guard let document = document, document.exists else {
                print("User document not found")
                let authenticationError = NSError(domain: "Authentication", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                completion(false, authenticationError)
                return
            }
            if let storedPassword = document.data()?["password"] as? String, storedPassword == password {
                // Passwords match, authentication successful
                print("Authentication successful")
                completion(true, nil)
            } else {
                print("Incorrect password")
                let authenticationError = NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "Incorrect password"])
                completion(false, authenticationError)
            }
        }
    }
}

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let db: Firestore
    
    private init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        print("Firestore loaded")
    }
}

