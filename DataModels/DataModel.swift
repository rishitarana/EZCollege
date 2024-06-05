import Foundation
import FirebaseFirestore
import FirebaseAuth

/// shared database session initialization
let database = Firestore.firestore()

struct Product: Identifiable, Equatable{
    var id = UUID()
    var name: String
    var listedBy: UUID
    var listedAt: Date
    var views: Int
    var productImages: [String]
    var price: Int
    var condition: Condition
    var description: String
    var category: Category
    var isPromoted: Bool?
    
    static func == (lhs: Product, rhs: Product) -> Bool{
        return lhs.id == rhs.id
    }
}

enum Condition:String, CaseIterable
{
    case unused = "Unused"
    case barelyUsed = "Barely used"
    case moderatlyUsed = "Moderately used"
    case heavilyUsed = "Heavily used"
    
    var isValid:Bool{
        switch self{
        case .heavilyUsed:
            return true
        case .unused:
            return true
        case .barelyUsed:
            return true
        case .moderatlyUsed:
            return true
        }
    }
}
enum Category:String, CaseIterable{
    case Apparel = "Apparel"
    case Electronics = "Electronics"
    case MusicalInstruments = "Musical Instruments"
    case Sports = "Sports"
    case Stationary = "Stationery"
    
    var icon:String{
        switch self{
        case .Apparel:
            return "hanger"
        case .Electronics:
            return "bolt"
        case .MusicalInstruments:
            return "music.note"
        case .Sports:
            return "figure.badminton"
        case .Stationary:
            return "pencil"
        }
    }
    
    var isValid:Bool{
        switch self{
        case .Apparel:
            return true
        case .Electronics:
            return true
        case .MusicalInstruments:
            return true
        case .Sports:
            return true
        case .Stationary:
            return true
        }
    }
    
    
    var mayInclude:String{
        switch self{
        case .Apparel:
            return  "ClothingFootwearAccessorieschainsearingspendantshirtspantsshoestshirtjacketcoatchinosloafersparker"
        case .Electronics:
            return "LaptopChargerEarphonesPhonesHeadphonesAirpodswirecable"
        case .MusicalInstruments:
            return "GuitarFluteUkuleleMouthorganHarmonium"
        case .Sports:
            return "FootballBasketballRacquetsballBadmintonshuttlestudsspikeskeeping"
        case .Stationary:
            return "BooksNotesNotebooksPenpencilstaplererasersharpener"
        }
    }
    
    
    var title:String{
        switch self{
        case .Apparel:
            return "Apparel & Clothing"
        case .Electronics:
            return "Electronics"
        case .MusicalInstruments:
            return "Musical Instruments"
        case .Sports:
            return "Sports Equipment"
        case .Stationary:
            return "Stationery & Books"
        }
    }
}

struct Preferences{
    var category: Category
    var icon: String
    var choice:Bool
    var mayInlcude:[String]?
    
    static var allPreferences: [Preferences] = [
        Preferences(category: .Stationary, icon: "pencil", choice: false, mayInlcude: ["Books","Notes","Notebooks"]),
        Preferences(category: .Apparel, icon: "hanger", choice: false,mayInlcude: ["Clothing","Footwear","Accessories"]),
        Preferences(category: .Sports, icon: "figure.badminton", choice: false,mayInlcude: ["Football","Basketball","Racquets"]),
        Preferences(category: .Electronics, icon: "bolt", choice: false,mayInlcude: ["Laptop","Charger","Earphones"]),
        Preferences(category: .MusicalInstruments, icon: "music.note", choice: false,mayInlcude: ["Guitar","Flute","Ukulele"])
    ]
    
}

extension Preferences{
    var toDictionary: [String: Any]{
        return [
            "category": category.rawValue,
            "icon": icon,
            "choice": choice
        ]
    }
}

struct User: Identifiable{
    var id: UUID
    var uName: String
    var college: College
    var emailId: String
    var uImage: String
    var likedProducts: [UUID]
    var preferences: [Preferences]
    var listings: [Listing]
    var password: String
}

