#!/usr/bin/env python3
import sys, time, select, subprocess

DROP_LINES = {"[Start speaking]"}
STOP_PHRASE = ["stop transcript", "stop the transcript", "stop transcribing", "end transcript"]

IDLE_COMMIT = 0.25

def commit_line(typed: str, line: str):
    line = line.rstrip()
    if not line:
        return typed, False

    low = line.strip().lower()
    if low == STOP_PHRASE:
        print(line, file=sys.stderr, flush=True)
        raise SystemExit(0)

    if line in DROP_LINES:
        print(line, file=sys.stderr, flush=True)
        return typed, False

    new_typed = apply_diff(typed, line)
    return new_typed, (new_typed != typed)

def wtype_text(s: str):
    if s:
        subprocess.run(["wtype", "--", s], check=False)

def wtype_key(key: str, n: int = 1):
    for _ in range(n):
        subprocess.run(["wtype", "-k", key], check=False)

def apply_diff(typed: str, target: str) -> str:
    i = 0
    L = min(len(typed), len(target))
    while i < L and typed[i] == target[i]:
        i += 1
    del_count = len(typed) - i
    if del_count > 0:
        wtype_key("BackSpace", del_count)
    ins = target[i:]
    if ins:
        wtype_text(ins)
    return target

class StreamRenderer:
    def __init__(self):
        self.line = ""
        self.col = 0
        self.state = 0
        self.csi = bytearray()
        self.had_lf = False

    def feed(self, data: bytes):
        self.had_lf = False
        for b in data:
            if self.state == 0:
                if b == 0x1b:
                    self.state = 1
                elif b == 0x0d:      # CR
                    self.col = 0
                elif b == 0x0a:      # LF
                    self.had_lf = True
                    # DO NOT clear here; main loop will commit then reset
                elif b == 0x08:      # BS
                    if self.col > 0:
                        self.col -= 1
                        self.line = self.line[:self.col] + self.line[self.col+1:]
                elif b == 0x09:
                    self._put('\t')
                elif b >= 0x20:
                    self._put(chr(b))
            elif self.state == 1:
                if b == ord('['):
                    self.state = 2
                    self.csi.clear()
                else:
                    self.state = 0
            else:
                self.csi.append(b)
                if (65 <= b <= 90) or (97 <= b <= 122):
                    self._handle_csi(bytes(self.csi))
                    self.state = 0

    def reset_line(self):
        self.line = ""
        self.col = 0
        self.had_lf = False

    def _put(self, ch: str):
        if self.col > len(self.line):
            self.line += " " * (self.col - len(self.line))
        if self.col == len(self.line):
            self.line += ch
        else:
            self.line = self.line[:self.col] + ch + self.line[self.col+1:]
        self.col += 1

    def _handle_csi(self, seq: bytes):
        if not seq:
            return
        final = seq[-1:]
        params = seq[:-1].decode(errors="ignore")
        if final in (b'K', b'k'):
            n = int(params.strip()) if params.strip().isdigit() else 0
            if n == 2:
                self.line = ""
                self.col = 0
            elif n == 0:
                self.line = self.line[:self.col]
            elif n == 1:
                self.line = (" " * self.col) + self.line[self.col:]

renderer = StreamRenderer()
typed = ""
pending = None
last_rx = time.time()
stdin = sys.stdin.buffer

try:
    while True:
        r, _, _ = select.select([stdin], [], [], 0.05)
        now = time.time()

        if r:
            chunk = stdin.read1(4096)
            if not chunk:
                break
            last_rx = now
            renderer.feed(chunk)
            pending = renderer.line.rstrip()

            if renderer.had_lf:
                did_type = False
                if pending is not None:
                    typed, did_type = commit_line(typed, pending)

                if did_type:
                    wtype_key("Return", 1)

                typed = ""
                pending = None
                renderer.reset_line()
        if pending is not None and (now - last_rx) >= IDLE_COMMIT:
            typed, _ = commit_line(typed, pending)
            pending = None

except SystemExit:
    pass

# final flush (no return)
if pending is not None:
    typed = apply_diff(typed, pending)
