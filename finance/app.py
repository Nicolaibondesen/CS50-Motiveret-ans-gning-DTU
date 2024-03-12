import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    user_id = session["user_id"]

    stocks = db.execute("SELECT symbol, SUM(shares) AS shares, price FROM transactions WHERE user_id = (?) GROUP BY symbol HAVING SUM(shares) > 0", user_id)

    cash = db.execute("SELECT cash FROM users WHERE id = (?)", user_id)

    totalcash=cash[0]["cash"]
    total_value= int(totalcash)

    for stock in stocks:
        symbol = stock["symbol"]
        lookup_data = lookup(symbol)
        if lookup_data:
            stock["price"] = lookup_data["price"]
            stock["total"] = stock["price"] * stock["shares"]
            total_value += stock["total"]

    return render_template("index.html", database=stocks, users=cash, total_value=total_value)



@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    if request.method == "POST":
        #to be sure a symol was comitted.
        symbol = request.form.get("symbol").upper()
        shares = request.form.get("shares")
        if not symbol:
            return apology("Symbol required", 400)
        elif not shares or not shares.isdigit() or int(shares)<=0:
            return apology("A positive whole integer of shares required", 400)
#lookup stock

        quote_data = lookup(symbol)
        if quote_data is None:
            return apology("Symbol not found", 400)

#get users balance
        price = quote_data["price"]
        total_cost = int(shares) * price

        user_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])

        if user_cash[0]["cash"] < total_cost:
            return apology("Im sorry, there is not sufficient funds on your account")
    #update userbalance
        db.execute("UPDATE users SET cash = cash - ? WHERE id = ?", total_cost, session["user_id"])

        timeofbuy = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        db.execute("INSERT INTO transactions (user_id, symbol, shares, price, timestamp) VALUES (?,?,?,?,?)",session["user_id"], symbol, shares, price,timeofbuy)
        return redirect("/")
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    user_id=session["user_id"]

    transactions = db.execute("SELECT * FROM transactions WHERE user_id = ? ORDER BY timestamp DESC", user_id)
    return render_template("history.html", transactions=transactions)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    if request.method =="POST":
    #confirm sumbyl is submitted
        quoted = lookup(request.form.get("symbol"))
        if quoted is None:
            return apology("Invalid symbol", 400)

        return render_template("quoted.html", quoted = quoted)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    session.clear()

    def has_uppercase(password):
        return any(char.isupper() for char in password)
    def has_digit(password):
        return any(char.isdigit() for char in password)

    """Register user"""
    if request.method == "POST":
        username = request.form.get("username")
         # Ensure username was submitted
        if not username:
            return apology("Username required", 400)

    # Ensure password was submitted
        password = request.form.get("password")
        if not password:
            return apology("Password required", 400)

    # Ensure password confirmation was submitted
        confirmation = request.form.get("confirmation")
        if not confirmation:
         return apology("You must confirm your password", 400)

        if password != confirmation:
            return apology("Password do not match", 400)
        if not has_uppercase(password):
            return apology ("Password must contaion at least one uppercase letter", 400 )
        if not has_digit(password):
            return apology ("Password must contaion at least one digit", 400 )

        username = username.lower()

        # Generate password hash
        rows = db.execute("SELECT * FROM users WHERE LOWER(username) = ?", username)
        if len(rows) > 0:
            return apology("Username already exists", 400)
# Insert user into the database
        db.execute("INSERT INTO users (username, hash) VALUES(?, ?)",
                   username, generate_password_hash(password))
        new_user = db.execute("SELECT * FROM users WHERE lOWER(username) = ?", username)
# Remember which user has registered
        session["user_id"] = new_user[0]["id"]
        return redirect("/login")
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    user_id = session["user_id"]

    if request.method == "GET":
        symbols = db.execute("SELECT symbol FROM transactions WHERE user_id = ? GROUP by symbol HAVING SUM(shares)>0", user_id)
        return render_template("sell.html", symbols=symbols)

    if request.method == "POST":
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")

        if not symbol:
            return apology("Symbol required",400)
        elif not shares or not shares.isdigit() or int(shares) <= 0:
            return apology("Share amount must be a positive interger",400)

        shares=int(shares)

        quote = lookup(symbol)
        if quote is None:
            return apology("Invalid Symbol")

        name = quote["name"]
        price = quote["price"]

        old_shares = db.execute("SELECT SUM(shares) AS total_shares FROM transactions WHERE user_id = ? AND symbol =?",user_id, symbol)
        avai_shares = old_shares[0]["total_shares"]
        if shares > avai_shares:
            return apology("insufficient shares in your account", 400)
        sold_shares = price * shares

        user_cash= db.execute("SELECT cash FROM users WHERE id= ?", user_id)
        updated_cash = user_cash[0]["cash"] + sold_shares
        db.execute("UPDATE users SET cash = ? WHERE id = ?", updated_cash, user_id)
        db.execute("INSERT INTO transactions (user_id, symbol, shares, price) VALUES (?,?,?,?)", user_id, symbol, -shares, price)

        return redirect("/")


