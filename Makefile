SITE_CONF_FILE				:= site.yml
SITE_POSTS_PER_PAGE 	:= 15

STATIC_DIR						:= static
POSTS_DIR 	 					:= posts
TEMPLATE_DIR 					:= templates
DATA_DIR 	 						:= .data
DIST_DIR 	 						:= .dist
DIST_POSTS_DIR				:= $(DIST_DIR)/$(POSTS_DIR)

STATIC_FILES 					:= $(shell find $(STATIC_DIR) -type f)
POSTS_SRC_FILES				:= $(wildcard $(POSTS_DIR)/*.md)
POSTS_DIST_FILES  		:= $(addprefix $(DIST_DIR)/, $(POSTS_SRC_FILES:%.md=%.html))

POST_TEMPLATE_FILE 		:= $(TEMPLATE_DIR)/post.html
INDEX_TEMPLATE_FILE 	:= $(TEMPLATE_DIR)/index.html

INDEX_PAGE_NUMBER			:= $(shell printf '%d\n' \
														"$$(( $(words $(POSTS_SRC_FILES)) / $(SITE_POSTS_PER_PAGE) ))")

INDEX_DATA_FILES			:= $(addprefix $(DATA_DIR)/, index.yml \
														$(addsuffix .yml, $(shell seq 1 $(INDEX_PAGE_NUMBER))))

INDEX_DIST_FILES			:= $(INDEX_DATA_FILES:$(DATA_DIR)/%.yml=$(DIST_DIR)/%.html)

all: $(DIST_DIR) $(DATA_DIR) $(POSTS_DIST_FILES) $(INDEX_DIST_FILES)

$(DIST_DIR)/%.html: $(DATA_DIR)/%.yml $(INDEX_TEMPLATE_FILE) $(SITE_CONF_FILE)
	./scripts/compile -t $(INDEX_TEMPLATE_FILE) -m $(SITE_CONF_FILE),$< > $@

$(INDEX_DATA_FILES): $(POSTS_SRC_FILES)
	./scripts/index -d $(DATA_DIR) -c $(SITE_POSTS_PER_PAGE) $^

$(DIST_POSTS_DIR)/%.html: $(POSTS_DIR)/%.md $(POST_TEMPLATE_FILE) $(SITE_CONF_FILE)
	./scripts/compile -f $< -t $(POST_TEMPLATE_FILE) -m $(SITE_CONF_FILE) > $@

$(DATA_DIR):
	mkdir -pv $@

$(DIST_DIR): $(STATIC_FILES)
	mkdir -pv $@/$(POSTS_DIR)
	cp -r $(STATIC_DIR)/* $@

.PHONY: clean
clean:
	rm -rf $(DATA_DIR)
	rm -rf $(DIST_DIR)

.PHONY: post
URL=$(shell printf "$(title)" \
	| tr [A-Z] [a-z] \
	| tr -cd '[:alnum:] [:space:]' \
	| tr '[:space:]' '-')

post:
ifneq ($(wildcard $(POST_SRC_DIR)/$(URL).md),)
	@echo "[e] A post with url=$(URL)" already exists
	@exit 1
else
	printf -- "---\ntitle: %s\ndate: %s\nsort: %d\n---\n" \
			"$(title)" "$(shell date '+%F')" "$(shell date '+%s')" > "$(POST_SRC_DIR)/$(URL).md"
endif