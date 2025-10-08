#!/bin/bash

# Simple 1Password Environment Setup
# Replaces hardcoded API keys with 1Password references

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if 1Password CLI is available
if ! command -v op &> /dev/null; then
    echo "1Password CLI (op) not found. Please install it first."
    echo "Visit: https://1password.com/downloads/command-line/"
    exit 1
fi

print_status "1Password CLI found"

# Function to create a simple API key item in 1Password
create_api_items() {
    print_status "Creating API key items in 1Password..."
    
    # Create individual items for each API key
    op item create \
        --category "Password" \
        --title "Anthropic API Key" \
        --vault "Personal" \
        password="your-anthropic-api-key-here" 2>/dev/null || print_warning "Anthropic API Key item already exists"
    
    op item create \
        --category "Password" \
        --title "Notion API Key" \
        --vault "Personal" \
        password="your-notion-api-key-here" 2>/dev/null || print_warning "Notion API Key item already exists"
    
    op item create \
        --category "Password" \
        --title "Notion Database ID" \
        --vault "Personal" \
        password="your-notion-database-id-here" 2>/dev/null || print_warning "Notion Database ID item already exists"
    
    print_success "API key items created in 1Password"
    print_status "Update them with your actual keys in 1Password app"
}

# Function to update .zshrc with 1Password references
update_zshrc() {
    print_status "Updating .zshrc with 1Password references..."
    
    local zshrc_file="home/.zshrc"
    local backup_file="home/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f "$zshrc_file" ]]; then
        cp "$zshrc_file" "$backup_file"
        print_success "Backup created: $backup_file"
        
        # Remove existing API key exports
        sed -i '/^export ANTHROPIC_API_KEY=/d' "$zshrc_file"
        sed -i '/^export NOTION_API_KEY=/d' "$zshrc_file"
        sed -i '/^export NOTION_DATABASE_ID=/d' "$zshrc_file"
        
        # Add 1Password references at the top
        local temp_file=$(mktemp)
        cat > "$temp_file" << 'EOF'

# API Keys - Stored in 1Password
# Format: op://vault/item/field
export ANTHROPIC_API_KEY="op://Personal/Anthropic API Key/password"
export NOTION_API_KEY="op://Personal/Notion API Key/password"
export NOTION_DATABASE_ID="op://Personal/Notion Database ID/password"

EOF
        
        # Append original .zshrc content
        cat "$zshrc_file" >> "$temp_file"
        mv "$temp_file" "$zshrc_file"
        
        print_success "✅ .zshrc updated with 1Password references"
        print_status "Run 'source ~/.zshrc' or restart terminal to apply changes"
    else
        print_warning ".zshrc file not found at $zshrc_file"
    fi
}

# Function to show current setup
show_setup() {
    print_status "Current 1Password items:"
    op item list --vault "Personal" --categories "Password" | grep -E "(Anthropic|Notion)" || echo "No API key items found"
    echo ""
    print_status "Your .zshrc will reference these items using:"
    echo "  export ANTHROPIC_API_KEY=\"op://Personal/Anthropic API Key/password\""
    echo "  export NOTION_API_KEY=\"op://Personal/Notion API Key/password\""
    echo "  export NOTION_DATABASE_ID=\"op://Personal/Notion Database ID/password\""
}

# Main execution
case "${1:-setup}" in
    "setup")
        create_api_items
        update_zshrc
        echo ""
        print_success "Setup complete!"
        print_status "Next steps:"
        echo "1. Open 1Password app and update the API key items with your actual keys"
        echo "2. Run 'source ~/.zshrc' or restart your terminal"
        echo "3. Test with: echo \$ANTHROPIC_API_KEY"
        ;;
    "show")
        show_setup
        ;;
    "help")
        echo "Usage: $0 [setup|show|help]"
        echo "  setup - Create items and update .zshrc (default)"
        echo "  show  - Show current 1Password items"
        echo "  help  - Show this help"
        ;;
esac