struct Message: Identifiable, Comparable{
    var id = UUID()
    var messages: String
    var from: UUID
    var to: UUID
    var timestamp: Date
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

struct Chat: Comparable{
    var id: [UUID]
    var on: UUID
    var timestamp: Date
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

struct College{
    var name: String
    var domain: String
    
    static var allColleges: [College] = [
        
        College(name: "Aakash Institute", domain: "aakashicampus.com"),
        College(name: "Aditya Birla World Academy School, Mumbai", domain: "abet.co.in"),
        College(name: "Aditya Vidyashram School, Puducherry", domain: "adityacbse.com"),
        College(name: "Ahmedabad University", domain: "ahduni.edu.in"),
        College(name: "Ajara Mahavidyalaya", domain: "ajaracollege.ac.in"),
        College(name: "Aligarh Muslim University", domain: "amu.ac.in"),
        College(name: "Amrita Vishwa Vidyapeetham, Coimbatore", domain: "cb.students.amrita.edu"),
        College(name: "Anant National University, Ahmedabad", domain: "anu.edu.in"),
        College(name: "Anna University, Chennai", domain: "annauniv.edu.in"),
        College(name: "Annasaheb Vartak College of Arts", domain: "avc.ac.in"),
        College(name: "Anurag Group of Institutions, Hyderabad", domain: "cvsr.ac.in"),
        College(name: "Assam Down Town University, Khankar Gaon", domain: "adtu.in"),
        College(name: "B. P. Poddar Institute of Management And Technology, Kolkata", domain: "bppimt.ac.in"),
        College(name: "Baba Bhimrao Ambedkar University, Lucknow", domain: "bbau.ac.in"),
        College(name: "Believers Church Medical College, Thiruvalla", domain: "bcmch.edu.in"),
        College(name: "Bishop Cotton Boy's School, Bangalore", domain: "bishopcottonboysschool.edu.in"),
        College(name: "Chitkara University, Rajpura", domain: "chitkara.edu.in"),
        College(name: "Chitkara University, Baddi", domain: "chitkara.edu.in"),
    ]
}

struct Listing{
    var product: UUID
    var isExpired: Bool
}

// MARK: Item data model

/// deleteProduct - To delete a product
/// Parameter id: the id of the product
func deleteProduct(with id: UUID){
    let idx = allProducts.firstIndex(where: {$0.id == id})!
    allProducts.remove(at: idx)
}

/// deleteProduct - To get a product
/// Parameter id: the id of the product
/// Returns product with the matching id
func getProduct(with id: UUID) -> Product{
    let idx = allProducts.firstIndex(where: {$0.id == id})!
    return allProducts[idx]
}


// MARK: User session and creation manager
class UserCreationAndSessionCreation{
    private var email: String = ""
    private var name: String = ""
    private var collegeName: String = ""
    private var userImage: String = ""
    private var likedProduct: [UUID] = []
    private var preferences: [Preferences] = Preferences.allPreferences
    private var password: String = ""
    
    private var user: User
    
    init(){
        self.user = User(
            id: UUID(),
            uName: self.name,
            college: College(
                name: self.collegeName,
                domain: "chitkara.edu.in"
            ),
            emailId: self.email,
            uImage: self.userImage,
            likedProducts: [],
            preferences: self.preferences,
            listings: [],
            password: self.password
        )
    }
    
    // MARK: Data setter and getter functions
    func putNameAndCollege(name: String, collegeName: String){
        self.name = name
        self.collegeName = collegeName
    }
    
    func getName() -> String{
        return self.name
    }
    
    func putEmail(email: String){
        self.email = email
    }
    
    func getEmail() -> String{
        return self.email
    }
    func putPassword(with password: String){
        self.password = password
    }
    func updatePreference(for index: Int, value like: Bool){
        self.user.preferences[index].choice = like
    }
    func setPassword(password: String){
        self.password = password
    }
    func putImage(image: String){
        self.userImage = image
        createUser()
    }
    
