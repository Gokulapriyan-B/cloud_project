#!/usr/bin/env python3
"""
Hadoop Streaming MapReduce job to count total lines in each file
This version works with the python-code-disasters repository
"""

import sys
import os

# Mapper
def mapper():
    for line in sys.stdin:
        # Get the input file name from environment variable
        filename = os.environ.get('mapreduce_map_input_file', 'stdin')
        # Extract just the filename from the full path
        if '/' in filename:
            filename = filename.split('/')[-1]
        print(f"{filename}\t1")

# Reducer
def reducer():
    current_file = None
    current_count = 0
    
    for line in sys.stdin:
        line = line.strip()
        filename, count = line.split('\t')
        count = int(count)
        
        if current_file == filename:
            current_count += count
        else:
            if current_file:
                print(f'"{current_file}": {current_count}')
            current_file = filename
            current_count = count
    
    if current_file:
        print(f'"{current_file}": {current_count}')

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'reduce':
        reducer()
    else:
        mapper()
