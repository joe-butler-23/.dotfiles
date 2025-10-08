# Simple 1Password API Key Integration

This is the simple approach to replace hardcoded API keys with 1Password references.

## What It Does

Instead of:
```bash
export ANTHROPIC_API_KEY="sk-your-actual-key-here"
```

You now have:
```bash
export ANTHROPIC_API_KEY="op://Personal/Anthropic API Key/password"
```

## Quick Setup

1. **Run the setup script:**
   ```bash
   ./scripts/simple-env-setup.sh
   ```

2. **Update your keys in 1Password:**
   - Open 1Password app
   - Find the "Anthropic API Key", "Notion API Key", and "Notion Database ID" items
   - Replace the placeholder values with your actual keys

3. **Reload your shell:**
   ```bash
   source ~/.zshrc
   ```

4. **Test it works:**
   ```bash
   echo $ANTHROPIC_API_KEY
   ```

## How It Works

- 1Password CLI automatically resolves `op://vault/item/field` references
- Your actual keys are stored securely in 1Password
- Your dotfiles repository contains no sensitive information
- Works across all your machines with 1Password

## Add More Keys

To add additional API keys:

1. **Create a new item in 1Password** (Password category)
2. **Add the reference to .zshrc:**
   ```bash
   export YOUR_API_KEY="op://Personal/Your API Key/password"
   ```

## Security Benefits

✅ No hardcoded secrets in git  
✅ Encrypted storage in 1Password  
✅ Easy to rotate keys  
✅ Cross-device sync  
✅ Access control via 1Password  

That's it! Simple and secure.
