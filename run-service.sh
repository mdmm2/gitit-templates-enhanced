#!/bin/bash
#
# This scripts run gitit as a service on a given data volume. If the wiki
# does not exist, it will initialize it with enhanced templates.

TMPL_PATH=/data/gitit-templates-enhanced
WIKI_PATH=/data/gitit-wiki
RUN_PATH=/data/gitit-run

GITIT_CFG="$WIKI_PATH/gitit.conf"
if [ ! -f "$GITIT_CFG" ]; then
    echo "Initializing gitit.conf"
    cp "$TMPL_PATH/sample.gitit.conf" "$GITIT_CFG"
    mkdir -p "$WIKI_PATH/logs"
    if [ ! -d "$WIKI_PATH/templates" ]; then
	echo "Initializing wiki templates"
	cp -rf "$TMPL_PATH/templates" "$WIKI_PATH"
    fi
    if [ ! -d "$WIKI_PATH/static" ]; then
	echo "Initializing wiki static files"
	cp -rf "$TMPL_PATH/static" "$WIKI_PATH"
    fi
    if [ ! -d "$WIKI_PATH/wikidata" ]; then
	echo "Initializing wikidata"
	cp -rf "$TMPL_PATH/wikidata" "$WIKI_PATH"
	pushd "$WIKI_PATH/wikidata" >/dev/null
	git init .
	git config user.name "gitit"
	git config user.email "gitit@gitit-wiki.com"
	git add .
	git commit -m "Initialize wiki with help pages"
	popd >/dev/null
    fi
fi

SUPERVISORD_CFG="$RUN_PATH/supervisord.conf"
if [ ! -f "$SUPERVISORD_CFG" ]; then
    echo "Initializing supervisord.conf"
    cp "$TMPL_PATH/sample.supervisord.conf" "$SUPERVISORD_CFG"
fi

pushd "$RUN_PATH" >/dev/null
echo "Running supervisord as ${USER}($UID)"
supervisord -c "$SUPERVISORD_CFG"
popd >/dev/null
