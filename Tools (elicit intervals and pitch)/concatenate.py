from pydub import AudioSegment
import os
import re

# Input and output directories
input_folder = '/Users/betty/Desktop/manyvoices3_pilot/split audio/'
output_folder = '/Users/betty/Desktop/manyvoices3_pilot/combined/'
os.makedirs(output_folder, exist_ok=True)

# Match filename pattern: language_location_group_condition_speaker_number.wav
# Example: Mandarin_Auckland_C1_sing_20_0001.wav
pattern = re.compile(
    r'^([A-Za-z]+)_([A-Za-z]+)_([A-Za-z]\d)_([A-Za-z]+)_([0-9]+)_(\d+)\.wav$'
)

# Group files by: language + location + group + gender + speaker + condition
groups = {}

for f in os.listdir(input_folder):
    if f.endswith('.wav'):
        match = pattern.match(f)
        if match:
            language, location, group, condition, speaker, number = match.groups()

            # Convert speaker to int for gender classification
            speaker_int = int(speaker)

            # Define gender based on speaker number
            if speaker_int in [2, 4, 6, 7, 10, 11, 19]:
                gender = 'M'
            else:
                gender = 'F'

            # New grouping key format
            key = f"{language}_{location}_{group}_{gender}_{speaker}_{condition}"

            if key not in groups:
                groups[key] = []
            # Store both path and number for sorting
            groups[key].append((os.path.join(input_folder, f), int(number)))

# Combine audio files within each group
for key, file_info in groups.items():
    # Sort by number to ensure correct order
    file_info.sort(key=lambda x: x[1])
    files = [f for f, _ in file_info]

    print(f"🔊 Combining {len(files)} files for {key} ...")

    # Merge audio files
    combined = AudioSegment.empty()
    for file in files:
        sound = AudioSegment.from_wav(file)
        combined += sound

    # Export the combined file
    out_path = os.path.join(output_folder, f"{key}.wav")
    combined.export(out_path, format="wav")

print("✅ All audio files combined successfully!")
