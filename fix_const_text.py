from pathlib import Path
import re
path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')
text, c1 = re.subn(r'\bconst\s+Text\(([^)]*ResponsiveUtils[^)]*)\)', r'Text(\1)', text)
text, c2 = re.subn(r'\bconst\s+TextStyle\(\s*fontSize:\s*(\d+(?:\.\d+)?)(\s*[,)])', r'TextStyle(fontSize: ResponsiveUtils.scaledSize(context, \1)\2', text)
path.write_text(text, encoding='utf-8')
print(c1, c2)
