import pandas as pd
import os

## Set your own pathway
input_file = "./NuskaEtAl(Czech)/Inter-rater reliability/result_duration_tier_1.txt"
output_dir = "./NuskaEtAl(Czech)/Inter-rater reliability/"


df = pd.read_csv(input_file)


split_cols = df['fileName'].str.replace('.TextGrid', '', regex=False).str.split('_', expand=True)
split_cols.columns = ['Annotator', 'Language', 'Location', 'Group', 'Condition']
df = pd.concat([df, split_cols], axis=1)

## Modify it to the participant ID you asked Jia to annotate.
df_filtered = df[df['IntervalName'] == 11]


for annotator in df_filtered['Annotator'].unique():
    annotator_df = df_filtered[df_filtered['Annotator'] == annotator]
    annotator_folder = os.path.join(output_dir, annotator)
    os.makedirs(annotator_folder, exist_ok=True)


    for condition in ['conv', 'sing']:
        condition_df = annotator_df[annotator_df['Condition'] == condition]
        if not condition_df.empty:
            # Rename p19
            out_path = os.path.join(annotator_folder, f"p11_{condition}.csv")
            condition_df.to_csv(out_path, index=False)
            print(f"✅ Saved: {out_path}")

print("🎉 All files have been generated successfully!")
