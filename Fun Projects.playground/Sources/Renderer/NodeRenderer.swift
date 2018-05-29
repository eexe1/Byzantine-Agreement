import UIKit

enum NodeSizes {
    static let width: CGFloat = 30
    static let height: CGFloat = 30
}

public struct NodeRenderer {
    
    public static func drawNode(_ node: Node, x: CGFloat, y: CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24.0),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        let myText = node.identifier
        let attributedString = NSAttributedString(string: myText, attributes: attributes)
        
        let stringRect = CGRect(x: x - NodeSizes.width/2, y: y - NodeSizes.width/2, width: NodeSizes.width, height: NodeSizes.height)
        
        attributedString.draw(in: stringRect)
        
    }
    
}
