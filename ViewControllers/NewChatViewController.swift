import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var avatar: UIImage?
}

struct Messagee: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class CustomInputBar: InputBarAccessoryView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    private func setupSubviews() {
        inputTextView.textContainerInset.left = 16
    }
}

class NewChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate,InputBarAccessoryViewDelegate {
    var ids: [UUID] = []{
        didSet{
           loadChats()
        }
    }
    
    var allMessagesInChat: [Message] = []
    
    var currentUser = user.getUser()
    func loadChats(){
        let concat = "\(ids[0].uuidString)+\(ids[1].uuidString)+\(ids[2].uuidString)"
        Task{
            await getMessages(with:concat)
        }
    }
    var curUser: Sender!
    var secondaryUser: Sender!
    {
        didSet
        {
            messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    var allMessages: [MessageType] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(chatLoaded), name: Notification.Name("chatLoaded"), object: nil)
        
        if(currentUser.id == ids[0]){
            curUser = Sender(senderId: ids[0].uuidString, displayName: "", avatar: UIImage(systemName: "person"))
            secondaryUser = Sender(senderId: ids[2].uuidString, displayName: "", avatar: UIImage(systemName: "person"))
        }else{
            secondaryUser = Sender(senderId: ids[0].uuidString, displayName: "", avatar: UIImage(systemName: "person"))
            curUser = Sender(senderId: ids[2].uuidString, displayName: "", avatar: UIImage(systemName: "person"))
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        configureCustomInputBar()
    }
    
    @objc func chatLoaded(){
        allMessagesInChat = messages
        updateChatController()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    func updateChatController(){
        allMessages.removeAll()
        for message in allMessagesInChat {
            if message.from == currentUser.id{
                allMessages.append(Messagee(sender: curUser, messageId: message.id.uuidString, sentDate: message.timestamp, kind: .text(message.messages)))
            }else{
                allMessages.append(Messagee(sender: secondaryUser, messageId: message.id.uuidString, sentDate: message.timestamp, kind: .text(message.messages)))
            }
        }
        
        messagesCollectionView.reloadData()
    }
    
    func configureCustomInputBar() {
        messageInputBar.backgroundView.backgroundColor = UIColor.white
        messageInputBar.inputTextView.becomeFirstResponder()
        messageInputBar.inputTextView.placeholder = ""
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 100, left: 120, bottom: 0, right: 0)
        messageInputBar.middleContentViewPadding = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        messageInputBar.middleContentView!.layer.cornerRadius = 20
        messageInputBar.middleContentView!.layer.borderWidth = 0.5
        messageInputBar.middleContentView!.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
    func currentSender() -> SenderType {
        return curUser!
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return allMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return allMessages.count
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let isFromCurrentSender = message.sender.senderId == curUser!.senderId
        return isFromCurrentSender ? .bubbleTail(.bottomRight, .curved) : .bubbleTail(.bottomLeft, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let isFromCurrentSender = message.sender.senderId == curUser!.senderId
        return isFromCurrentSender ? UIColor.systemBlue : UIColor.systemGray6
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let isFromCurrentSender = message.sender.senderId == curUser!.senderId
        return isFromCurrentSender ? .white : .black
    }
    
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender as? Sender
        avatarView.image = sender?.avatar
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let ids = self.ids
        Task{
            do{
                let concat = "\(ids[0].uuidString)+\(ids[1].uuidString)+\(ids[2].uuidString)"
                if(currentUser.id == ids[0]){
                    try await putMessage(from: ids[0].uuidString, to: ids[2].uuidString, with: inputBar.inputTextView.text, in: concat, on: ids[1].uuidString)
                }else{
                    try await putMessage(from: ids[2].uuidString, to: ids[0].uuidString, with: inputBar.inputTextView.text, in: concat, on: ids[1].uuidString)
                }
                DispatchQueue.main.async{
                    inputBar.inputTextView.text = ""
                }
            }catch{}
            messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
}
