import Foundation
import Parse
import Bolts

var serverInitialized = false

class ParseServer {
    static let sharedInstance = ParseServer()
    private init() {
        if !serverInitialized {
            let configuration = ParseClientConfiguration {
                $0.applicationId = "wx8eMIWy1f9e60WrQJYUI81jlk5g6YYAPPmwxequ"
                $0.clientKey = "ECyvUjxayFW3un2sOkTkgFJC8mmqweeOAjW0OlKJ"
                $0.server = "http://corpsboard.herokuapp.com/parse"
                $0.isLocalDatastoreEnabled = true
            }
            Parse.initialize(with: configuration)
            serverInitialized = true
        }
    }
}
