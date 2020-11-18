import Foundation

#if os(macOS)
import AppKit

extension NSMutableAttributedString {
    func with(font: NSFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? NSFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        
        addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.controlTextColor, range: NSRange(location: 0, length: self.length))
        
        return self
    }
    
    func applyTraitsFromFont(_ originalFont: NSFont, to newFont: NSFont) -> NSFont? {
        let originalTrait = originalFont.fontDescriptor.symbolicTraits
        
        if(originalTrait.contains(NSFontDescriptor.SymbolicTraits.bold)) {
            var traits = newFont.fontDescriptor.symbolicTraits
            traits.insert(.bold)
            
            let fontDescriptor = newFont.fontDescriptor.withSymbolicTraits(traits)
            return NSFont.init(descriptor: fontDescriptor, size: 0)
        }
        
        return newFont
    }
}
#elseif os(iOS)
import UIKit

extension NSMutableAttributedString {
    func with(font: UIFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? UIFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        
        addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: self.length))
        
        return self
    }
    
    func applyTraitsFromFont(_ originalFont: UIFont, to newFont: UIFont) -> UIFont? {
        let originalTrait = originalFont.fontDescriptor.symbolicTraits
        
        if originalTrait.contains(.traitBold) {
            var traits = newFont.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            
            if let fontDescriptor = newFont.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fontDescriptor, size: 0)
            }
        }
        
        return newFont
    }
}
#endif
