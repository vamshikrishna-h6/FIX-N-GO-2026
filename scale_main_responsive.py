from pathlib import Path
import re

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')
backup = Path('lib/main.dart.orig')
if not backup.exists():
    backup.write_text(text, encoding='utf-8')

# sizedbox replacement
pattern_sizedbox = re.compile(r'(?P<prefix>\bconst\s+)?SizedBox\(\s*(?P<kind>width|height):\s*(?P<value>\d+(?:\.\d+)?)(?P<rest>\s*,?\s*)\)')
text, count1 = pattern_sizedbox.subn(lambda m: f"SizedBox({m.group('kind')}: ResponsiveUtils.scaledSize(context, {m.group('value')}){m.group('rest')})", text)

# EdgeInsets replacements
text, count2 = re.subn(r'const\s+EdgeInsets\.all\(\s*(?P<val>\d+(?:\.\d+)?)\s*\)', r'EdgeInsets.all(ResponsiveUtils.scaledPadding(context, \g<val>))', text)
text, count3 = re.subn(r'EdgeInsets\.all\(\s*(?P<val>\d+(?:\.\d+)?)\s*\)', r'EdgeInsets.all(ResponsiveUtils.scaledPadding(context, \g<val>))', text)

def repl_symmetric(match):
    inner = match.group(0)
    return re.sub(r'(?P<name>horizontal|vertical)\s*:\s*(?P<val>\d+(?:\.\d+)?)', lambda m: f"{m.group('name')}: ResponsiveUtils.scaledPadding(context, {m.group('val')})", inner)

text, count4 = re.subn(r'const\s+EdgeInsets\.symmetric\([^)]*\)', repl_symmetric, text)
text, count5 = re.subn(r'EdgeInsets\.symmetric\([^)]*\)', repl_symmetric, text)

def repl_only(match):
    inner = match.group(1)
    inner = re.sub(r'(?P<name>left|right|top|bottom|horizontal|vertical)\s*:\s*(?P<val>\d+(?:\.\d+)?)', lambda m: f"{m.group('name')}: ResponsiveUtils.scaledPadding(context, {m.group('val')})", inner)
    return f'EdgeInsets.only({inner})'

text, count6 = re.subn(r'const\s+EdgeInsets\.only\(([^)]*)\)', repl_only, text)
text, count7 = re.subn(r'EdgeInsets\.only\(([^)]*)\)', repl_only, text)

text, count8 = re.subn(r'const\s+EdgeInsets\.fromLTRB\(\s*(?P<a>\d+(?:\.\d+)?)\s*,\s*(?P<b>\d+(?:\.\d+)?)\s*,\s*(?P<c>\d+(?:\.\d+)?)\s*,\s*(?P<d>\d+(?:\.\d+)?)\s*\)',
              lambda m: f'EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, {m.group("a")}), ResponsiveUtils.scaledPadding(context, {m.group("b")}), ResponsiveUtils.scaledPadding(context, {m.group("c")}), ResponsiveUtils.scaledPadding(context, {m.group("d")}))', text)
text, count9 = re.subn(r'EdgeInsets\.fromLTRB\(\s*(?P<a>\d+(?:\.\d+)?)\s*,\s*(?P<b>\d+(?:\.\d+)?)\s*,\s*(?P<c>\d+(?:\.\d+)?)\s*,\s*(?P<d>\d+(?:\.\d+)?)\s*\)',
              lambda m: f'EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, {m.group("a")}), ResponsiveUtils.scaledPadding(context, {m.group("b")}), ResponsiveUtils.scaledPadding(context, {m.group("c")}), ResponsiveUtils.scaledPadding(context, {m.group("d")}))', text)

text, count10 = re.subn(r'width:\s*(\d+(?:\.\d+)?)(\s*,)', r'width: ResponsiveUtils.scaledSize(context, \1)\2', text)
text, count11 = re.subn(r'height:\s*(\d+(?:\.\d+)?)(\s*,)', r'height: ResponsiveUtils.scaledSize(context, \1)\2', text)
text, count12 = re.subn(r'BorderRadius\.circular\(\s*(\d+(?:\.\d+)?)\s*\)', r'BorderRadius.circular(ResponsiveUtils.scaledSize(context, \1))', text)
text, count13 = re.subn(r'Radius\.circular\(\s*(\d+(?:\.\d+)?)\s*\)', r'Radius.circular(ResponsiveUtils.scaledSize(context, \1))', text)
text, count14 = re.subn(r'size:\s*(\d+(?:\.\d+)?)(\s*[,)])', r'size: ResponsiveUtils.scaledSize(context, \1)\2', text)

text, count15 = re.subn(r'\bconst\s+(EdgeInsets\.(?:symmetric|all|only|fromLTRB)\([^)]*ResponsiveUtils[^)]*\))', r'\1', text)
text, count16 = re.subn(r'\bconst\s+(Icon\([^)]*ResponsiveUtils[^)]*\))', r'\1', text)

path.write_text(text, encoding='utf-8')
print('replaced counts:', count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15, count16)
