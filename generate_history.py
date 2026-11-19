import os
import json
import re
import urllib.request

repo = os.environ.get("GITHUB_REPOSITORY")
token = os.environ.get("GITHUB_TOKEN")

if not repo or not token:
    print("❌ 缺少必要的环境变量 (GITHUB_REPOSITORY 或 GITHUB_TOKEN)")
    exit(1)

# 通过 API 获取 Release 列表
url = f"https://api.github.com/repos/{repo}/releases?per_page=100"
req = urllib.request.Request(url)
req.add_header("Authorization", f"Bearer {token}")
req.add_header("Accept", "application/vnd.github.v3+json")

print("正在从 GitHub API 获取 Release...")
try:
    with urllib.request.urlopen(req) as response:
        releases = json.loads(response.read().decode('utf-8'))
except Exception as e:
    print(f"❌ 获取失败: {e}")
    exit(1)

history_content = "# 版本更新记录\n\n"

for rel in releases:
    tag = rel.get("tag_name", "")
    date = rel.get("published_at", "")[:10]
    body = rel.get("body", "") or ""
    
    # ---------------- 数据清洗 ----------------
    # 1. 截断 Magisk 警告及后续内容
    magisk_keyword = "Assets 里的 zip 格式压缩包"
    if magisk_keyword in body:
        body = body.split(magisk_keyword)[0]
    
    # 2. 移除 GitHub Alert 块
    body = re.sub(r'^> \[!(?:NOTE|WARNING|IMPORTANT|TIP|CAUTION)\]\n(?:>.*\n*)*', '', body, flags=re.MULTILINE)
    
    # 3. 移除 Full Changelog 及版本对比链接
    body = re.sub(r'^\*\*Full Changelog\*\*:.*$', '', body, flags=re.MULTILINE)
    body = re.sub(r'\[.*?\]\(https://github\.com/.*?compare.*?\)', '', body, flags=re.MULTILINE)
    
    # 4. 移除包含「更新日志」的整行
    body = re.sub(r'^.*更新日志.*$', '', body, flags=re.MULTILINE)
    
    # 5. 清理多余空行
    body = re.sub(r'\n{3,}', '\n\n', body).strip()
    # ----------------------------------------------

    if body: 
        history_content += f"## [{tag}] - {date}\n\n{body}\n\n---\n\n"

with open("HISTORY.md", "w", encoding="utf-8") as f:
    f.write(history_content)
    
print("✅ HISTORY.md 生成完毕！")
