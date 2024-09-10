"""" md_to_html.py - Parse md content to html """

import markdown
import argparse

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

    parser = argparse.ArgumentParser(
        prog="md_to_html.py",
        description="Parse md content to html",
    )

    parser.add_argument("input")
    parser.add_argument("output")

    args = parser.parse_args()

    md = read_file(args.input)
    html = markdown.markdown(md)

    print(html)

    write_file(args.output, html)

if __name__ == "__main__":
    main()
