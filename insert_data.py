import sys

def main():
    input_data = []
    for line in sys.stdin:
        input_data.append(line.strip() + ' with esteroids')

    result = "\n".join(input_data)

    print(result)

if __name__ == "__main__":
    main()
