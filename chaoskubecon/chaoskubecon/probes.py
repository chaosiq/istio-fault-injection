from typing import Any, Dict
import uuid

from chaoslib.exceptions import ActivityFailed
from chaoslib.types import Configuration, Secrets
from logzero import logger
import opentracing
import requests

__all__ = ["get_product_page_for_user",]


def get_product_page_for_user(url: str, username: str, timeout: int = 3,
                              configuration: Configuration = None, 
                              secrets: Secrets = None) -> Dict[str, Any]:
    with requests.Session() as s:
        headers = {}
        tracer = opentracing.tracer
        parent_span = tracer.activity_span
        with tracer.start_span("login-as-user", child_of=parent_span) as span:
            span.set_tag('http.method',"GET")
            span.set_tag('http.url', url)
            span.set_tag('span.kind', 'client')
            span.set_tag('username', username)
            tracer.inject(span, 'http_headers', headers)

            login_response = s.post(
                '{}/login'.format(url),
                data={"username": username, "password": ""},
                headers=headers)
            span.set_tag('http.status_code', login_response.status_code)

        r = None
        try:
            headers = {}
            span = tracer.start_span(
                "fetch-productpage-as-user", child_of=parent_span)
            span.set_tag('http.method',"GET")
            span.set_tag('http.url', url)
            span.set_tag('span.kind', 'client')
            span.set_tag('username', username)
            tracer.inject(span, 'http_headers', headers)
            r = s.get(
                '{}/productpage'.format(url), cookies=login_response.cookies,
                headers=headers, timeout=(timeout, timeout))
        except requests.exceptions.Timeout as x:
            logger.warning("Could not fetch productpage in due time")
            return False
        finally:
            if r:
                span.set_tag('http.status_code', r.status_code)
            span.finish()

    return True
