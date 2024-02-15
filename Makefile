www=www
dist=.dist
frame=frame
static=static
posts=$(www)/posts

www-dirs := $(shell find $(www) -type d)
www-files := $(shell find $(www) -type f -prune)

dist-dirs := $(www-dirs:$(www)%=$(dist)%)
dist-files := $(www-files:$(www)/%.md=$(dist)/%.html)

static-files := $(shell find $(static) -type f -prune)
static-files := $(static-files:$(static)%=$(dist)%)

frame-files := $(shell find $(frame) -type f -prune)

all: $(dist-dirs) $(dist-files) $(static-files) 

$(dist)/%.html: $(www)/%.md $(frame-files)
	bin/cc $< > $@

$(static-files): $(dist-dirs)
	cp -r $(static)/* $(dist)

$(dist-dirs):
	mkdir -pv $@

.PHONY: clean post

clean:
	rm -rf $(dist)

post:
	bin/new -b posts "$(title)" -f frame/post.html