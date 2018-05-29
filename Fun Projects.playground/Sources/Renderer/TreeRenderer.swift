import UIKit

enum TreeOffset {
    static let Node = 2.0
}

public struct TreeRenderer {
    
    public static func drawTree(_ tree: Tree, width: CGFloat, height: CGFloat) {
    
        let numberOfGrids = Int(width/GridSizes.GridUnitSize)
        
        let dic = getTreeDic(tree)
        
        for (coords, node) in dic {
            let coordArray = coords.components(separatedBy: ",")
            let pX = Double(coordArray[0])! + TreeOffset.Node
            let pY = Double(coordArray[1])! + TreeOffset.Node
            let (x, y) = coordFromGrid(x: pX, y: pY)
            NodeRenderer.drawNode(node, x: x, y: y)
            
            if let children = node.nodes {
                for child in children {
                    let result = dic.filter{
                        $0.value == child
                    }
                    let childCoord = result.keys.first!.components(separatedBy: ",")
                    let cX = Double(childCoord[0])! + TreeOffset.Node
                    let cY = Double(childCoord[1])! + TreeOffset.Node
                    // draw line from parent to child
                    let (pCoordX, pCoordY) = coordFromGrid(x: pX, y: pY)
                    let (cCoordX, cCoordY) = coordFromGrid(x: cX, y: cY)
                    LineRenderer.draw(startX:pCoordX, startY:pCoordY, endX:cCoordX, endY:cCoordY)
                }
            }
            
        }
        
        
        
    }
    
    private static func coordFromGrid(x: Double, y: Double) -> (CGFloat, CGFloat) {
        let size = GridSizes.GridUnitSize
        return (CGFloat(x)*size, CGFloat(y)*size)
    }
    
    private static func getTreeDic(_ tree: Tree) -> [String: Node] {
        
        var map = [String: Node]()
        
        map = Node.getDic(tree.root)
        
        return map
    }
    
}

