---  
title: "create-event-test"  
date: "2025-03-09T12:41:56Z"  
draft: false  
discussion_id: "D_kwDOCretjM4AevDc"  
---  

提高代码的 **可测试性** 需要从以下几个方面进行优化：

1. **消除硬编码路径与依赖**  
   将 `/github/workspace` 和 `/github/workflow/event.json` 等硬编码路径提供为函数参数，使得这些路径可以在测试中替换为临时目录或自定义路径。

2. **减少全局依赖的操作（like `os`, `open`）**  
   将文件系统的操作封装，避免直接耦合到代码中。例如，文件读写（`open`）、路径拼接（`os.path.join`）等直接操作，可以通过注入依赖或使用抽象层分离。

3. **使用依赖注入（缩小测试范围）**  
   将文件操作（比如 `load_mapping` 和 `save_mapping`）、API 请求方法（`fetch_discussion_by_id`）注入到函数中，测试时只需关心逻辑，不依赖实际的文件写入或网络请求。

以下是基于这几点的优化后的实现：

---

### 优化后的核心代码

#### 优化的设计要点：
- **路径注入**：支持传入文件路径（`event_file_path`、`workspace_root`），简化测试时替换路径的复杂度。
- **函数依赖注入**：支持自定义的文件操作函数（如 `open`、`os.makedirs`、`os.path.exists`），方便 mock。
- **抽象 API 数据源**：将网络请求 `fetch_discussion_by_id` 函数作为可注入的接口，提升测试灵活性。

经过优化后的代码如下：

```python
import os
import json


def fetch_discussion_by_id(github_token, repo_owner, repo_name, discussion_id):
    """
    从 GitHub 的 GraphQL API 获取讨论数据 — 保持为原始实现。
    """
    import requests

    GRAPHQL_API = "https://api.github.com/graphql"
    query = """
    query($repoOwner: String!, $repoName: String!, $discussionId: ID!) {
      repository(owner: $repoOwner, name: $repoName) {
        discussion(id: $discussionId) {
          id
          title
          body
          createdAt
          updatedAt
        }
      }
    }
    """
    headers = {
        "Authorization": f"Bearer {github_token}",
        "Content-Type": "application/json"
    }
    payload = {
        "query": query,
        "variables": {
            "repoOwner": repo_owner,
            "repoName": repo_name,
            "discussionId": discussion_id
        }
    }
    response = requests.post(GRAPHQL_API, json=payload, headers=headers)
    response.raise_for_status()
    data = response.json()
    return data["data"]["repository"]["discussion"]


def sanitize_filename(title):
    """
    对标题进行处理，转换为合法的文件名
    """
    return title.strip().replace(" ", "-").replace("/", "-").replace("\\", "-").lower()


def write_markdown(discussion, output_dir, workspace_root, open_func, makedirs_func):
    """
    将 Discussion 数据写入 Markdown 文件。
    """
    created_at = discussion["createdAt"]
    year = created_at[:4]
    month = created_at[5:7]
    post_dir = os.path.join(workspace_root, output_dir, year, month)
    makedirs_func(post_dir, exist_ok=True)

    filename = f"{sanitize_filename(discussion['title'])}.md"
    filepath = os.path.join(post_dir, filename)

    # 构造 Markdown 内容（含 Front Matter）
    front_matter = f"""---
title: "{discussion['title']}"
date: "{discussion['createdAt']}"
draft: false
discussion_id: "{discussion['id']}"
---
"""
    content = front_matter + "\n" + discussion["body"]

    # 写入文件
    with open_func(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"[INFO] 文件已生成：{filepath}")

    return filepath


def delete_markdown(filepath, exists_func, remove_func):
    """
    删除指定 Markdown 文件
    """
    if exists_func(filepath):
        remove_func(filepath)
        print(f"[INFO] 删除 Markdown 文件：{filepath}")
    else:
        print(f"[WARNING] 文件不存在：{filepath}")


def load_mapping(output_dir, workspace_root, open_func, exists_func):
    """
    加载映射文件
    """
    map_path = os.path.join(workspace_root, output_dir, ".discussions_map.json")
    if exists_func(map_path):
        with open_func(map_path, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


def save_mapping(output_dir, workspace_root, mapping, open_func):
    """
    保存映射文件
    """
    map_path = os.path.join(workspace_root, output_dir, ".discussions_map.json")
    with open_func(map_path, "w", encoding="utf-8") as f:
        json.dump(mapping, f, indent=2)
    print(f"[INFO] 映射文件已更新：{map_path}")


def process_created(github_token, repo_owner, repo_name, discussion_id, output_dir, workspace_root, mapping, fetch_func, open_func, makedirs_func):
    """
    处理新增事件
    """
    discussion = fetch_func(github_token, repo_owner, repo_name, discussion_id)
    filepath = write_markdown(discussion, output_dir, workspace_root, open_func, makedirs_func)
    mapping[discussion_id] = filepath


def process_deleted(discussion_id, output_dir, workspace_root, mapping, exists_func, remove_func):
    """
    处理删除事件
    """
    filepath = mapping.pop(discussion_id, None)
    if filepath:
        delete_markdown(filepath, exists_func, remove_func)


def run(github_token, repo_owner, repo_name, category_id, output_dir, delete_on_removed, event_file_path, workspace_root, fetch_func, open_func, exists_func, makedirs_func, remove_func):
    """
    主函数入口
    """
    # 读取事件文件
    if not exists_func(event_file_path):
        raise FileNotFoundError(f"无法找到事件文件 {event_file_path}，请确保在正确路径下运行。")
    with open_func(event_file_path, "r", encoding="utf-8") as f:
        event = json.load(f)
    print(f"[INFO] 读取事件文件：{event}")

    # 加载映射文件
    mapping = load_mapping(output_dir, workspace_root, open_func, exists_func)

    # 遍历处理事件
    for item in event.get("discussions", []):
        discussion_id = item["id"]
        action = item["action"].lower()

        if action == "created":
            print(f"[INFO] 处理新增事件: {discussion_id}")
            process_created(github_token, repo_owner, repo_name, discussion_id, output_dir, workspace_root, mapping, fetch_func, open_func, makedirs_func)
        elif action == "deleted":
            print(f"[INFO] 处理删除事件: {discussion_id}")
            process_deleted(discussion_id, output_dir, workspace_root, mapping, exists_func, remove_func)
        else:
            print(f"[WARNING] 未知的 action: {action}")

    # Write back mapping file
    save_mapping(output_dir, workspace_root, mapping, open_func)
```

