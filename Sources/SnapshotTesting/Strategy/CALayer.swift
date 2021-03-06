#if os(macOS)
import Cocoa

extension Strategy where Snapshottable == CALayer, Format == NSImage {
  public static var image: Strategy {
    return .image(precision: 1)
  }

  public static func image(precision: Float) -> Strategy {
    return SimpleStrategy.image(precision: precision).pullback { layer in
      let image = NSImage(size: layer.bounds.size)
      image.lockFocus()
      let context = NSGraphicsContext.current!.cgContext
      layer.setNeedsLayout()
      layer.layoutIfNeeded()
      layer.render(in: context)
      image.unlockFocus()
      return image
    }
  }
}
#elseif os(iOS) || os(tvOS)
import UIKit

extension Strategy where Snapshottable == CALayer, Format == UIImage {
  public static var image: Strategy {
    return .image()
  }

  public static func image(precision: Float = 1, traits: UITraitCollection = .init())
    -> Strategy {
      return SimpleStrategy.image(precision: precision).pullback { layer in
        renderer(bounds: layer.bounds, for: traits).image { ctx in
          layer.setNeedsLayout()
          layer.layoutIfNeeded()
          layer.render(in: ctx.cgContext)
        }
      }
  }
}
#endif
