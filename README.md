# LM Studio Batch Processor

This repository contains a shell script and a Python script to process multiple JSON input files using a specified model from LM Studio. The script will generate responses for each input file and save them to an output folder.

## Prerequisites

1. **LM Studio**: Follow these [instructions to download and set up LM Studio](https://docs.icer.msu.edu/2024-06-19_LabNotebook_LM_Studio_Install/). Ensure it has been run once to initialize required files.

2. **Executable Permissions**: Make sure the LM Studio `.AppImage` and the `lm-studio-batch-processor.sh` shell script have executable permissions.

## Setup

1. **Clone the Repository**:
```
git clone https://github.com/maxfah/lm-studio-batch-processor.git
cd lm-studio-batch-processor
```

2. **Create Conda Environment**:
```
conda env create -f environment.yml
```

3. **Bootstrap lms**:

Ensure you are connected to a dev node, then run:
```
~/.cache/lm-studio/bin/lms bootstrap
lms
```

## Running `lm-studio-batch-processor.sh`

### Script Arguments
* **App Image Path**: Path to the LM Studio AppImage executable.
* **Input Folder**: Path to the folder containing input JSON files.
* **Output Folder**: Path to the folder where the output files will be saved.
* **Model Name**: The name of the model to be used, relative to ~/.cache/lm-studio/models/.

### Usage
```
./lm-studio-batch-processor.sh <lmstudio_app_image_path> <input_folder> <output_folder> <model_name>
```

#### Example
```
./lm-studio-batch-processor.sh /path/to/LM_Studio-0.2.25.AppImage /path/to/input_folder /path/to/output_folder lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF
```

### Formatting Input JSON Files
Each input JSON file should contain the following structure:

```
{
  "system": "System message or instructions here.",
  "user": "User message or prompt here."
}
```

#### Example JSON

```
{
  "system": "Always answer in rhymes.",
  "user": "Introduce yourself."
}
```

Place these JSON files in the designated input folder. The script will process each file, generate a response, and save it to the output folder with _response.txt appended to the original filename.

## Example Workflow

1. **Prepare Input Files**:
Ensure your input JSON files are in a folder, for example, /path/to/input_folder.

2. **Run the Script**:
```
./lm-studio-batch-processor.sh /path/to/input_folder /path/to/output_folder lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF
```

3. **Check Outputs**:
The responses will be saved in /path/to/output_folder with filenames corresponding to the input files.

## Notes
* Ensure the model specified in the model_name argument exists in ~/.cache/lm-studio/models/.
* Modify the your_bash_script.sh and run.py scripts if you need custom behavior or additional processing.
