#!/usr/bin/env python3
"""
Simple Markdown to PDF converter using only Python standard library.
This script converts a markdown file to a styled HTML file that can be printed to PDF.
"""

import os
import re
import sys
from datetime import datetime

def escape_html(text):
    """Escape HTML special characters."""
    return (text.replace('&', '&amp;')
                   .replace('<', '&lt;')
                   .replace('>', '&gt;')
                   .replace('"', '&quot;'))

def parse_inline(text):
    """Parse inline markdown: bold, italic, code, links, images."""
    # Images: ![alt](url)
    text = re.sub(r'!\[([^\]]*)\]\(([^)]+)\)', r'<img src="\2" alt="\1" style="max-width:100%"/>', text)
    # Links: [text](url)
    text = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', text)
    # Bold: **text** or __text__
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'__([^_]+)__', r'<strong>\1</strong>', text)
    # Italic: *text* or _text_
    text = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', text)
    text = re.sub(r'_([^_]+)_', r'<em>\1</em>', text)
    # Inline code: `code`
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    return text

def convert_line(line):
    """Convert a single markdown line to HTML."""
    # Horizontal rule
    if re.match(r'^-{3,}$', line.strip()) or re.match(r'^_{3,}$', line.strip()):
        return '<hr/>'

    # Headings
    heading_match = re.match(r'^(#{1,6})\s+(.+)$', line)
    if heading_match:
        level = len(heading_match.group(1))
        content = parse_inline(heading_match.group(2))
        return f'<h{level}>{content}</h{level}>'

    # Unordered list
    if re.match(r'^\s*[-*+]\s+', line):
        content = parse_inline(re.sub(r'^\s*[-*+]\s+', '', line))
        return f'<li>{content}</li>'

    # Ordered list
    if re.match(r'^\s*\d+\.\s+', line):
        content = parse_inline(re.sub(r'^\s*\d+\.\s+', '', line))
        return f'<li>{content}</li>'

    # Blockquote
    if re.match(r'^\s*>\s+', line):
        content = parse_inline(re.sub(r'^\s*>\s+', '', line))
        return f'<blockquote>{content}</blockquote>'

    # Code block (indented 4 spaces or triple backticks handled separately)
    if re.match(r'^    ', line):
        code = escape_html(line[4:])
        return f'<pre><code>{code}</code></pre>'

    # Paragraph
    if line.strip():
        return f'<p>{parse_inline(line)}</p>'

    return ''

def convert_markdown_to_html(md_content):
    """Convert full markdown content to HTML."""
    lines = md_content.split('\n')
    html_lines = []
    in_code_block = False
    code_block_lines = []
    in_table = False
    table_header_done = False

    i = 0
    while i < len(lines):
        line = lines[i].rstrip()

        # Triple backtick code blocks
        if line.strip().startswith('```'):
            if not in_code_block:
                in_code_block = True
                code_block_lines = []
                lang = line.strip()[3:].strip()
                if lang:
                    html_lines.append(f'<pre><code class="language-{lang}">')
                else:
                    html_lines.append('<pre><code>')
            else:
                code_content = '\n'.join(code_block_lines)
                html_lines.append(escape_html(code_content))
                html_lines.append('</code></pre>')
                in_code_block = False
            i += 1
            continue

        if in_code_block:
            code_block_lines.append(line)
            i += 1
            continue

        # Tables
        if '|' in line and re.match(r'^\s*\|', line):
            # Remove leading/trailing pipes and split
            cells = [cell.strip() for cell in line.strip('|').split('|')]
            if re.match(r'^[\s|:-]+$', line):
                # Separator line, skip
                if not table_header_done:
                    table_header_done = True
                i += 1
                continue
            if not in_table:
                html_lines.append('<table>')
                in_table = True
            if not table_header_done:
                # Header row
                html_lines.append('<thead><tr>')
                for cell in cells:
                    html_lines.append(f'<th>{parse_inline(cell)}</th>')
                html_lines.append('</tr></thead>')
                table_header_done = True
            else:
                # Body row
                html_lines.append('<tr>')
                for cell in cells:
                    html_lines.append(f'<td>{parse_inline(cell)}</td>')
                html_lines.append('</tr>')
            i += 1
            continue

        if in_table:
            html_lines.append('</table>')
            in_table = False
            table_header_done = False

        # Nested lists tracking
        converted = convert_line(line)
        html_lines.append(converted)
        i += 1

    if in_table:
        html_lines.append('</table>')
    if in_code_block:
        html_lines.append('</code></pre>')

    return '\n'.join(html_lines)

