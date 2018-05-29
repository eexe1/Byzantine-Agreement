import UIKit

enum GridSizes {
    static let GridUnitSize: CGFloat = 40.0
    static let GridLineWidth: CGFloat = 0.75
}

public struct Grid {
    var bounds: CGRect
    var gridUnitSize: CGFloat {
        return GridSizes.GridUnitSize
    }
    var lineWidth: CGFloat {
        return GridSizes.GridLineWidth
    }
    
    public init(bounds: CGRect) {
        self.bounds = bounds
    }
    
    public func draw() {
        let insetRect = CGRect(x: round(bounds.origin.x + 0.5), y: (bounds.origin.y + 0.5),
                               width: round(bounds.size.width - 1.0),
                               height: round(bounds.size.height - 1.0)).insetBy(dx: lineWidth / 2,
                                                                                dy: lineWidth / 2)
        let numLines = Int(insetRect.size.height / gridUnitSize)
        let rectsInLine = Int(insetRect.size.width / gridUnitSize) + 1
        for y in 0...numLines {
            let yCoordinate = CGFloat(y) * gridUnitSize
            let start = (y % 2 == 0) ? 0 : 0
            for x in stride(from: start, to: rectsInLine, by: 1) {
                let rect = CGRect(x: CGFloat(x) * gridUnitSize, y: yCoordinate,
                                  width: gridUnitSize, height: gridUnitSize)
                let p = UIBezierPath(rect: rect)
                UIColor.lightGray.setStroke()
                p.stroke()
            }
        }
    }
}

