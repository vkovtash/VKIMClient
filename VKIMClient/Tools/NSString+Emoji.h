/*
 *  NSString+Emoji.h
 *
 *  Created by Vlad Kovtash on 2013/07/02.
 *  Copyright 2013 Vlad Kovtash.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

/*
 *  This ccategory is based on NSString+Emoji by Valerio Mazzeo
 *  https://github.com/valeriomazzeo/NSString-Emoji
 */


/**
 NSString (Emoji) extends the NSString class to provide custom functionality
 related to the Emoji emoticons.
 
 Through this category, it is possible to turn cheat codes from 
 Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com> into unicode emoji characters
 and vice versa (useful if you need to POST a message typed by the user to a remote service).
 */
@interface NSString (Emoji)

/**
 Returns a NSString in which any occurrences that match the cheat codes
 from Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com> are replaced by the
 corresponding unicode characters.
 
 Example: 
 "This is a smiley face :smiley:"
 
 Will be replaced with:
 "This is a smiley face \U0001F604"
 */
- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode;

/**
 Returns a NSString in which any occurrences that match the unicode characters
 of the emoji emoticons are replaced by the corresponding cheat codes from
 Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com>.
 
 Example:
 "This is a smiley face \U0001F604"
 
 Will be replaced with:
 "This is a smiley face :smiley:"
 */
- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes;

@end
