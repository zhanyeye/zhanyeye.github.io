---  
title: "实现一个 action discussions-to-blog-action"  
date: "2025-03-12T15:52:57Z"  
draft: false  
discussion_id: "D_kwDOCretjM4AevIg"  
---  


- https://github.com/zhanyeye/discussions-to-blog-action



A GitHub Action to sync GitHub Discussions from a specific category to Markdown files, making it easy to use them in static site generators like Hugo or Jekyll.  

## Inputs  

| Name              | Description                                      | Required | Default         |  
|-------------------|--------------------------------------------------|----------|-----------------|
| `categories`     | Categories from the Discussions that have been selected to be converted to blog posts              | Yes      | N/A             |  
| `output_dir`      | The directory to save Markdown files.            | Yes      | `content/posts` |

## Example Usage  

```yaml  
name: Sync Discussions to Blog  

on:
  discussion:  
    types: [created, edited, deleted]  

jobs:  
  sync-discussions:  
    runs-on: ubuntu-latest  
    steps:  
      - name: Checkout repository  
        uses: actions/checkout@v3  

      - name: Sync Discussions  
        uses: zhanyeye/discussions-to-blog-action@main
        with:   
          categories： Announcements, General
          output_dir: content/posts
      
      - name: Commit and Push Changes  
        uses: stefanzweifel/git-auto-commit-action@v4  
        with:  
          commit_message: "Sync Discussions to Markdown"  
          branch: main  
          file_pattern: '*.json *.md'




aaaaaaaaaaaaaaaa