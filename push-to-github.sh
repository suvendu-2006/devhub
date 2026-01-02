#!/bin/bash

# Script to push DevHub to GitHub
# Usage: ./push-to-github.sh YOUR_GITHUB_USERNAME

if [ -z "$1" ]; then
    echo "❌ Error: GitHub username required"
    echo "Usage: ./push-to-github.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "Example: ./push-to-github.sh johndoe"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME="devhub"

echo "🚀 Setting up GitHub repository..."
echo "Repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""

# Check if remote already exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  Remote 'origin' already exists. Removing it..."
    git remote remove origin
fi

# Add remote
echo "📡 Adding remote repository..."
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# Push to GitHub
echo "⬆️  Pushing code to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! Your code has been pushed to GitHub!"
    echo "🌐 View your repository at: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
else
    echo ""
    echo "❌ Error: Failed to push to GitHub"
    echo ""
    echo "Make sure you:"
    echo "1. Created the repository on GitHub first"
    echo "2. Are authenticated (GitHub CLI or HTTPS credentials)"
    echo "3. Have the correct repository name"
    echo ""
    echo "To create the repository, go to: https://github.com/new"
fi

