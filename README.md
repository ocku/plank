# Plank

A tiny static site generator in Perl.

- bin/cc: **49**sloc
- bin/new: **32**sloc

3 dependencies though.

## Getting Started

### Clone the repo

    git clone https://github.com/ocku/plank.git

### Install the dependencies

    cpan YAML::Tiny Template::Liquid Text::MultiMarkdown

### Make your first post

    make post title="Hello World!"

### Build

    make

And that's it! The compiled site will be written to the `.dist` directory.

## Template System

Plank uses Liquid for a "double compilation" process. The `www` file is compiled first, and its compiled content is added to the `site.content` metadata key, which the frame can then access along with the rest of the metadata when it is also compiled.

Basically, you can use liquid in the frame and in the file to be compiled and placed in the frame.

## Folder Structure

- `bin` contains the executables used by `make`
- `frame` contains the frames (templates) used in the compilation process
- `static` contains static files to be copied to `.dist` after the compilation process ends.
- `www` contains everything to be compiled (from MD to HTML).

## Special Properties

`site.computed` cannot be set by the user, and it can only be accessed in the template.

### Indexing

> **Note:**
> As of now there is no support for pagination

You can create and use as many indices as you like in a single file by defining the `index` property in the file's metadata.

Consider this example from `www/index.md`:

```yml
---
title: hi
index:
  # the name to be used to access this index in the
  # template.
  - name: posts

    # this pattern is matched on the same working directory
    # as the file being compiled.
    # given a folder structure as follows:
    #
    # my/
    #   dir/
    #       file_being_compiled.md
    #       dir2/file_to_index.md
    #
    # the pattern to access
    # file_to_index.md from file_being_compiled.md
    # would simply be dir2/* or ./dir2/*
    glob: posts/*.md

    # (optional) sort by a metadata field of the files
    # being indexed. must be numeric!
    sort_by:
      date

      # (optional) slice the results from the
      # [(start)th] to the [(end)th], given
      # `slice: [start, end]`
      #
      # defaults to [0, 10], and if only given one number,
      # it will be set as the higher limit.
      #
      # for example in this case, [10] becomes [0, 10].
    slice:
      - 10
---
```

This definition gives the template access to the metadata of all files that match the glob, which is accessible through the `index.{name}` property of `site.computed`. See the example below, also from `www/index.md`:

```md
## Posts

{% for item in site.computed.index.posts %}
{% assign time = item.date | date: "%Y-%m-%d" %}

- <time datetime="{{time}}">{{time}}</time>: [{{item.title}}]({{item.url}})

{% endfor %}
```
