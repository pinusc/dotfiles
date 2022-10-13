import operator

from qutebrowser.api import interceptor, message


# Any return value other than a literal 'False' means we redirected
REDIRECT_MAP = {
    "reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
    "www.reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
    "youtube.com": operator.methodcaller('setHost', 'yewtu.be'),
    "www.youtube.com": operator.methodcaller('setHost', 'yewtu.be'),
    "youtu.be": operator.methodcaller('setHost', 'yewtu.be'),
    "twitter.com": operator.methodcaller('setHost', 'nitter.net'),
    "www.twitter.com": operator.methodcaller('setHost', 'nitter.net'),
    "termbin.com": operator.methodcaller('setHost', 'l.termbin.com'),
    "medium.com": operator.methodcaller('setHost', 'scribe.rip'),
}  # type: typing.Dict[str, typing.Callable[..., typing.Optional[bool]]]


def int_fn(info: interceptor.Request):
    """Block the given request if necessary."""
    if (info.resource_type != interceptor.ResourceType.main_frame or
        info.request_url.scheme() in {"data", "blob"}):
        return
    url = info.request_url
    redir = REDIRECT_MAP.get(url.host())
    if redir is not None and redir(url) is not False:
        message.info("Redirecting to " + url.toString())
        info.redirect(url)


interceptor.register(int_fn)