    // MARK: User Creation and upload to server
    func createUser(){
        uploadBase64Images(base64Images: self.userImage) { downloadURL, error in
            self.user = User(
                id: UUID(),
                uName: self.name,
                college: College(
                    name: self.collegeName,
                    domain: "chitkara.edu.in"
                ),
                emailId: self.email,
                uImage: downloadURL!,
                likedProducts: [],
                preferences: self.preferences,
                listings: [],
                password: self.password
            )
            
            self.updatePreference(for: 0, value: true)
            self.updatePreference(for: 1, value: true)
            self.updatePreference(for: 2, value: true)
            self.updatePreference(for: 3, value: true)
            self.updatePreference(for: 4, value: true)
            
            let docRef = database.collection("users").document("\(self.user.emailId)")
            docRef.setData( [
                "id": self.user.id.uuidString,
                "name": self.user.uName,
                "collegeName": self.user.college.name,
                "emailId": self.user.emailId,
                "likedProducts": self.user.likedProducts.map({$0.uuidString}),
                "preferences": self.user.preferences.map({$0.toDictionary}),
                "password": self.user.password,
                "image": downloadURL!,
                "listings": []
            ])
            Auth.auth().createUser(withEmail: self.user.emailId, password: self.user.password)
        }
    }
    
    
    /// function to set a newly get user from the database
    func createFetchedUser(id: UUID, email: String, name: String, collegeName: String, userImage: String, likedProduct: [UUID], preferences: [Preferences], listings: [Listing], password: String){
        self.user = User(
            id: id,
            uName: name,
            college: College(name: collegeName, domain: ".chitkara.edu.in"),
            emailId: email,
            uImage: userImage,
            likedProducts: likedProduct,
            preferences: preferences,
            listings: listings,
            password: password
        )
    }
    
    // MARK: Getting newly created user for session
    func getUser()->User{
        return self.user
    }
    
    // MARK: User data getting function
    func getUserActiveListings()->[Listing]{
        return self.user.listings.filter({$0.isExpired == false})
    }
    func getUserExpiredListings()->[Listing]{
        return self.user.listings.filter({$0.isExpired == true})
    }
    
    func getUserPreference()->[Preferences]{
        return self.user.preferences
    }
    func getLikedProducts()->[UUID]{
        return self.user.likedProducts
    }
    
    // MARK: Listing CRUD
    func addListing(with product: Product){
        self.user.listings.insert(Listing(product: product.id, isExpired: false), at:0)
    }

    func deleteListing(with product: Product){
        let idx = self.user.listings.firstIndex(where: {$0.product == product.id})!
        if isLikedProduct(with: product){
            let index = self.user.likedProducts.firstIndex(where: {$0 == product.id})!
            self.user.likedProducts.remove(at:index)
        }
        self.user.listings.remove(at: idx)
        deleteProduct(with: product.id)
    }
    
    func editListing(productID: UUID, category: Category, name: String, description: String, price: Int, condition: Condition){
        let prodIndex = allProducts.firstIndex(where: {$0.id == productID})!
        
        allProducts[prodIndex].name = name
        allProducts[prodIndex].price = price
        allProducts[prodIndex].condition = condition
        allProducts[prodIndex].description = description
        allProducts[prodIndex].category = category
    }
    
    func relist(with productID: UUID){
        let idx = self.user.listings.firstIndex(where: {$0.product == productID})!
        self.user.listings[idx].isExpired = false
    }
    
    // MARK: Add Liked product
    func addProductToLiked(with product: Product){
        self.user.likedProducts.insert(product.id, at: 0)
    }
    
    func deleteProductFromLiked(for product: Product){
        if let index = self.user.likedProducts.firstIndex(where: {$0 == product.id}){
            self.user.likedProducts.remove(at: index)
        }
    }
    
    func isLikedProduct(with product: Product)->Bool{
        return self.user.likedProducts.contains(where: {$0 == product.id})
    }
    
    // MARK: Get all products which are not listed by this user
    
    func getProducts()->[Product]{
        return allProducts.filter({$0.id.uuidString != self.user.id.uuidString})
    }
    
