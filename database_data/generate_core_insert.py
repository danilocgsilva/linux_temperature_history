import sys
from table_data import get_table_name
import re

def main():
    for line in sys.stdin:
        core_name = get_core_name(line)
        temperature = get_temperature(line)
        string_to_return = "INSERT INTO buffer (key, value) VALUES ('{}', '{}');".format(core_name, temperature)
        print(string_to_return)

def get_core_name(line: str) -> str:
    return line.split(':')[0].strip().replace(" ", "_").replace("-", "_").lower()

def get_temperature(sensor_entry: str) -> str:
    pattern = r':\s*([+-]?\d+\.?\d*)°C'
    
    match = re.search(pattern, sensor_entry)
    if match:
        return float(match.group(1))
    return None

if __name__ == "__main__":
    main()
