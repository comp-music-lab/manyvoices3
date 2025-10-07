import os
import pandas as pd


def process_csv(input_csv, output_folder):
    """
    Parse the input CSV file and generate new CSV files based on speaker and condition.

    Parameters:
    - input_csv: str, path to the input CSV file
    - output_folder: str, path to store the output CSV files
    """
    # Ensure the output folder exists

    os.makedirs(output_folder, exist_ok=True)

    # Read the csv file
    df = pd.read_csv(input_csv, sep=",")  # If comma-separated, use `,`
    print(df.columns)

    # Ensure required columns exist
    required_columns = {"language", "date", "condition", "speaker", "duration", "start", "end", "IOI"}
    if not required_columns.issubset(df.columns):
        print("❌ CSV file is missing required columns！")
        return
        
    df["IOI"] = 1 / df["duration"]
    # Group by speaker and condition
    grouped = df.groupby(["speaker", "condition"])

    for (speaker, condition), group_data in grouped:
        # Retrieve filename info
        language = group_data.iloc[0]["language"]
        date = group_data.iloc[0]["date"]

        # Generate output filename
        output_filename = f"{language}_{date}_{speaker}_{condition}_IOI.csv"
        output_filepath = os.path.join(output_folder, output_filename)

        # Save the new CSV
        group_data.to_csv(output_filepath, index=False)

        print(f"✅ 生成: {output_filename}")


if __name__ == "__main__":
    # Set input csv path and output folder
    input_csv_file = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/IOI/Interval_Englishpilot.csv"  # Your actual CSV file path
    output_folder = "/Users/betty/Documents/MATLAB/song_speech_Mandarin/data/IOI/"  # Your output directory

    # Process CSV
    process_csv(input_csv_file, output_folder)

    print("🎉 All data processing is complete！")

