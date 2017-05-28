//
//  Encryptor.swift
//  Scoreboard

import Foundation
import CryptoSwift

//class Encryptor: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
class Encryptor: NSObject, URLSessionDelegate {
 

    var urlSession: URLSession!
    var request: URLRequest!
    var opQueue: OperationQueue = OperationQueue()
    
    
    //
    // Retrieves the data from TimeToScore for the given request.
    //
    // @param requestType: type of request to make to the server
    // @param completion: call back function that is passed the downloaded data.
    //
    func getGameDataFromTTS(completion: @escaping ([String : AnyObject]?) -> Void) {
        getDataFromTTS(completion: { gameData in
            completion(gameData)
        })
    }
    
    func getDataFor(gameId: String, type: Request, completion: @escaping ([String : AnyObject]?) -> Void) {
        urlSession = URLSession(configuration: .default,
                                delegate: self,
                                delegateQueue: OperationQueue.main)
        
        request = URLRequest(url: type.getRequestUrlFor(gameId: gameId)!)
        //request = URLRequest(url: URL(string: "http://live.sharksice.timetoscore.com/get_game_rosters?game_id=162222")!)
        request.httpMethod = "GET"
        
                
        //print("\nAbout TO DOWNLOAD GAMES\n\n")
        
        // Download list of games from time to score
        let task = urlSession.dataTask(with: request,
                                       completionHandler:
            {(data, response, error) -> Void in
                // Check for error
                if error != nil {
                    
                    //print("Error: getDataFor")
                    
                }
                    // Successful game list download
                else {
                    //print("Data: getDataFor")
                    
                    // List of games as a string
                    let _: String = String(data: data!, encoding: .utf8)!
                    
                    
                    // Convert the list of games to a dictionary and call the completion handler
                    do {
                        try completion(JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                // Resonse
                if response != nil {
                   // print("Response: getDataFor")
                    
                }
        })
        task.resume()
    }

    
    func getRosterData(gameId: String, completion: @escaping ([String : AnyObject]?) -> Void) {
        urlSession = URLSession(configuration: .default,
                                delegate: self,
                                delegateQueue: OperationQueue.main)
        
        request = URLRequest(url: Request.roster.getRequestUrlFor(gameId: gameId)!)
        //request = URLRequest(url: URL(string: "http://live.sharksice.timetoscore.com/get_game_rosters?game_id=162222")!)
        
        print(request.url!)
        request.httpMethod = "GET"
        
        // Download list of games from time to score
        let task = urlSession.dataTask(with: request,
                                       completionHandler:
            {(data, response, error) -> Void in
                // Check for error
                if error != nil {
                    //print("Error:getRosterData")
                    
                }
                    // Successful game list download
                else {
                    //print("Data: getRosterData")
                    
                    
                    // List of games as a string
                    let _: String = String(data: data!, encoding: .utf8)!
                    
                    
                    
                    
                    // Convert the list of games to a dictionary and call the completion handler
                    do {
                        try completion(JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        })
        task.resume()
    }
    
    //
    // Call TTS' API with a request and query.
    // 
    // @param completion: called when the game data is retrieved.
    //
    private func getDataFromTTS(completion: @escaping ([String : AnyObject]?) -> Void) {
       
        let md5: String
        var args: String
        var urlString: String
        var hashString: String
        
        md5 = "".md5()
        
        args = buildTTSArgs(md5Body: md5)
        urlString = buildURLString(request: Request.schedule.rawValue, args: args)
        hashString = buildHashString(request: Request.schedule.rawValue, args: args)
        
        do {
            let authenticator: Authenticator = try HMAC(key: Constants.TTS_SECRET_KEY, variant: .sha256)
            let signature: Array<UInt8> = try authenticator.authenticate(hashString.utf8.map({$0}))
            urlString.append("&auth_signature=")
            urlString.append(signature.toHexString())
            
        } catch {
            print(error)
        }
        
       
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        request = URLRequest(url: URL(string: urlString)!)
        //print(urlString)
        request.httpMethod = "GET"
        
        self.downloadGames(completion: completion)
       
    }
    
    //
    // Downloads Time To Score's entire list of games.
    //
    // @param completion: passed the dictionary of games when the download is complete.
    //
    private func downloadGames(completion: @escaping ([String : AnyObject]?) -> Void) {
       
        // Download list of games from time to score
        let task = urlSession.dataTask(with: request,
                                       completionHandler:
            {(data, response, error) -> Void in
                // Check for error
                if error != nil {
                    //print("Error:")
                    
                }
                // Successful game list download
                else {
                    // Convert the list of games to a dictionary and call the completion handler
                    do {
                        try completion(JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject])
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        })
        task.resume()
    }
    
    
    
    // MARK: URL Parameter Build Methods
    
    private func buildTTSArgs(md5Body: String) -> String {
        var args: String = ""
        
        let date = NSDate()
        let authTime: Int = Int(date.timeIntervalSince1970)
        
        args.append("auth_key=")
        args.append(Constants.TTS_USER_NAME)
        args.append("&auth_timestamp=")
        args.append(String(authTime))
        args.append("&body_md5=")
        args.append(md5Body)
        args.append("&")
        args.append(Constants.TTS_LEAGUE)
        
        return args
    }
    
    private func buildURLString(request: String, args: String) -> String {
        var urlString: String = ""
        
        urlString.append(Constants.TTS_BASE_API_URL)
        urlString.append("/")
        urlString.append(request)
        urlString.append("?")
        urlString.append(args)
        
        return urlString
    }
    
   
    private func buildHashString(request: String, args: String) -> String {
        var hashString: String = ""
        
        hashString.append("GET\n/")
        hashString.append(request)
        hashString.append("\n")
        hashString.append(args)
        
        return hashString
    }
    
    // MARK:- NSURLConnection
    
    func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
        challenge.sender?.continueWithoutCredential(for: challenge)
    }
    
    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool {
        return true
    }
    
    func authorizeCert(challenge: URLAuthenticationChallenge,
                               completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?)))
        SecTrustSetPolicies(serverTrust!, policies);
        
        // Evaluate server certificate
        var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust!, &result)
        
        let isServerTrusted:Bool = (result.rawValue == SecTrustResultType.unspecified.rawValue || result.rawValue == SecTrustResultType.proceed.rawValue)
        
        // Get local and remote cert data
        let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
        let pathToCert = Bundle.main.path(forResource: "githubCert", ofType: "cer")
        let localCertificate:Data = NSData(contentsOfFile: pathToCert!)! as Data
        
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    // MARK:- URLSession
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        print(response)
    }
    
    // Mark: URLSessionTask Delegate
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        authorizeCert(challenge: challenge, completionHandler: completionHandler)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        authorizeCert(challenge: challenge, completionHandler: completionHandler)
    }
    
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("urlSession error:")
        print(error!)
    }
    
