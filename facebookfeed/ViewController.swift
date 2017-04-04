//
//  ViewController.swift
//  facebookfeed
//
//  Created by Harry Tennent on 02/04/2017.
//  Copyright © 2017 Harry Tennent. All rights reserved.
//

import UIKit

let cellId = "cellId"

class Post {
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.statusText = "Meanwhile, Beast turned to the dark side."
        postMark.profileImageName = "zuckprofile"
        postMark.statusImageName = "zuckdog"
        postMark.numLikes = 400
        postMark.numComments = 123
        
        let postSteve  = Post()
        postSteve.name = "Steve Jobs"
        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" + "Being the richest man in the cemetry doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" + "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        postSteve.profileImageName = "steve_profile"
        postSteve.statusImageName = "steve_status"
        postSteve.numLikes = 1000
        postSteve.numComments = 55
        
        
        let postGandhi  = Post()
        postGandhi.name = "Mahatma Gandhi"
        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" + "The weak can never forgive. Forgiveness is the attribute of the strong.\n" + "Happiness is when what you think, what you say and what you do, are in harmony."
        postGandhi.profileImageName = "gandhi_profile"
        postGandhi.statusImageName = "gandhi_status"
        postGandhi.numLikes = 333
        postGandhi.numComments = 22
        
        posts.append(postMark)
        posts.append(postSteve)
        posts.append(postGandhi)
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(FeedCell.self,     forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1
                
                }, completion: nil)
            
        }
        
    }
    
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
            
            }, completion: { (didComplete) in
                
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            
            })
        }
    }

}

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    func animate() {
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    var post: Post? {
        didSet {
            
            if let name = post?.name {
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedText.append(NSAttributedString(string: "\nApril 2  •  Hindhead  •  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName:
                    UIColor.rgb(red: 155, green: 161, blue: 161)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
                
                nameLabel.attributedText = attributedText
            }
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImagename = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImagename)
            }
            
            if let statusImagename = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImagename)
            }
            
            

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the dark side."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false    
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes  10.7K Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        
        button.setImage(UIImage(named:imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentLabel)
        
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(self.animate)))
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentLabel)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        //button constraints
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentLabel, dividerLineView, likeButton)
        
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat:format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}