    func getProduct(with id: UUID) -> Product{
        let idx = allProducts.firstIndex(where: {$0.id == id})!
        return allProducts[idx]
    }
}
/// object creation
var user = UserCreationAndSessionCreation()


// MARK: All product functions, getters, setters, creation
class CreatAndEditProduct{
    private var name: String = ""
    private var productImage: [String] = []
    private var price: Int = 0
    private var condition: Condition = .heavilyUsed
    private var description: String = ""
    private var category: Category = .Apparel
    private var downloadURLS: [String] = []
    
    // MARK: Product Creation
    func setCategory(category: Category){
        self.category = category
    }
    
    func setProductDetails(name: String, description: String, price: Int, condition: Condition){
        self.name = name
        self.description = description
        self.price = price
        self.condition = condition
    }
    
    func setProductImages(images: [String]){
        self.productImage = images
    }
    
    // Create a product and upload the images to the server
    func createProduct(user: UserCreationAndSessionCreation) -> Product{
        let prod = Product(
            name: self.name,
            listedBy: user.getUser().id,
            listedAt: Date(),
            views: 0,
            productImages: self.productImage,
            price: self.price,
            condition: self.condition,
            description: self.description,
            category: self.category
        )
        
        uploadBase64Images(base64Images: prod.productImages) { downloadURLS, error in
            if let downloadURLS = downloadURLS{
                let dictionary: [String: Any] = [
                    "id": prod.id.uuidString,
                    "name": prod.name,
                    "listedBy": prod.listedBy.uuidString,
                    "listedAt": prod.listedAt,
                    "views" : prod.views,
                    "images": downloadURLS,
                    "price": prod.price,
                    "condition": prod.condition.rawValue,
                    "description": prod.description,
                    "category": prod.category.rawValue,
                    "isPromoted": prod.isPromoted ?? false
                ]
                let docRef = database.collection("products").document("\(prod.id.uuidString)")
                docRef.setData(dictionary) { error in
                    if let error = error {
                        print("Error setting document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
            
        }
        
        user.addListing(with: prod)
        return prod
    }
}

/// Homescreen categorized product list generator
class HomeScreen{
    private var productByCategory: [Category: [Product]] = [:]
    
    func getAllProducts() -> [Category: [Product]]{
        productByCategory = [:]
        for product in allProducts{
            if self.productByCategory[product.category] != nil{
                self.productByCategory[product.category]!.append(product)
            }else{
                self.productByCategory[product.category] = [product]
            }
        }
        
        return productByCategory
    }
    
    func getPromotedProducts() -> [Product]{
        var prods: [Product] = []
        let _ = promotedProducts.map{ productId in
            let idx = allProducts.firstIndex(where: {$0.id == productId})!
            prods.append(allProducts[idx])
        }
        return prods
    }
}

/// putMessage function
/// Parameter from - sender's id
/// Parameter to - reciever's id
/// Parameter with - message content
/// Parameter in - firebase document id
/// Parameter on - product id
func putMessage(from: String, to: String, with str: String, in document: String, on product: String) async throws{
    let docRef = database.collection("messages").document(document)
    
    let docSnapshot = try await docRef.getDocument()
    
    let message = Message(messages: str, from: UUID(uuidString: from)!, to: UUID(uuidString: to)!, timestamp: Date())
    
    if docSnapshot.exists {
        var existingData = docSnapshot.data() ?? [:]
        var messageArray = existingData["messages"] as? [[String: Any]] ?? []
        let messageData: [String: Any] = [
            "id": message.id.uuidString,
            "messages": message.messages,
            "from": message.from.uuidString,
            "to": message.to.uuidString,
            "timestamp": message.timestamp
        ]
        messageArray.append(
            messageData
        )
        existingData["messages"] = messageArray
        existingData["timestamp"] = Date()
        try await docRef.setData(
            existingData
        )
    } else {
        let newData: [String: Any] = [
            "messages": [[
                "id": message.id.uuidString,
                "messages": message.messages,
                "from": message.from.uuidString,
                "to": message.to.uuidString,
                "timestamp": message.timestamp
            ]],
            "timestamp": Date(),
            "involved": [message.from.uuidString, message.to.uuidString]
        ]
        try await docRef.setData(
            newData
        )
    }
    
}

var categorizedProducts = HomeScreen()

var createProduct = CreatAndEditProduct()
