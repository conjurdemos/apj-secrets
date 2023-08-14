import os
from ispss import *

from flask import (Flask, request, render_template, redirect, session,
                   make_response)


app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    action="default"
    username=""
    message=""
    if request.method == 'GET':
        action="default"

    if request.method == 'POST':
        message = onboard(request.form['email'], request.form['displayname'], request.form['phone']  )
        username = request.form['email'].split("@")[0]
        action="complete"


    return render_template(
        'index.html',
        action=action,
        username=username,
        message=message
    )


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8084, debug=True)
