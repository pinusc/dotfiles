import operator

from qutebrowser.api import interceptor, message


# Any return value other than a literal 'False' means we redirected
REDIRECT_MAP = {
    "reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
    "www.reddit.com": operator.methodcaller('setHost', 'old.reddit.com'),
    "youtube.com": operator.methodcaller('setHost', 'yewtu.be'),
    "hckrnews.com": operator.methodcaller('setHost', 'news.ycombinator.com'),
    "www.youtube.com": operator.methodcaller('setHost', 'yewtu.be'),
    "twitter.com": operator.methodcaller('setHost', 'nitter.poast.org'),
    "www.twitter.com": operator.methodcaller('setHost', 'nitter.poast.org'),
    "x.com": operator.methodcaller('setHost', 'nitter.poast.org'),
    "www.x.com": operator.methodcaller('setHost', 'nitter.poast.org'),
    "imgur.com": operator.methodcaller('setHost', 'imgur.artemislena.eu'),
    # "termbin.com": operator.methodcaller('setHost', 'l.termbin.com'),
    # "youtu.be": operator.methodcaller('setHost', 'yewtu.be'),
    "medium.com": operator.methodcaller('setHost', 'scribe.rip'),
}  # type: typing.Dict[str, typing.Callable[..., typing.Optional[bool]]]


def int_fn(info: interceptor.Request):
    """Block the given request if necessary."""
    if (info.resource_type != interceptor.ResourceType.main_frame or
        info.request_url.scheme() in {"data", "blob"}):
        return
    url = info.request_url
    oldurl = url.url()
    # message.info(url)
    redir = REDIRECT_MAP.get(url.host())
    if redir is not None and redir(url) is not False:
        # __import__('pdb').set_trace()
        message.info(f"Redirecting {oldurl} to {url.toString()}")
        info.redirect(url)


interceptor.register(int_fn)
