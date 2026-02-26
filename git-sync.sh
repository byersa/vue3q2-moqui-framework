#!/bin/bash
# git-sync.sh - Synchronize a Moqui component with its remote repository

COMPONENT=$1

if [ -z "$COMPONENT" ]; then
    echo "Usage: ./git-sync.sh <component-name>"
    exit 1
fi

COMPONENT_PATH="runtime/component/$COMPONENT"

# Special case for 'moqui-ai' if it's not in runtime/component (though it should be)
if [ ! -d "$COMPONENT_PATH" ]; then
    # Some components might be in other locations or the user might pass the relative path
    COMPONENT_PATH="$COMPONENT"
fi

if [ ! -d "$COMPONENT_PATH" ]; then
    echo "Error: Component directory $COMPONENT_PATH does not exist."
    exit 1
fi

echo "Syncing $COMPONENT..."
cd "$COMPONENT_PATH" || exit 1

# Check if it's a git repo
if [ ! -d ".git" ]; then
    echo "Error: $COMPONENT_PATH is not a git repository."
    exit 1
fi

# Add all changes
git add .

# Commit with a generic message if there are changes
HAS_CHANGES=false
if ! git diff-index --quiet HEAD --; then
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "Committing changes at $TIMESTAMP..."
    git commit -m "git-sync: $TIMESTAMP"
    HAS_CHANGES=true
else
    echo "No local changes to commit for $COMPONENT."
fi

# Pull latest changes
echo "Pulling latest changes..."
git pull --rebase

# Push changes if we had changes or if the pull brought in something new to sync back? 
# (Actually, if pull brought things in, we don't necessarily need to push unless we committed)
if [ "$HAS_CHANGES" = true ]; then
    echo "Pushing changes..."
    git push
else
    echo "No local changes to push for $COMPONENT."
fi

echo "Sync for $COMPONENT complete."
