import json
import subprocess

def run(event, context):
    subprocess.run(['checkup', '--store'], check=True)
    return {
        'statusCode': 200,
        'body': {}
    }
