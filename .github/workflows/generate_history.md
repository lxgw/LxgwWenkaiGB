name: Generate HISTORY.md

on:
  workflow_dispatch: # 允许你手动点击按钮触发

jobs:
  build-history:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      # 把脚本写进 Actions 环境里
      - name: Create script
        run: |
          cat << 'EOF' > generate_history.py
          import subprocess
          import json
          import re

          cmd = ["gh", "release", "list", "--limit", "200", "--json", "tagName,publishedAt"]
          result = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
          releases = json.loads(result.stdout)

          history_content = "# 版本更新记录\n\n"

          for rel in releases:
              tag = rel["tagName"]
              date = rel["publishedAt"][:10]
              view_cmd = ["gh", "release", "view", tag, "--json", "body"]
              view_result = subprocess.run(view_cmd, capture_output=True, text=True, encoding='utf-8')
              body = json.loads(view_result.stdout).get("body", "")
              
              # 清洗规则
              if "Assets 里的 zip 格式压缩包" in body:
                  body = body.split("Assets 里的 zip 格式压缩包")[0]
              body = re.sub(r'^> \[!(?:NOTE|WARNING|IMPORTANT|TIP|CAUTION)\]\n(?:>.*\n*)*', '', body, flags=re.MULTILINE)
              body = re.sub(r'^\*\*Full Changelog\*\*:.*$', '', body, flags=re.MULTILINE)
              body = re.sub(r'\[.*?\]\(https://github\.com/.*?compare.*?\)', '', body, flags=re.MULTILINE)
              body = re.sub(r'^.*更新日志.*$', '', body, flags=re.MULTILINE)
              body = re.sub(r'\n{3,}', '\n\n', body).strip()
              
              if body: 
                  history_content += f"## [{tag}] - {date}\n\n{body}\n\n---\n\n"

          with open("HISTORY.md", "w", encoding="utf-8") as f:
              f.write(history_content)
          EOF

      - name: Run script
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: python generate_history.py

      - name: Upload History File
        uses: actions/upload-artifact@v4
        with:
          name: HISTORY-FILE
          path: HISTORY.md
