# Function to display available models
display_available_models() {
  echo "Available models:"
  find ~/.cache/lm-studio/models/ -mindepth 2 -maxdepth 2 -type d -name "*GGUF*" -printf "%P\n"
}

# Check if the path and model arguments are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "============================================================"
  echo "Usage: $0 <lmstudio_app_image_path> <input_folder> <output_folder> <model_name>"
  echo
  display_available_models
  echo "============================================================"
  exit 1
fi

APP_IMAGE=$1
INPUT_FOLDER=$2
OUTPUT_FOLDER=$3
MODEL_NAME=$4

# Validate model existence
MODEL_PATH=~/.cache/lm-studio/models/$MODEL_NAME
if [ ! "$MODEL_PATH" ]; then
  echo "============================================================"
  echo "Model '$MODEL_NAME' not found in ~/.cache/lm-studio/models/"
  echo
  display_available_models
  echo "============================================================"
  exit 1
fi

# load modules
module purge
module load Conda/3
conda activate LMStudio

# create virtualbuffer
Xvfb :1 -screen 0 1024x768x16 &
export DISPLAY=:1
sleep 5

# run LMStudio
"$APP_IMAGE" &
sleep 17

# set up lms
lms server start
lms load $MODEL_NAME --context-length=8192 # works on dev node, nio GPU

# Loop over text files in input folder
for file in "$INPUT_FOLDER"/*; do
  [ -e "$file" ] || continue
  # Run the model on each text file
  python3 run_model.py "$OUTPUT_FOLDER" "$file" "$MODEL_PATH"
done

# stop lms
lms unload -a
lms server stop

# kill Xvfb and LMStudio
kill %1 %2
