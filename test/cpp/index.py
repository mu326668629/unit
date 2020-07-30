#/usr/bin/python3

def application(env, start_response):
    body=b"hello world"

    status = "200 OK"
    start_response(status, [
        ("Content-Type", "text/plain"),
        ("Content-Length", str(len(body)))
    ])
    return body