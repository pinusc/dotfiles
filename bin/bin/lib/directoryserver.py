#!/usr/bin/env python

from http import HTTPStatus
from http.server import *
from io import BytesIO
import datetime
import html
import http.server
import io
import mimetypes
import os
import posixpath
import random
import re
import shutil
import socketserver
import sys
import urllib
import urllib.request, urllib.parse, urllib.error


PORT = 8000

def format_bytes(size):
    # 2**10 = 1024
    power = 2**10
    n = 0
    power_labels = {0 : '', 1: 'Ki', 2: 'Mi', 3: 'Gi', 4: 'Ti'}
    while size > power:
        size /= power
        n += 1
    return size, power_labels[n]+'B'

colordic = (
('#ffecd2', '#fcb69f', 'black'),
('#ff9a9e', '#fecfef', 'black'),
('#a1c4fd', '#c2e9fb', 'black'),
('#cfd9df', '#e2ebf0', 'black'),
('#fdfbfb', '#ebedee', 'black'),
('#f5f7fa', '#c3cfe2', 'black'),
('#667eea', '#764ba2', 'white'),
('#fdfcfb', '#e2d1c3', 'black'),
('#89f7fe', '#66a6ff', 'black'),
('#48c6ef', '#6f86d6', 'black'),
('#feada6', '#f5efef', 'black'),
('#a3bded', '#6991c7', 'black'),
('#13547a', '#80d0c7', 'black'),
('#93a5cf', '#e4efe9', 'black'),
('#434343', '#000000', 'white'),
('#93a5cf', '#e4efe9', 'black'),
('#ff758c', '#ff7eb3', 'black'),
('#868f96', '#596164', 'white'),
('#c79081', '#dfa579', 'black'),
('#09203f', '#537895', 'white'),
('#96deda', '#50c9c3', 'black'),
('#29323c', '#485563', 'white'),
('#ee9ca7', '#ffdde1', 'black'),
('#1e3c72', '#2a5298', 'white'),
('#ffc3a0', '#ffafbd', 'black'),
('#B7F8DB', '#50A7C2', 'black')
)

def darken(color):
    print(color)
    color = color[1:]
    r = int(int(color[0:2], 16) * 0.8)
    g = int(int(color[2:4], 16) * 0.8)
    b = int(int(color[4:6], 16) * 0.8)
    res = "#%0.2X%0.2X%0.2X" % (r,g,b)
    print(res)
    return res

