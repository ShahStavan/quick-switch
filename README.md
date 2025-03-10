# Quick Switch through your project directories

This script allows you to easily open Command Prompt sessions in specified directories (e.g., `D:\Projects` and `D:\Practice`) using an interactive selection tool called `fzf`. It's designed for Windows and helps streamline your workflow by managing multiple project directories.

![](https://github.com/Dev-Mehta/quick-switch/blob/master/screenshots/fuzzy-find-dirs.png)

## Inspiration

This script is inspired by [tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer) from ThePrimeagen's dotfiles repository. While it originally utilized `tmux`, this version focuses on leveraging Windows' built-in features.

## Features

- **Directory Selection:** Quickly select from top-level directories in specified paths using `fzf`.
- **Session Management:** Open a new Command Prompt window for a selected directory or reuse an existing one.
- **Easy Installation:** Includes an installation script to set up the environment easily.

## Installation

To install the script, follow these steps:

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/Dev-Mehta/quick-switch.git
    ```

2. Navigate to the cloned directory:

```bash
cd quick-switch
```

3. After you have cloned the repo, open text editor of your choice and put your work directories in `quick-switch.bat`.
```
for /f "delims=" %%i in ('dir /b /ad "D:\Projects" "D:\Practice" ^| fzf') do (
     set "selected=D:\Projects\%%i"
     if not exist "!selected!" set "selected=D:\Practice\%%i"
 )
```

4. Run the installation script:

```bash
install.bat
```


This will copy the quick-switch.bat script to a directory in your Path, check for and install fzf, and add necessary paths if needed.

## Usage

After installation, you can use the script from any Command Prompt window:

```bash
quick-switch
```

If no arguments are provided, the script will prompt you to select a directory. You can also provide a specific directory as an argument.

## Faster...

Okay this is nice, we have fuzzy finding through directories for windows, but I don't want to type `quick-switch` everytime I want to change to a directory. I got you.

Do this. Open up a command prompt. 
```bash
cd %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\
mkdir _hotkeys
cd _hotkeys
explorer .
```

What we have just done is we have created a `_hotkeys` directory in the `Start Menu`. This way you can create a shortcut here that links to quick-switch. When you open the file explorer in the `_hotkeys` directory to the following steps to create a shortcut.

**Right click anywhere on the empty space > New > Shortcut**, when it prompts you for a location enter `%USERPROFILE%\bin\quick-switch.bat`. Create the shortcut. Right click on the shortcut, go to properties and set your desired hotkey in `Shortcut key` field. I have set it to `Ctrl + Shift + M`. Now I can press `Ctrl + Shift + M` from anywhere and quick-switch will open up. 

![image](https://github.com/user-attachments/assets/379e649e-92f9-4bf7-840d-f43693c460fd)

## Dependencies

[fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder. The installation script will download and install fzf automatically.
