"""
This entire script was written by ChatGPT.
The R code it outputs is not runnable until manually fixed.
"""
import pandas as pd
import ollama
import subprocess
import tempfile
import re
from pathlib import Path

# --- CONFIG ---
file_path = Path("~/repos/RLadies/Estadísticas-Climatológicas-Normales-período-1981-2010.tsv").expanduser()
model_name = "llama3:8b"

# --- STEP 1: Load preview of dataset ---
print(f"Reading preview of {file_path}")
df = pd.read_csv(file_path, sep="\t", nrows=5)
print(df.head())

# Convert preview to a compact markdown string for context
preview_str = df.head().to_markdown(index=False)

# --- STEP 2: Build Llama prompt ---
prompt = f"""
You are an expert R data scientist.

Here is a preview of a TSV dataset:

{preview_str}

Write *only* valid R code (no markdown, no explanations) that:
1. Reads the full TSV file located at '{file_path}'
2. Cleans the column names if needed
3. Calculates and prints the average annual temperature per station
4. Produces a simple ggplot2 bar chart of average temperature per station
5. Saves the plot as 'avg_temp_plot.png'
"""

print("\n🦙 Generating R code using Llama...")
response = ollama.chat(model=model_name, messages=[{"role": "user", "content": prompt}])
r_code_raw = response["message"]["content"]

# --- STEP 3: Clean the R code ---
# Extract code between triple backticks if present
match = re.search(r"```r?\n(.*?)```", r_code_raw, re.DOTALL | re.IGNORECASE)
if match:
    r_code = match.group(1).strip()
else:
    # Otherwise, just strip obvious non-code lines
    lines = r_code_raw.splitlines()
    code_lines = [ln for ln in lines if not ln.lower().startswith("here is") and not ln.strip().startswith("```")]
    r_code = "\n".join(code_lines).strip()

print("\n✅ Cleaned R code:\n", r_code)

# --- STEP 4: Save and run the cleaned R code ---
with tempfile.NamedTemporaryFile(mode="w", suffix=".R", delete=False) as temp_file:
    temp_file.write(r_code)
    temp_path = temp_file.name

print(f"\n🚀 Running generated R script: {temp_path}")
try:
    subprocess.run(["Rscript", temp_path], check=True)
except subprocess.CalledProcessError as e:
    print(f"\n❌ R script failed with exit code {e.returncode}")
    print("Check the R output above for details.")