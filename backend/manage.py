from core.settings import server

def main():
    try:
        server.run(debug=True, port=8080)
    except Exception as error:
        print(
            "\n",
            f": {error}",
            "\n"
        )

if __name__ == "__main__":
    main()
