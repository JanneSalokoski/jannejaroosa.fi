"""" md_to_html.py - Parse md content to html """

import markdown
import argparse

import re

def read_file(file):
    """Read a file and return it's contents"""
    with open(file, "r") as f:
        return f.read()

def write_file(file, content):
    """Write content to file"""
    with open(file, "w") as f:
        f.write(content)

def main():
    """Run the program"""

    # Parse arguments
    parser = argparse.ArgumentParser(
        prog="md_to_html.py",
        description="Parse md content to html",
    )

    parser.add_argument("input")
    parser.add_argument("output")

    args = parser.parse_args()

    # Read and convert markdown
    md = read_file(args.input)
    html = markdown.markdown(md, extensions=["tables"])

    # Read and fill template
    template = read_file("template.html")
    title = re.findall(r"<h1>(.+?)</h1>", html)[0]

    out = template.replace("{title}", title)
    out = out.replace("{content}", html)

    print(out)

    # Write to file
    write_file(args.output, out)

if __name__ == "__main__":
    main()
