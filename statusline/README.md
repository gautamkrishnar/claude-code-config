# Claude Code Statusline

![Preview](https://github.com/user-attachments/assets/b101f7d5-be42-4649-a57d-455c9b5c0cb5)

A customizable statusline script for Claude Code that displays useful context information including your current directory, git status, Python environment, AWS profile, model information, context window usage, and session cost.

## Features

- **Directory:** Current working directory (basename)
- **Git Integration:** Branch name and dirty/clean status indicators
- **Python Environment:** Virtual environment or Conda environment detection
- **AWS Profile:** Current AWS profile if set
- **Model Info:** Currently active Claude model
- **Context Usage:** Percentage of context window used (color-coded by usage level)
- **Cost Tracking:** Total session cost in USD
- **Color-coded Output:** Visual indicators for different states

## Prerequisites

This script requires the following dependencies:

- **zsh** - The script is written for zsh shell
- **jq** - JSON processor for parsing Claude Code's JSON input
- **git** - For git repository information (optional, but recommended)

### Installing Dependencies

#### macOS (using Homebrew)
```bash
brew install jq
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install jq
```

#### Fedora/RHEL
```bash
sudo dnf install jq
```

## Setup Instructions

### 1. Copy the Script

Copy `statusline.sh` to your Claude configuration directory:

```bash
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

### 2. Configure Claude Code

Add the following to your Claude Code settings file (typically `~/.claude/settings.json`):

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

Alternatively, you can set it via the CLI:

```bash
claude config set statusline ~/.claude/statusline.sh
```

### 3. Restart Claude Code

Restart your Claude Code session to see the new statusline in action.

## Example Output

After setup, your statusline will look something like this:

```
my-project 🐍conda-env ☁️ AWS:production main ✓ 🤖 Sonnet 4.5 📊 15% 💰 $0.42
```

### Color-Coded Elements

- **my-project** - Current directory (bold yellow)
- **🐍conda-env** - Python environment (green)
- **☁️ AWS:production** - AWS profile (yellow)
- **main** - Git branch (magenta)
- **✓** - Clean repository (magenta) / **±** - Dirty repository (bold red)
- **🤖 Sonnet 4.5** - Model name (bold blue)
- **📊 15%** - Context usage (cyan < 60%, yellow 60-79%, bold red ≥ 80%)
- **💰 $0.42** - Total cost (bold green)

### Real-World Examples

**Clean repository, low context usage:**
```
backend 🐍myenv main ✓ 🤖 Sonnet 4.5 📊 23% 💰 $0.15
```

**Dirty repository, high context usage, AWS profile:**
```
api-service ☁️ AWS:staging develop ± 🤖 Sonnet 4.5 📊 87% 💰 $1.24
```

**Simple project, no environment:**
```
website main ✓ 🤖 Haiku 3.5 📊 8% 💰 $0.03
```

## Customization

You can customize the script by editing `~/.claude/statusline.sh`:

- **Colors:** Modify the color palette variables (lines 10-18)
- **Format:** Change the output format in the printf statement (line 83)
- **Information:** Add or remove elements by modifying helper function calls
- **Icons:** Replace emojis with your preferred indicators

### Available Helper Functions

The script provides several helper functions to extract data from Claude Code's JSON input:

- `get_model_name()` - Model display name
- `get_current_dir()` - Current working directory
- `get_project_dir()` - Project root directory
- `get_cost()` - Total session cost in USD
- `get_duration()` - Total session duration in milliseconds
- `get_lines_added()` - Total lines added in session
- `get_lines_removed()` - Total lines removed in session
- `get_input_tokens()` - Total input tokens used
- `get_output_tokens()` - Total output tokens used
- `get_context_window_size()` - Context window size
- `get_used_percentage()` - Percentage of context window used

## Troubleshooting

### Statusline not appearing
- Verify the script is executable: `chmod +x ~/.claude/statusline.sh`
- Check the settings are correct: `claude config get statusline`
- Ensure jq is installed: `which jq`

### Colors not displaying correctly
- Make sure your terminal supports ANSI color codes
- Try a different terminal emulator (iTerm2, Alacritty, etc.)

### Git information not showing
- Ensure you're in a git repository
- Check that git is installed: `which git`

## License

This script is provided as-is for use with Claude Code.
