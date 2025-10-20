from pydub import AudioSegment
import os
import re

# 输入和输出路径
input_folder = '/Users/betty/Desktop/Mandarin real data_group level/Splited Mandarin Auckland'
output_folder = '/Users/betty/Desktop/Mandarin real data_group level/combined'
os.makedirs(output_folder, exist_ok=True)

# 匹配文件名模式：language_location_group_condition_speaker_编号.wav
# 例子：Mandarin_Auckland_C1_sing_20_0001.wav
pattern = re.compile(
    r'^([A-Za-z]+)_([A-Za-z]+)_([A-Za-z]\d)_([A-Za-z]+)_([0-9]+)_(\d+)\.wav$'
)

# 按 group + condition + speaker 组织文件
groups = {}

for f in os.listdir(input_folder):
    if f.endswith('.wav'):
        match = pattern.match(f)
        if match:
            language, location, group, condition, speaker, number = match.groups()
            key = f"{language}_{location}_{group}_{condition}_{speaker}"
            if key not in groups:
                groups[key] = []
            # 存储路径和编号，用于排序
            groups[key].append((os.path.join(input_folder, f), int(number)))

# 逐组合并
for key, file_info in groups.items():
    # 按编号排序
    file_info.sort(key=lambda x: x[1])
    files = [f for f, _ in file_info]

    print(f"🔊 Combining {len(files)} files for {key} ...")

    # 合并音频
    combined = AudioSegment.empty()
    for file in files:
        sound = AudioSegment.from_wav(file)
        combined += sound

    # 输出文件名
    out_path = os.path.join(output_folder, f"{key}_combined.wav")
    combined.export(out_path, format="wav")

print("✅ All audio files combined successfully!")

