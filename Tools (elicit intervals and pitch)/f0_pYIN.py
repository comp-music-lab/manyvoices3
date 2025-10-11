import librosa
import numpy as np
import datetime, csv
import os
import re

##
def get_f0(audiofilepath, output_folder):
    sr_target = 44100  # Target sample rate
    time_step = 0.005  # Sample f0 every 0.005 seconds
    hop_length = int(sr_target * time_step)  # Compute hop_length to ensure 0.005s interval
    frame_length = 2048

    #### Load audio files ####
    y, sr = librosa.load(audiofilepath, mono=True, sr=sr_target)  # Load audio file and convert to mono
     #### Extract fundamental frequency (F0) using pYIN ####
    f0, voiced_flag, voiced_probs = librosa.pyin(
        y, sr=sr, fmin=25, fmax=2048, frame_length=frame_length, hop_length=hop_length
    )
    t = librosa.times_like(f0, sr=sr_target, hop_length=hop_length)  # Compute time axis timestamps

    #### Handle missing values (NaN) ####
    f0[np.isnan(f0)] = 0  # Replace NaN values with 0 to avoid calculation errors

    #### Remove zero-F0 values ####
    valid_idx = (f0 > 50) & (f0 < 600)
    f0 = f0[valid_idx]
    t = t[valid_idx]  # Ensure time aligns with f0

    # Compute audio duration
    duration = librosa.get_duration(y=y, sr=sr)

    # Parse filename to extract language, date, speaker, and condition
    filename = os.path.basename(audiofilepath).replace('.wav', '')
    match = re.match(r"(\w+)_(\d+)_(\d+)_(\w+)", filename)

    if match:
        language, date, speaker, condition = match.groups()
    else:
        language, date, speaker, condition = ("conv", "sing")

    # Generate output csv file path
    filename = os.path.basename(audiofilepath).replace('.wav', '_f0.csv')
    outputfilepath = os.path.join(output_folder, filename)

    # Write to csv file
    with open(outputfilepath, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["time", "f0", "language", "date", "speaker", "condition"])
        for i in range(len(t)):
            writer.writerow([t[i], f0[i], language, date, speaker, condition])

    print(f"✅Processing completed: {filename} → {outputfilepath}")


if __name__ == "__main__":
    # Set input folder containing audio files and output folder for csv files
    input_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/combined audio/"  # Replace with your audio file path
    output_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/pitch delete zero/"  # Replace with csv output file path

    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)

    # Iterate through all .wav files in the folder
    wav_files = [f for f in os.listdir(input_folder) if f.endswith('.wav')]

    # Process each audio file
    for wav_file in wav_files:
        audio_path = os.path.join(input_folder, wav_file)
        get_f0(audio_path, output_folder)

    print("🎉 All audio files processed！")
