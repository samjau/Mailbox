//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Sam Jau on 8/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet var listTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageBgView: UIView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet var inboxPanGestureRecognizer: UIPanGestureRecognizer!
    
    var inboxViewOrigX: CGFloat!
    var messageOrigX: CGFloat!
    var green: UIColor = UIColor(red: (98/255.0), green: (217/255.0), blue: (98/255.0), alpha: 1.0)
    var red: UIColor = UIColor(red: (239/255.0), green: (84/255.0), blue: (9/255.0), alpha: 1.0)
    var yellow: UIColor = UIColor(red: (255/255.0), green: (206/255.0), blue: (13/255.0), alpha: 1.0)
    var tan: UIColor = UIColor(red: (216/255.0), green: (166/255.0), blue: (116/255.0), alpha: 1.0)
    var gray: UIColor = UIColor(red: (216/255.0), green: (216/255.0), blue: (216/255.0), alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        mailboxScrollView.contentSize = feedImageView.frame.size
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onPanGesture:")
        view.addGestureRecognizer(panGestureRecognizer)
        var listTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onListTapGesture:")
        view.addGestureRecognizer(listTapGestureRecognizer)
        var edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGestureRecognizer.edges = UIRectEdge.Left
        inboxView.addGestureRecognizer(edgeGestureRecognizer)
        var inboxPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onInboxPanGestureRecognizer")
        view.addGestureRecognizer(inboxPanGestureRecognizer)
        
        inboxViewOrigX = inboxView.center.x
        
        messageOrigX = messageImageView.center.x
        deleteIconImageView.alpha = 0
        archiveIconImageView.alpha = 0
        listIconImageView.alpha = 0
        laterIconImageView.alpha = 0
        listImageView.alpha = 0
        rescheduleImageView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            messageOrigX = messageImageView.center.x
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            messageImageView.center.x = messageOrigX + translation.x

            archiveIconImageView.alpha = (messageImageView.center.x - 160) / 60
            laterIconImageView.alpha = -(messageImageView.center.x - 160) / 60
            
            if messageImageView.center.x > 100 && messageImageView.center.x < 220 {
                messageBgView.backgroundColor = gray
            } else if messageImageView.center.x > 220 {
                messageBgView.backgroundColor = green
                archiveIconImageView.alpha = 1
                deleteIconImageView.alpha = 0
                archiveIconImageView.center.x = messageImageView.center.x - 193
                deleteIconImageView.center.x = messageImageView.center.x - 193
                if messageImageView.center.x > 380 {
                    messageBgView.backgroundColor = red
                    archiveIconImageView.alpha = 0
                    deleteIconImageView.alpha = 1
                }
            } else if messageImageView.center.x < 100 {
                messageBgView.backgroundColor = yellow
                laterIconImageView.alpha = 1
                listIconImageView.alpha = 0
                laterIconImageView.center.x = messageImageView.center.x + 193
                listIconImageView.center.x = messageImageView.center.x + 193
                if messageImageView.center.x < -40 {
                    messageBgView.backgroundColor = tan
                    laterIconImageView.alpha = 0
                    listIconImageView.alpha = 1
                }
            }

            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if messageImageView.center.x > 100 && messageImageView.center.x < 220 {
                UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options: nil, animations: {
                    self.messageImageView.center.x = 160
                }, completion: nil)
            } else if messageImageView.center.x > 220{
                UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options: nil, animations: {
                    self.messageImageView.center.x = 540
                    self.archiveIconImageView.center.x = self.messageImageView.center.x - 193
                    self.deleteIconImageView.center.x = self.messageImageView.center.x - 193
                    }, {(finished:Bool) in self.hideMessage()})
            } else if messageImageView.center.x < 100{
                if messageImageView.center.x < -40{
                    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options: nil, animations: {
                        self.messageImageView.center.x = -380
                        self.listIconImageView.center.x = self.messageImageView.center.x + 193
                        self.laterIconImageView.center.x = self.messageImageView.center.x + 193
                        }, {(finished:Bool) in
                            UIView.animateWithDuration(0.2, animations:{
                                self.listImageView.alpha = 1
                            })
                    })
                } else {
                    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 20, options: nil, animations: {
                        self.messageImageView.center.x = -380
                        self.listIconImageView.center.x = self.messageImageView.center.x + 193
                        self.laterIconImageView.center.x = self.messageImageView.center.x + 193
                        }, completion: {(finished:Bool) in
                            UIView.animateWithDuration(0.2, animations:{
                                self.rescheduleImageView.alpha = 1
                            })
                    })
                }
            }
        }
    }

    @IBAction func onListTapGesture(sender: UITapGestureRecognizer) {
        if listImageView.alpha == 1 || rescheduleImageView.alpha == 1 {
            listImageView.alpha = 0
            rescheduleImageView.alpha = 0
            hideMessage()
        }
    }
    @IBAction func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var point = sender.locationInView(view)
        println("translation:\(translation)")
        if sender.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            inboxViewOrigX = inboxView.center.x
        } else if sender.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            inboxView.center.x = inboxViewOrigX + translation.x
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            if inboxView.center.x > 220 {
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: 10, options: nil, animations: {
                        self.inboxView.center.x = 450
                    }, completion: nil)
            }
        }
    }
    
    @IBAction func onInboxPanGestureRecognizer(sender: AnyObject) {
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        if inboxView.center.x > 160 {
            if sender.state == UIGestureRecognizerState.Began{
                inboxViewOrigX = inboxView.center.x
            } else if sender.state == UIGestureRecognizerState.Changed {
                inboxView.center.x = inboxViewOrigX + translation.x
            } else if sender.state == UIGestureRecognizerState.Ended {
                closeMenu()
            }
        }
    }
    
    func hideMessage() {
        UIView.animateWithDuration(0.4, delay: 0.5, usingSpringWithDamping: 0.95, initialSpringVelocity: 10, options: nil, animations: {
            self.messageBgView.center.y = -86
            self.feedImageView.center.y = 730
            }, completion: {(finished:Bool) in
                self.messageBgView.transform = CGAffineTransformMakeScale(1, 0)
            })
    }
    
    func closeMenu(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: 10, options: nil, animations: {
                self.inboxView.center.x = 160
            }, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    

}
