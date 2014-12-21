/*
 
 Copyright (c) 2014 Jeff Menter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "JAMSVGImageView.h"
#import "JAMSVGImage.h"

@implementation JAMSVGImageView

- (instancetype)initWithSVGImage:(JAMSVGImage *)svgImage;
{
    if (!(self = [super initWithFrame:CGRectMake(0, 0, svgImage.size.width, svgImage.size.height)]))
        return nil;
    self.selected = NO;
    self.svgImage = svgImage;
    self.backgroundColor = UIColor.clearColor;
    return self;
}

- (void)sizeToFit;
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.svgImage.size.width, self.svgImage.size.height);
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    if (_contentMode != contentMode) {
        _contentMode = contentMode;
        [self setNeedsDisplay];
    }
}
//
//- (void) setSvgImage:(JAMSVGImage *)svgImage {
//    _svgImage = svgImage;
//    self.frame = CGRectMake(0, 0, svgImage.size.width, svgImage.size.height);
//}

- (void) setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews;
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    JAMSVGImage *drawSvgImage = self.selected && self.svgImageSelected != nil ? self.svgImageSelected : self.svgImage;
    
    CGRect destinationRect = CGRectZero;
    CGFloat scalingFactor = 1.f;
    CGFloat halfRectWidth = rect.size.width / 2.0;
    CGFloat halfRectHeight = rect.size.height / 2.0;
    CGFloat halfSVGWidth = drawSvgImage.size.width / 2.0;
    CGFloat halfSVGHeight = drawSvgImage.size.height / 2.0;
    
    switch (self.contentMode) {
        case UIViewContentModeBottom:
            destinationRect = CGRectMake(halfRectWidth - halfSVGWidth, rect.size.height - drawSvgImage.size.height,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeBottomLeft:
            destinationRect = CGRectMake(0, rect.size.height - drawSvgImage.size.height,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeBottomRight:
            destinationRect = CGRectMake(rect.size.width - drawSvgImage.size.width, rect.size.height - drawSvgImage.size.height,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeCenter:
            destinationRect = CGRectMake(halfRectWidth - halfSVGWidth, halfRectHeight - halfSVGHeight,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeLeft:
            destinationRect = CGRectMake(0, halfRectHeight - halfSVGHeight,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeRedraw: // This option doesn't make sense with SVG. We'll redraw regardless.
            destinationRect = rect;
            break;
        case UIViewContentModeRight:
            destinationRect = CGRectMake(rect.size.width - drawSvgImage.size.width,
                                         halfRectHeight - halfSVGHeight,
                                         drawSvgImage.size.width,
                                         drawSvgImage.size.height);
            break;
        case UIViewContentModeScaleAspectFill:
            scalingFactor = MAX(rect.size.width / drawSvgImage.size.width, rect.size.height / drawSvgImage.size.height);
            destinationRect = CGRectMake(halfRectWidth - (halfSVGWidth * scalingFactor),
                                         halfRectHeight - (halfSVGHeight * scalingFactor),
                                         drawSvgImage.size.width * scalingFactor,
                                         drawSvgImage.size.height * scalingFactor);
            break;
        case UIViewContentModeScaleAspectFit:
            scalingFactor = MIN(rect.size.width / drawSvgImage.size.width, rect.size.height / drawSvgImage.size.height);
            destinationRect = CGRectMake(halfRectWidth - (halfSVGWidth * scalingFactor),
                                         halfRectHeight - (halfSVGHeight * scalingFactor),
                                         drawSvgImage.size.width * scalingFactor,
                                         drawSvgImage.size.height * scalingFactor);
            break;
        case UIViewContentModeScaleToFill:
            destinationRect = rect;
            break;
        case UIViewContentModeTop:
            destinationRect = CGRectMake(halfRectWidth - halfSVGWidth, 0,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeTopLeft:
            destinationRect = CGRectMake(0, 0,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        case UIViewContentModeTopRight:
            destinationRect = CGRectMake(rect.size.width - drawSvgImage.size.width, 0,
                                         drawSvgImage.size.width, drawSvgImage.size.height);
            break;
        default:
            destinationRect = rect;
            break;
    }
    [drawSvgImage drawInRect:destinationRect];
}

@end