class MyHandler(http.server.SimpleHTTPRequestHandler):

    def do_POST(self):
        """Serve a POST request."""
        r, info = self.deal_post_data()
        print((r, info, "by: ", self.client_address))
        f = BytesIO()
        f.write(b'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">')
        f.write(b"<html>\n<title>Upload Result Page</title>\n")
        f.write(b"<body>\n<h2>Upload Result Page</h2>\n")
        f.write(b"<hr>\n")
        if r:
            f.write(b"<strong>Success:</strong>")
        else:
            f.write(b"<strong>Failed:</strong>")
        f.write(info.encode())
        f.write(("<br><a href=\"%s\">back</a>" % self.headers['referer']).encode())
        f.write(b"<hr><small>Powerd By: bones7456, check new version at ")
        f.write(b"<a href=\"http://li2z.cn/?s=SimpleHTTPServerWithUpload\">")
        f.write(b"here</a>.</small></body>\n</html>\n")
        length = f.tell()
        f.seek(0)
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header("Content-Length", str(length))
        self.end_headers()
        if f:
            self.copyfile(f, self.wfile)
            f.close()

    def deal_post_data(self):
        content_type = self.headers['content-type']
        if not content_type:
            return (False, "Content-Type header doesn't contain boundary")
        boundary = content_type.split("=")[1].encode()
        remainbytes = int(self.headers['content-length'])
        line = self.rfile.readline()
        remainbytes -= len(line)
        if not boundary in line:
            return (False, "Content NOT begin with boundary")
        line = self.rfile.readline()
        remainbytes -= len(line)
        fn = re.findall(r'Content-Disposition.*name="file"; filename="(.*)"', line.decode())
        if not fn:
            return (False, "Can't find out file name...")
        path = self.translate_path(self.path)
        fn = os.path.join(path, fn[0])
        line = self.rfile.readline()
        remainbytes -= len(line)
        line = self.rfile.readline()
        remainbytes -= len(line)
        try:
            out = open(fn, 'wb')
        except IOError:
            return (False, "Can't create file to write, do you have permission to write?")

        preline = self.rfile.readline()
        remainbytes -= len(preline)
        while remainbytes > 0:
            line = self.rfile.readline()
            remainbytes -= len(line)
            if boundary in line:
                preline = preline[0:-1]
                if preline.endswith(b'\r'):
                    preline = preline[0:-1]
                out.write(preline)
                out.close()
                return (True, "File '%s' upload success!" % fn)
            else:
                out.write(preline)
                preline = line
        return (False, "Unexpect Ends of data.")

    def send_head(self):
        """Common code for GET and HEAD commands.
        This sends the response code and MIME headers.
        Return value is either a file object (which has to be copied
        to the outputfile by the caller unless the command was HEAD,
        and must be closed by the caller under all circumstances), or
        None, in which case the caller has nothing further to do.
        """
        path = self.translate_path(self.path)
        f = None
        if os.path.isdir(path):
            if not self.path.endswith('/'):
                # redirect browser - doing basically what apache does
                self.send_response(301)
                self.send_header("Location", self.path + "/")
                self.end_headers()
                return None
            for index in "index.html", "index.htm":
                index = os.path.join(path, index)
                if os.path.exists(index):
                    path = index
                    break
                else:
                    return self.list_directory(path)
        ctype = self.guess_type(path)
        try:
            # Always read in binary mode. Opening files in text mode may cause
            # newline translations, making the actual size of the content
            # transmitted *less* than the content-length!
            f = open(path, 'rb')
        except IOError:
            self.send_error(404, "File not found")
            return None
        self.send_response(200)
        self.send_header("Content-type", ctype)
        fs = os.fstat(f.fileno())
        self.send_header("Content-Length", str(fs[6]))
        self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
        self.end_headers()
        return f

    def list_directory(self, path):
        """Helper to produce a directory listing (absent index.html).
        Return value is either a file object, or None (indicating an
        error).  In either case, the headers are sent, making the
        interface the same as for send_head().
        """
        try:
            list = os.listdir(path)
        except OSError:
            self.send_error(
                HTTPStatus.NOT_FOUND,
                "No permission to list directory")
            return None
        list.sort(key=lambda a: a.lower())
        r = []
        try:
            displaypath = urllib.parse.unquote(self.path,
                                               errors='surrogatepass')
        except UnicodeDecodeError:
            displaypath = urllib.parse.unquote(path)
        displaypath = os.getcwd() + displaypath
        displaypath = html.escape(displaypath, quote=False)
        enc = sys.getfilesystemencoding()
        title = displaypath
        r.append('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" '
                 '"http://www.w3.org/TR/html4/strict.dtd">')
        r.append('<html>\n<head>')
        r.append('<meta http-equiv="Content-Type" '
                 'content="text/html; charset=%s">' % enc)
        style="""<style>
        body {
            padding-bottom: 20px;
        }
        h1 {
        margin: 2.5em auto;
        }
        h1,h2 {
        text-align: center;
        }
        td {
        weight: bold;
        }
        tr:hover {
        cursor: pointer;
        }
        .size, .modified {
        text-align: right;
        white-space: nowrap;
        }
        .filename a {
        text-decoration: none;
        color: inherit;
        }
        table {
        width: 80%;
        border-collapse: collapse;
        margin:0 auto 50px auto;
        }
        /* Zebra striping */
        tr:nth-of-type(odd) {
        background: #55555522;
        }
        th {
            font-weight: bold;
        }
        td, th {
            padding: 10px;
            border: 1px solid #000;
            text-align: left;
            font-size: 18px;
        }
        table td:first-child {
          text-overflow: ellipsis;
        }
        th.modified {
        min-width: 8em;
        }
    @media screen and (max-width: 1000px) {
        table { border: 0; width: 90%; }
    }
    @media screen and (max-width: 800px) {
        table { border: 0; width: 95%; }
    }
    @media screen and (max-width: 600px) {

    table { border: 0; width: 100%; }

    table thead { display: none; }

    table tr {
    display: block;
    }

    table td:first-child {
    display: block;
    text-align: right;
    font-size: 13px;
    }

    table td {
    display: none;
    }

    }
.upload-btn-wrapper {
  position: relative;
  overflow: hidden;
  display: inline-block;
}

.btn {
  color: white;
  background-color: #55555522;
  padding: 8px 20px;
  font-size: 20px;
  font-weight: bold;
  border: none;
}
.upload-btn-wrapper:hover input[type=file] {
  background-color: #55555588;
}

.upload-btn-wrapper input[type=file] {
  font-size: 100px;
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0;
}
</style>
        """
        styleformatted = """
        <style>
        html {{
        color: {color4};
        background: linear-gradient(45deg, {color1}, {color2}) no-repeat center center fixed;
        font-family: monospace;
        background-size: cover;
        }}
        tr:hover {{
        background-color: {color3}66!important ;
        }}
        </style>
        """
        colors = random.choice(colordic)
        styleformatted = styleformatted.format(color1 = colors[0], color2 = colors[1],
                                               color3 = darken(colors[0]),
                                               color4 = colors[2])
        r.append(style)
        r.append(styleformatted)
        r.append('<title>%s</title>\n</head>' % title)
        r.append('<body>\n<h1>Giuseppe\'s Quickshare</h1>')
        r.append('<h2>%s</h2>\n' % title)
        r.append('<table>\n')
        r.append('<thead><tr class=row><th>File name</th><th>File Size</th><th class=modified>Last Modified</th></tr></thead>\n')
        r.append('<tbody>\n')
        for name in list:
            fullname = os.path.join(path, name)
            displayname = linkname = name
            # Append / for directories or @ for symbolic links
            if os.path.isdir(fullname):
                displayname = name + "/"
                linkname = name + "/"
            if os.path.islink(fullname):
                displayname = name + "@"
                # Note: a link to a directory displays with @ and links with /
            link = urllib.parse.quote(linkname, errors='surrogatepass')
            r.append('<tr onclick="window.location=\'%s\'">' % link)
            r.append('<td data-column="File name" class="filename cell"><a href="%s">%s</a></td>'
                    % (link, html.escape(displayname, quote=False)))
            size, power = format_bytes(os.path.getsize(fullname))
            r.append('<td data-column="File size" class="size cell">%s %s</td>' % (round(size, 1), power))
            modified = datetime.datetime.fromtimestamp(os.path.getmtime(fullname)).strftime('%Y-%m-%d')
            r.append('<td data-column="Last Modified" class="modified">%s </td>' % modified)
            r.append('</tr>')
        r.append('</tbody></table>\n</body>\n</html>\n')
        r.append("""
                 <form ENCTYPE="multipart/form-data" method="post">
                 <div class="upload-btn-wrapper">
                    <button class="btn">Upload a file</button>
                    <input type="file" name="myfile" />
                 </div>
                 <div class="upload-btn-wrapper">
                    <button class="btn">Submit</button>
                    <input type="submit" name="submit" />
                 </div>
                 </form>
                 """)
        encoded = '\n'.join(r).encode(enc, 'surrogateescape')
        f = io.BytesIO()
        f.write(encoded)
        f.seek(0)
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-type", "text/html; charset=%s" % enc)
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        return f

    def translate_path(self, path):
        """Translate a /-separated PATH to the local filename syntax.
        Components that mean special things to the local file system
        (e.g. drive or directory names) are ignored.  (XXX They should
        probably be diagnosed.)
        """
        # abandon query parameters
        path = path.split('?',1)[0]
        path = path.split('#',1)[0]
        path = posixpath.normpath(urllib.parse.unquote(path))
        words = path.split('/')
        words = [_f for _f in words if _f]
        path = os.getcwd()
        for word in words:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir): continue
            path = os.path.join(path, word)
        return path

    def copyfile(self, source, outputfile):
        """Copy all data between two file objects.
        The SOURCE argument is a file object open for reading
        (or anything with a read() method) and the DESTINATION
        argument is a file object open for writing (or
        anything with a write() method).
        The only reason for overriding this would be to change
        the block size or perhaps to replace newlines by CRLF
        -- note however that this the default server uses this
        to copy binary data as well.
        """
        shutil.copyfileobj(source, outputfile)

    def guess_type(self, path):
        """Guess the type of a file.
        Argument is a PATH (a filename).
        Return value is a string of the form type/subtype,
        usable for a MIME Content-type header.
        The default implementation looks the file's extension
        up in the table self.extensions_map, using application/octet-stream
        as a default; however it would be permissible (if
        slow) to look inside the data to make a better guess.
        """

        base, ext = posixpath.splitext(path)
        if ext in self.extensions_map:
            return self.extensions_map[ext]
        ext = ext.lower()
        if ext in self.extensions_map:
            return self.extensions_map[ext]
        else:
            return self.extensions_map['']

    if not mimetypes.inited:
        mimetypes.init() # try to read system mime.types
    extensions_map = mimetypes.types_map.copy()
    extensions_map.update({
        '': 'application/octet-stream', # Default
        '.py': 'text/plain',
        '.c': 'text/plain',
        '.h': 'text/plain',
        })


handler = MyHandler


with http.server.ThreadingHTTPServer(("", PORT), handler) as httpd:
    print("Serving At Localhost PORT", PORT)
    httpd.serve_forever()
