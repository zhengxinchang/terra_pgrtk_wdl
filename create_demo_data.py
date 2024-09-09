import random

def generate_sequence(length):
    return ''.join(random.choice('ATCG') for _ in range(length))

def extract_subsequences(sequence, num_subsequences, subsequence_length):
    return [sequence[i:i+subsequence_length] for i in random.sample(range(len(sequence)-subsequence_length+1), num_subsequences)]

def save_to_fasta(filename, sequences, labels=None):
    with open(filename, 'w') as f:
        for i, seq in enumerate(sequences):
            label = labels[i] if labels else f"Sequence_{i+1}"
            f.write(f">{label}\n{seq}\n")

# 生成主序列
main_sequence = generate_sequence(1000)

# 提取子序列
subsequences = extract_subsequences(main_sequence, 10, 100)

# 保存主序列到ref.fa
save_to_fasta('ref.fa', [main_sequence], ['Reference'])

# 将子序列分成两组
test1_sequences = subsequences[:5]
test2_sequences = subsequences[5:]

# 保存子序列到test1.fa和test2.fa
save_to_fasta('test1.fa', test1_sequences)
save_to_fasta('test2.fa', test2_sequences)

print("所有序列已成功生成和保存。")