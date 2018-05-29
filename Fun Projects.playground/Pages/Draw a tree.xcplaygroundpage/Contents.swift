import UIKit
import PlaygroundSupport

/*:
 - [EIGByz Tree](@next)
 */

enum GUISize {
    static let width: CGFloat = 500
    static let height: CGFloat = 500
}

var tree = Tree.init(Node.init(1))

var root = tree.root
// node's element has to be unique
root.add(Node.init(2, nodes: [Node.init(8), Node.init(11), Node.init(6)]))
root.add(Node.init(3, nodes: [Node.init(5)]))
root.add(Node.init(4))

tree.printTree()

UIGraphicsBeginImageContextWithOptions(CGSize(width: GUISize.width, height: GUISize.height), false, 0)

let grid = Grid(bounds: CGRect(x: 0, y: 0, width: GUISize.width, height: GUISize.height))
grid.draw()

TreeRenderer.drawTree(tree, width: GUISize.width, height: GUISize.height)

let im = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: GUISize.width, height: GUISize.height))
containerView.addSubview(UIImageView(image: im))
PlaygroundPage.current.liveView = containerView
