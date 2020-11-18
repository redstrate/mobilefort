import SwiftUI

extension NSMutableAttributedString {
    func with(font: NSFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? NSFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        
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

final class AttributedTextComponent: NSViewRepresentable {
    let string: NSMutableAttributedString
    
    init(_ string: NSMutableAttributedString) {
        self.string = string
    }
    
    public func makeNSView(context: NSViewRepresentableContext<AttributedTextComponent>) -> NSTextField {
        NSTextField()
    }
    
    func updateNSView(_ uiView: NSTextField, context: Context) {
        uiView.backgroundColor = .clear
        //uiView.numberOfLines = 0
        uiView.lineBreakMode = .byWordWrapping
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.attributedStringValue = string
    }
}

struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct AttributedText: View {
    let html: NSMutableAttributedString
    let component: AttributedTextComponent
    
    @State var height: CGFloat = 0.0
    @State var lastSize: CGSize = .zero
    
    init(_ html: NSMutableAttributedString) {
        self.html = html.with(font: NSFont.systemFont(ofSize: 15))
        self.component = AttributedTextComponent(html)
    }
    
    func calculateHeight(size: CGSize) {
        let label = NSTextField(frame: NSRect(x: 0, y: 0, width: size.width, height: .greatestFiniteMagnitude))
        
        //label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        //label.attributedText = self.html
        label.attributedStringValue = self.html
        
        label.sizeToFit()
        
        self.height = label.frame.height
        self.lastSize = size
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle().fill(Color.clear).preference(key: SizeKey.self, value: geometry.size)
            }.onPreferenceChange(SizeKey.self, perform: { size in
                self.calculateHeight(size: size)
            })
            
            component
        }
        .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: self.height, maxHeight: self.height)
        .onAppear {
            if self.lastSize != .zero {
                self.calculateHeight(size: self.lastSize)
            }
        }
    }
}