---

### 测试优化

1. 使用 `mock` 对 `open`, `makedirs`, `remove`, `fetch_discussion_by_id` 等进行模拟。
2. 通过临时目录测试真实路径对文件系统的影响。

下面是一个以 `unittest` 编写的测试用例：

```python
import unittest
from unittest.mock import MagicMock, patch, mock_open
import tempfile
import os
import json
import discussions_to_blog


class TestDiscussionsToBlogRun(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.workspace_root = self.temp_dir.name
        self.output_dir = "content/posts"
        self.event_file_path = os.path.join(self.workspace_root, "event.json")

        self.mock_fetch = MagicMock()
        self.mock_fetch.return_value = {
            "id": "D_test",
            "title": "Test Discussion",
            "body": "This is a test body",
            "createdAt": "2025-01-01T00:00:00Z",
            "updatedAt": "2025-01-01T00:00:00Z",
        }

        # Write a mocked event file
        event = {"discussions": [{"id": "D_test", "action": "created"}]}
        with open(self.event_file_path, "w", encoding="utf-8") as f:
            json.dump(event, f)

    def tearDown(self):
        self.temp_dir.cleanup()

    @patch("os.makedirs", return_value=None)
    @patch("os.path.exists", side_effect=lambda path: os.path.isfile(path))
    @patch("builtins.open", new_callable=mock_open)
    @patch("os.remove", return_value=None)
    def test_run_created_event(self, mock_remove, mock_open, mock_exists, mock_makedirs):
        discussions_to_blog.run(
            github_token="dummy_token",
            repo_owner="dummy_owner",
            repo_name="dummy_repo",
            category_id="dummy_category",
            output_dir=self.output_dir,
            delete_on_removed=False,
            event_file_path=self.event_file_path,
            workspace_root=self.workspace_root,
            fetch_func=self.mock_fetch,
            open_func=open,
            exists_func=os.path.exists,
            makedirs_func=os.makedirs,
            remove_func=os.remove
        )

        # Assert that the Markdown file was written
        makedirs_context = os.path.join(self.workspace_root, self.output_dir, "2025", "01")
        mock_makedirs.assert_called_with(makedirs_context, exist_ok=True)

        # Assert mapping file has been updated
        mapping_path = os.path.join(self.workspace_root, self.output_dir, ".discussions_map.json")
        with open(mapping_path, "r", encoding="utf-8") as f:
            mapping = json.load(f)
        self.assertIn("D_test", mapping)


if __name__ == '__main__':
    unittest.main()
```
