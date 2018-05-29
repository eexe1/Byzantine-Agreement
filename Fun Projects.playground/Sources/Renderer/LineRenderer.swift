import UIKit

enum LineProps {
    static let LineWidth: CGFloat = 0.75
}

public struct LineRenderer {
    var lineWidth: CGFloat {
        return LineProps.LineWidth
    }
    
    public static func draw(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        UIColor.orange.setStroke()
        path.stroke()
    }
}
