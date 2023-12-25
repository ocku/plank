---
title: Plank
date: 2023-12-19
sort: 1703022441
---

# Plank

A tiny static site generator in Perl.

## Getting Started

### Clone the repo

    git clone https://github.com/ocku/plank.git

### Install the dependencies

Plank requires `YAML::Tiny`, `Text::Template` and `Text::MultiMarkdown` to be on your system. You can install them anywhere with the following command:

`cpan YAML::Tiny Text::Template Text::MultiMarkdown`

### Make your first post

    make post title="Hello World!"

### Build

And that's it! You can build the site with `make -j$(nproc)` and it will compile to `DIST_DIR`, which is `.dist` by default.

### Build + Watch

Alternatively, you can use a dev server and the `watch` command to update the build as you code and get live updates.

    # on terminal 1 ------------
    watch -n .5 make -j$(nproc)
    # on terminal 2 ------------
    # you can use your favourite dev server,
    # just make sure it's serving .dist
    npx serve .dist

## Configuration

### Metadata

You can configure the global metadata that all template files have access to by editing the `site.yml` file.

If left without a namespace, any configuration in `site.yml` may be overwritten by the post's metadata.

### Everything else

Plank is designed to be very simple, so there's no real framework for configuration. You can extend and customise the project as you like by writing your own code.

## File structure

Plank uses 4 directories, each with its own behaviour:

### Templates

The templates directory is used to store your templates. There are three standard templates that must always be present for Plank to work correctly:

- `index.html`: Used to create the index pages (along with pagination)
- `post.html`: Used to render posts

Templates are used by the compiler when rendering files. They are in the format specified by [`Text::Template`](https://metacpan.org/pod/Text::Template), allowing the execution of embedded Perl.

### Posts

All markdown files in the posts directory are considered by Plank as a file to compile. Each file in this directory should have a title, date and sort parameters, which are automatically created when you call `make post title="My Title"`

Any metadata parameters you add to the post will be accessible within the `post.html` template.

### Static

Everything from the static dir is copied to the `DIST_DIR` (`.dist`). Any clashing files will be overwritten.

### Scripts

Scripts used in the compilation process. You can extend these as you like. I used Perl for the indexer and compiler, but any other language will work just as well.

### Internal

Plank places temporary metadata needed for the compilation process in the `DATA_DIR` (`.data`), and the results in the `DIST_DIR` (`.dist`). You may rename these directories by editing the Makefile.

## Reference

This project uses pico.min.css from [pico](https://github.com/picocss/pico).
