import os
import pandas as pd
import re

def process_txt(input_txt, output_folder):
    """
    Parse the input TXT file, decode fileName, calculate IOI, add gender column,
    and generate new CSV files grouped by speaker and condition.
    """

    os.makedirs(output_folder, exist_ok=True)

    # === 1. Read the TXT file ===
    df = pd.read_csv(input_txt, sep=",", header=0)  # Comma-separated, first line as header
    print("✅ File loaded successfully! Columns:", df.columns.tolist())

    # === 2. Decode 'fileName' to extract metadata ===
    def decode_filename(fname):
        base = os.path.basename(fname).replace(".TextGrid", "")
        # Example: Mandarin_Auckland_C1_conv
        match = re.match(r"([A-Za-z]+)_([A-Za-z]+)_([A-Za-z0-9]+)_([a-z]+)", base)
        if match:
            return pd.Series(match.groups(), index=["language", "location", "group", "condition"])
        else:
            return pd.Series(["unknown"] * 4, index=["language", "location", "group", "condition"])

    df[["language", "location", "group", "condition"]] = df["fileName"].apply(decode_filename)

    # === 3. Calculate IOI ===
    df["IOI"] = 1 / df["duration"]

    # === 4. Add speaker and gender columns ===
    df["speaker"] = df["IntervalName"].astype(int)

    def assign_gender(speaker_id):
        male_speakers = {2, 4, 6, 7, 10, 11, 19}  # Modify this set if needed
        return "Male" if speaker_id in male_speakers else "Female"

    df["gender"] = df["speaker"].apply(assign_gender)

    # === 5. Save the combined dataset ===
    combined_csv_path = "/Users/betty/Desktop/manyvoices3_pilot/All_Speakers_IOI.csv"
    df.to_csv(combined_csv_path, index=False)
    print(f"💾 Combined CSV saved: {combined_csv_path}")

    
    # === 6. Group by speaker and condition, and save separate CSV files ===
    grouped = df.groupby(["speaker", "condition"])

    for (speaker, condition), group_data in grouped:
        language = group_data.iloc[0]["language"]
        location = group_data.iloc[0]["location"]
        group = group_data.iloc[0]["group"]

        output_filename = f"{language}_{location}_{group}_{speaker}_{condition}_IOI.csv"
        output_filepath = os.path.join(output_folder, output_filename)

        group_data.to_csv(output_filepath, index=False)
        print(f"✅ Generated file: {output_filename}")

    print("🎉 All data processing is complete!")


if __name__ == "__main__":
    # Update the paths accordingly
    input_txt_file = "/Users/betty/Desktop/manyvoices3_pilot/result_duration_tier_1.txt"
    output_folder = "/Users/betty/Desktop/manyvoices3_pilot/IOI/"

    process_txt(input_txt_file, output_folder)