    // MARK: URLConnection Delegate
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("********* CONNECTION FAILED *********")
    }
    
    func connectionShouldUseCredentialStorage(_ connection: NSURLConnection) -> Bool {
        return true
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        print("**auth challenge **")
        print(challenge)
        
    }
    
    // MARK: OBJECT PROTOCOL
    override func isEqual(_ object: Any?) -> Bool {
        return false
    }
   
    override func `self`() -> Self {return self}
    
    
    override func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    override func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    override func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    
    public override func isProxy() -> Bool {
        return false
    }
    
    
    override func isKind(of aClass: Swift.AnyClass) -> Bool {
        return false
    }
    
    override func isMember(of aClass: Swift.AnyClass) -> Bool {
        return false
    }
    
 
    override func conforms(to aProtocol: Protocol) -> Bool {
        return false
    }
    
    
    override func responds(to aSelector: Selector!) -> Bool {
        return false
    }
}

enum Request: String {
    case schedule = "get_schedule"
    case roster = "get_game_rosters"
    case gameEvents = "get_game_events"
    case teamInfo = "get_team_info"
    
    // Creates the url for the given request.
    func getRequestUrlFor(gameId: String) -> URL? {
        if self == .schedule {
            return nil
        }
        return URL(string: "http://live.sharksice.timetoscore.com/\(self.rawValue)?game_id=\(gameId)")!
    }
}
