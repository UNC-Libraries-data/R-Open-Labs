# Getting R Open Labs Materials via GitHub

At any time, you can download all materials and data for this semester's run of R Open Labs here:

[https://github.com/UNC-Libraries-data/R-Open-Labs/archive/master.zip](https://github.com/UNC-Libraries-data/R-Open-Labs/archive/master.zip)

However, you can also keep up to date using Git.

### Note: Do I already have Git?

You might already have Git installed as part of another piece of software.  To test this, open a Terminal (Mac) or Command Line (PC) and type:

`git --version`

If you have Git installed, you'll see your version, if not you'll see an error message like:

`'git' is not recognized as an internal or external command,
operable program or batch file.` (PC)

`bash: git: command not found` (Mac)

If you see one of these errors, you'll need to install Git:

## [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Windows Suggested Settings

* Visit [https://git-scm.com/](https://git-scm.com/) and download the latest version of Git for your OS.

* Choose a text editor.  If you're not sure what you want to use, pick the **Nano editor**

* Under Adjusting your PATH environment, choose **Use Git from Git Bash only** if you're not sure what to use.

* When in doubt, stick to the defaults.

## Cloning - Initial Download 

Open a console with git enabled.  This could be your terminal / command prompt or Git Bash, depending on your installation choices.  

Type:

`git`

to ensure that the command is properly installed and available in your chosen interface.
Navigate to the folder you want to store your repository in. For example:

`cd C:/ropenlabs` (PC - Git Bash)

`cd ~/Users/Desktop` (Mac)

`cd C:\ropenlabs` (PC - Command Line)

* Note: PC Command Line paths require the **backslash ( \\ )** whereas Mac and Bash use the **forward slash ( / )**.

Clone the repository with:

`git clone https://github.com/UNC-Libraries-data/R-Open-Labs.git`

Now you should have a new folder called "R-Open-Labs", in the location you've specified with your `cd` command, with the most up to date materials.

## Pulling - Getting Updates

You can clone the entire folder anytime to get the latest files.  However, it's more efficient to just update and add files as needed with the `pull` command.

First, navigate to the folder your repository is cloned into.  You need to set the terminal inside the "R-Open-Labs" folder.  Following the examples above:

`cd C:/ropenlabs/R-Open-Labs` (PC - Git Bash)

`cd ~/Users/Desktop/R-Open-Labs` (Mac)

`cd C:\ropenlabs\R-Open-Labs (PC)` (PC - Command Line)

To check that you're in the correct folder, you can type:

`git status`
 
If you're in the correct folder you'll see 

`On branch master`...

If not you'll see 

`fatal: not a git repository`

Once you're in the correct folder, simply type:

`git pull`

The latest updates, if there are any, will be downloaded into your repository.

