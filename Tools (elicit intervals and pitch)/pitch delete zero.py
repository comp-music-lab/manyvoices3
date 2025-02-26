import os
import pandas as pd

# Define folder paths
input_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/combined audio f0/"  # Source folder
output_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/pitch delete zero/"  # Target folder

# Ensure the target folder exists
os.makedirs(output_folder, exist_ok=True)

# Iterate through all csv files in the input_folder
for filename in os.listdir(input_folder):
    if filename.endswith(".csv"):  # ensure the file is a csv
        file_path = os.path.join(input_folder, filename)

        # Read the csv
        df = pd.read_csv(file_path)

        # Remove rows where the f0 column has a value of 0
        df_filtered = df[df["f0"] != 0]

        # Save to the output_folder，keeping the original filename
        output_path = os.path.join(output_folder, filename)
        df_filtered.to_csv(output_path, index=False)

print("All files have been processed and saved to the pitch delete zero folder")