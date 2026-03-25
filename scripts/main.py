import json
import time
import subprocess
from pathlib import Path
import os
import glob
from llama_cpp import Llama

MODEL_DIR = "./model"
models = dict()

for model_file in glob.glob("./model/*gguf"):
    print(model_file)
    model_name = model_file.split("/")[2].split(".")[0]
    models[model_name] = os.path.abspath(model_file)
# print(models)
system_prompt = """You are an expert computer science tutor specializing in Data Structures and Algorithms (DSA).

Your goal is to teach concepts clearly and effectively, not just provide answers.

Follow these principles strictly:

1. Explain Like a Teacher
- Start with intuition before formal definitions.
- Use simple language first, then refine with technical precision.
- Break complex ideas into small, digestible steps.

2. Structure Your Teaching
For every topic:
- Intuition / real-world analogy
- Formal explanation
- Step-by-step example
- Time and space complexity
- Common mistakes

3. Be Interactive
- Ask at least one question to check understanding.
- Offer a small practice problem after explanation.
- Adjust difficulty gradually.

4. Encourage Thinking
- Do NOT immediately give full solutions to problems.
- Provide hints first, then full solution only if necessary.

5. Use Clear Formatting
- Use bullet points, code blocks, and labeled sections.
- Highlight key insights.

6. Be Concise but Complete
- Avoid unnecessary verbosity.
- Ensure no critical step is skipped.

7. Adapt to the Student
- If the student seems confused, simplify further.
- If the student is comfortable, go deeper.

Your success is measured by how well the student understands, not by how much information you provide.
"""
questions = [
    "Explain the difference between arrays and linked lists.",
    "Teach stack and queue with real-world analogies.",
    "Explain binary search including edge cases.",
    "Teach the two pointers technique with examples.",
    "Teach graph traversal DFS vs BFS.",
    "Explain dynamic programming using Fibonacci.",
    "Compare greedy algorithms vs dynamic programming.",
    "Explain recursion vs iteration.",
    "Teach backtracking using subsets or N-Queens.",
    "Explain binary tree traversals."
]

results = []

for model_name, model_file in models.items():

    model_path = str(Path(MODEL_DIR) / model_file)

    print(f"\n==============================")
    print(f"Testing model: {model_name}")
    print(f"==============================")

    for question in questions:

        prompt = system_prompt + "\n\nStudent Question: " + question

        start = time.time()

        cmd = [
            "./llama-cli",
            "-m", model_path,
            "-p", prompt,
            "-n", "256",
            "--temp", "0.7"
        ]

        try:

            output = subprocess.check_output(cmd, text=True)

            latency = time.time() - start

            token_estimate = len(output.split())
            tokens_per_sec = token_estimate / latency

            result = {
                "model": model_name,
                "question": question,
                "latency_sec": round(latency, 2),
                "tokens_generated": token_estimate,
                "tokens_per_sec": round(tokens_per_sec, 2),
                "answer": output
            }

            results.append(result)

            print(f"✅ {model_name} | {round(latency,2)}s")

        except Exception as e:

            print(f"❌ Error with {model_name}: {e}")

# ==============================
# SAVE RESULTS
# ==============================

with open("benchmark_results.json", "w") as f:
    json.dump(results, f, indent=4)

print("\nResults saved to benchmark_results.json")