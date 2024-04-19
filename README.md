<div style="text-align:center;">
    <img src="./docs/social-preview.png" alt="Waker social preview">
</div>

![macOS Version](https://img.shields.io/badge/macOS_Version-13.0%2B-green?logo=macOS)
![App Category](https://img.shields.io/badge/App_Category-Utilities-blue?logo=apple)
![Swift Version](https://img.shields.io/badge/Swift_Version-5-blue?logo=swift)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/ChenglongMa/waker-mac?include_prereleases)](https://github.com/ChenglongMa/waker-mac/releases/latest)
[![GitHub License](https://img.shields.io/github/license/ChenglongMa/waker-mac)](https://github.com/ChenglongMa/waker-mac/blob/main/LICENSE)

> "_You deserve a cup of coffee!_" - Waker <img src="./docs/icon.svg" alt="Waker icon" width="50px">

Waker is a straightforward macOS menu bar app designed to keep your Mac awake and prevent "_You know what_" apps from
becoming inactive.

# Appearance

## Menu Bar Status

![Waker Menu Bar Active](./docs/appearance/menu-bar-status.svg)

## Menu Body Appearance

![Waker Menu Body Appearance](./docs/appearance/menu-body-appearance.png)

# Features

- **Keep Mac Awake**: Prevent your Mac and related apps from becoming inactive.
- **Set Wake Up Interval**: Define the interval to wake up your Mac.
- **Schedule Running Time**: Set specific times for Waker to run.
- **Auto-Start**: Configure Waker to start automatically upon login.
- **Dark Mode Support**: Seamlessly switch between light and dark modes.
- **Auto-Update**: Automatically check for updates and notify you of new versions.

# Installation

> [!WARNING]
> 1. As I don't have a paid Apple Developer account, this app is signed with a **development** certificate and not **notarized** by Apple, see more at [Safely open apps on your Mac](https://support.apple.com/en-us/102445).
> 2. You may encounter additional installation steps due to macOS security policies.
> 3. Once installed, you can update the app automatically without encountering this warning again, unless you reinstall it.
> 4. If you have any concerns about the security of this app, you can:
>    - Check the source code and build the app by yourself.
>    - Use the Python version I developed: [Waker](https://github.com/ChenglongMa/waker). Their core functionality is
       the same, just the user interface is slightly different.

<details markdown="1">
  <summary><i>If you want to continue, click here...</i></summary>

## Download

Download the latest version of Waker's `.dmg` installer from
the [release page](https://github.com/ChenglongMa/waker-mac/releases/latest).

## Installation Steps

1. **Right-click** the `.dmg` file and select `Open` to begin the installation process.
    - 🟢 When right-clicking the `.dmg` file, you will see the following warning, **please click `Open`**.
      ![right click dmg](./docs/installation/right-click-dmg.png)
    - 🔴 If you **double-click** the `.dmg` file, you may encounter the following warning:
      ![double click warning](./docs/installation/double-click-dmg.png)
2. Drag the `Waker.app` to your `Applications` folder.
   ![Drag to Applications](./docs/installation/dmg-installer.png)
3. Locate `Waker.app` in your `Launchpad` or `Applications` folder. If you encounter a warning when opening the app
   from `Launchpad`, click `Show in Finder` and proceed.
    - 🟢 Please **right-click** the app from the `Applications` folder and select `Open`, you will see the following
      warning, **Please click `Open`**.
      ![warning in finder](./docs/installation/right-click-in-finder.png)
    - 🔴 If you open the app
      from `Launchpad` <img src="./docs/assets/launchpad.jpg.webp" alt="launchpad icon" width="20px">, you will see the
      following warning, **please click `Show in Finder`**.
      ![warning in launchpad](./docs/installation/open-in-application.png)
4. You can now find the app in the menu bar, as depicted in the [Appearance Section](#appearance).
5. From now on, you can open the app
   from `Launchpad` <img src="./docs/assets/launchpad.jpg.webp" alt="launchpad icon" width="20px"> as usual.

</details>

# Usage

Using Waker is intuitive, with its functionality directly accessible from its interface.

## Permissions

Upon initial launch, you may need to grant certain permissions to Waker:

1. **Accessibility Permission**: Grant the app this permission to enable its full functionality.
    - You can follow the prompt when you first launch the app.
    - Or, you can do this manually through System Settings > Privacy & Security > Accessibility. Refer
      to [this instruction](https://support.apple.com/en-au/guide/mac-help/mh43185/mac#:~:text=To%20review%20app%20permissions%20—%20for,any%20app%20in%20the%20list.).
      ![Accessibility Permission](./docs/usage/accessibility-permission.png)

2. **Launch at Login**: Enable this feature to have Waker start automatically upon login.

    - You can toggle this setting in the app's menu bar settings
    - Or manually through System Settings > Users & Groups > Login Items.
      ![Launch at Login](./docs/usage/launch-at-login-settings.png)

3. **Auto-Update**: Grant the app **notification** permissions to receive automatic update notifications.

## Functionality

### Manual Running

Toggle the `Main Switch` in the app's menu bar to manually run or stop Waker.

### Set Wake Up Interval

Define the wake-up interval in the app's menu bar settings to prevent certain apps from becoming inactive.

### Schedule Running Time

Set specific times for Waker to run, allowing for customized usage based on your preferences and workflow.

For example, you can set the app to run at **9:00 AM** and close at **5:00 PM** from **Monday** to **Friday**.

### Auto-Update

Enable automatic update checks to stay informed about the latest versions of Waker.

You can also check for updates manually in the app menu bar settings.

# Contributing

👋 Welcome to **Waker**! We're excited to have your contributions. Here's how you can get involved:

1. 💡 **Discuss New Ideas**: Have a creative idea or suggestion? Start a discussion in
   the [Discussions](https://github.com/ChenglongMa/waker-mac/discussions) tab to share your thoughts and
   gather feedback from the community.

2. ❓ **Ask Questions**: Got questions or need clarification on something in the repository? Feel free to open
   an [Issue](https://github.com/ChenglongMa/waker-mac/issues) labeled as a "question" or participate
   in [Discussions](https://github.com/ChenglongMa/waker-mac/discussions).

3. 🐛 **Issue a Bug**: If you've identified a bug or an issue with the code, please open a
   new [Issue](https://github.com/ChenglongMa/waker-mac/issues) with a clear description of the problem, steps
   to reproduce it, and your environment details.

4. ✨ **Introduce New Features**: Want to add a new feature or enhancement to the project? Fork the repository, create a
   new branch, and submit a [Pull Request](https://github.com/ChenglongMa/waker-mac/pulls) with your changes.
   Make sure to follow our contribution guidelines.

5. 💖 **Funding**: If you'd like to financially support the project, you can do so
   by [sponsoring the repository on GitHub](https://github.com/sponsors/ChenglongMa). Your contributions help us
   maintain and improve the project.

Thank you for considering contributing to **Waker**.
We value your input and look forward to collaborating with you!
