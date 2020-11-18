import SwiftUI

extension NSMutableAttributedString {
    func with(font: UIFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? UIFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        
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

final class AttributedTextComponent: UIViewRepresentable {
    let string: NSMutableAttributedString
    
    init(_ string: NSMutableAttributedString) {
        self.string = string
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AttributedTextComponent>) -> UILabel {
        UILabel()
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.backgroundColor = .clear
        uiView.numberOfLines = 0
        uiView.lineBreakMode = .byWordWrapping
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.attributedText = string
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
        self.html = html.with(font: UIFont.preferredFont(forTextStyle: .body))
        self.component = AttributedTextComponent(html)
    }
    
    func calculateHeight(size: CGSize) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: .greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.attributedText = self.html
        
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
