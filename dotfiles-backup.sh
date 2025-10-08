#!/bin/bash

# Dotfiles Automatic Backup Script
# This script automatically commits and pushes changes to GitHub

# Set the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"
LOG_FILE="$HOME/.dotfiles/backup.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if there are changes to commit
has_changes() {
    cd "$DOTFILES_DIR"
    if [[ -n $(git status --porcelain) ]]; then
        return 0  # Has changes
    else
        return 1  # No changes
    fi
}

# Main backup function
backup_dotfiles() {
    log_message "Starting dotfiles backup..."
    
    # Change to dotfiles directory
    cd "$DOTFILES_DIR" || {
        log_message "ERROR: Could not change to dotfiles directory"
        exit 1
    }
    
    # Check if there are changes
    if has_changes; then
        log_message "Changes detected, proceeding with backup..."
        
        # Add all changes
        git add .
        
        # Create commit message with timestamp
        COMMIT_MSG="Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Commit changes
        if git commit -m "$COMMIT_MSG"; then
            log_message "Changes committed successfully"
            
            # Push to GitHub
            if git push origin main; then
                log_message "Changes pushed to GitHub successfully"
            else
                log_message "ERROR: Failed to push to GitHub"
                exit 1
            fi
        else
            log_message "ERROR: Failed to commit changes"
            exit 1
        fi
    else
        log_message "No changes detected, skipping backup"
    fi
    
    log_message "Backup completed"
}

# Run the backup
backup_dotfiles
