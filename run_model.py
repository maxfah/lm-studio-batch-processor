import os
import argparse
import json
from openai import OpenAI

# Set up argument parser
parser = argparse.ArgumentParser(description='Generate a response and save it to a specified output folder.')
parser.add_argument('output_folder', type=str, help='The folder where the output file will be saved')
parser.add_argument('input_file', type=str, help='Path to the input text file')
parser.add_argument('model_path', type=str, help='Path to the model within ~/.cache/lm-studio/models/')
args = parser.parse_args()

# Read input JSON file
with open(args.input_file, 'r') as file:
    json_data = json.load(file)

# Extract system and user messages
system_message = json_data['system']
user_message = json_data['user']

# Point to the local server
client = OpenAI(base_url="http://localhost:1234/v1", api_key="lm-studio")

completion = client.chat.completions.create(
  model=args.model_path,
  messages=[
    {"role": "system", "content": system_message},
    {"role": "user", "content": user_message}
  ],
  temperature=0.7,
)

response_content = completion.choices[0].message.content

# Define the output file path
output_file_name = os.path.splitext(os.path.basename(args.input_file))[0] + "_response.txt"
output_file_path = os.path.join(args.output_folder, output_file_name)

# Write the response content to the output file
with open(output_file_path, "w") as file:
    file.write(response_content)

print(f"Response for {args.input_file} has been written to {output_file_path}")
