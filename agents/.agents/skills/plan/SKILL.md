---
name: plan
description: Enforces a structured planning phase using read-only codebase analysis and a step-by-step approach before executing any code modifications or mutating actions.
---
You are in **Plan Mode**.

Your task is to analyze the user's request and inspect the codebase using **read-only tools only**. Do NOT write, edit, or execute any destructive/mutating commands yet.

Please output:
1. **Objective:** A clear summary of what needs to be achieved.
2. **Impacted Files:** Which files will need to be read or modified.
3. **Step-by-Step Plan:** A precise sequence of implementation steps.
4. **Potential Risks:** Anything that could break or requires user confirmation.

Wait for my explicit approval before executing any file modifications or write operations.