def generate_html(md_content, title):
    """Generate full HTML document with styling."""
    body_content = convert_markdown_to_html(md_content)

    html_template = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{escape_html(title)}</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
            color: #333;
        }}
        h1, h2, h3, h4, h5, h6 {{
            margin-top: 1.5em;
            margin-bottom: 0.5em;
            font-weight: 600;
            line-height: 1.25;
        }}
        h1 {{ font-size: 2em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }}
        h2 {{ font-size: 1.5em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }}
        h3 {{ font-size: 1.25em; }}
        p {{ margin-bottom: 1em; }}
        a {{ color: #0366d6; text-decoration: none; }}
        a:hover {{ text-decoration: underline; }}
        code {{
            font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
            background-color: #f6f8fa;
            padding: 0.2em 0.4em;
            border-radius: 3px;
            font-size: 85%;
        }}
        pre {{
            background-color: #f6f8fa;
            padding: 16px;
            border-radius: 6px;
            overflow: auto;
            margin-bottom: 1em;
        }}
        pre code {{
            background-color: transparent;
            padding: 0;
            font-size: 100%;
        }}
        blockquote {{
            margin: 0 0 1em 0;
            padding: 0 1em;
            color: #6a737d;
            border-left: 0.25em solid #dfe2e5;
        }}
        ul, ol {{
            margin-bottom: 1em;
            padding-left: 2em;
        }}
        li {{ margin-bottom: 0.25em; }}
        table {{
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 1em;
        }}
        th, td {{
            border: 1px solid #dfe2e5;
            padding: 6px 13px;
        }}
        th {{
            background-color: #f6f8fa;
            font-weight: 600;
        }}
        tr:nth-child(2n) {{
            background-color: #f6f8fa;
        }}
        img {{
            max-width: 100%;
            height: auto;
        }}
        hr {{
            height: 0.25em;
            padding: 0;
            margin: 24px 0;
            background-color: #e1e4e8;
            border: 0;
        }}
        @media print {{
            body {{ padding: 0; }}
            a {{ text-decoration: none; color: #000; }}
        }}
    </style>
</head>
<body>
{body_content}
</body>
</html>'''

    return html_template

def main():
    md_path = '/Users/shashwat/Desktop/shash-apidash/apidash/doc/proposals/2026/gsoc/application_shashwat_git_workflow_dashboard.md'
    if not os.path.exists(md_path):
        print(f"Error: File not found: {md_path}")
        sys.exit(1)

    with open(md_path, 'r', encoding='utf-8') as f:
        md_content = f.read()

    title = os.path.basename(md_path).replace('.md', '')
    html_content = generate_html(md_content, title)

    html_path = md_path.replace('.md', '.html')
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f'✓ HTML file created: {html_path}')
    print('To convert to PDF:')
    print('  1. Open the HTML file in your web browser (Chrome, Safari, etc.)')
    print('  2. Press Cmd+P (Mac) or Ctrl+P (Windows/Linux)')
    print('  3. Choose "Save as PDF" as the destination')
    print('  4. Click "Save" and choose a location')
    print()
    print('Alternatively, use an online converter like:')
    print('  - https://www.markdowntopdf.com')
    print('  - https://www.convertmarked.com')
    print()
    print('Your application is ready!')

if __name__ == '__main__':
    main()
