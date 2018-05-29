public class Tree {
    public var root: Node
    
    public init(_ root: Node = Node.init(0)) {
        self.root = root
    }
}

extension Tree {
    public func printTree() {
        Node.printNode(self.root)
    }
}
