---
title: hi
index:
  - name: posts
    sort_by: date
    glob: posts/*.md
    slice:
      - 10
---

## Posts

{% for item in site.computed.index.posts %}
{% assign time = item.date | date: "%Y-%m-%d" %}

- <time datetime="{{time}}">{{time}}</time>: [{{item.title}}]({{item.url}})

{% endfor %}
