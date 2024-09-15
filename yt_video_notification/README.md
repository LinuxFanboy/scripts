# YouTube Video Notification

This project, `yt_video_notification`, is a Node.js script designed to send notifications when a new video is uploaded to a specified YouTube channel.

## Features

- Check for new videos on specific YouTube channels using the YouTube Data API.
- Send notifications via email or other platforms (configurable in future).
- Simple configuration and setup.

## Requirements

To use this project, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (version 14 or higher recommended)
- YouTube Data API key
- An email service or another notification service (optional)

## Installation

1. Clone this repository:

    ```bash
    git clone git@github.com:LinuxFanboy/scripts.git
    cd yt_video_notification
    ```

2. Install dependencies:

    ```bash
    npm install
    ```

3. Set up environment variables:

    Create a `.env` file in the root directory of the project and add the necessary configurations:

    ```bash
    YOUTUBE_API_KEY=your_youtube_api_key
    ```

   The `.env` file is used to store sensitive information, such as the YouTube API key and email credentials. Ensure you do not commit this file to version control.

## Usage

1. Run the script to start monitoring the YouTube channel:

    ```bash
    npm start
    ```

    OR

    ```bash
    node yt_channel_video_notification.js "@channel" 10
    ```

   The script will check the specified channel for new video uploads and send a notification if a new video is detected.

2. Customize the interval at which the script checks for new videos by modifying the appropriate setting in the code (for example, using `setInterval`).

## Configuration

### YouTube API Key

You will need a valid YouTube Data API v3 key to access video information. Follow these steps to obtain your API key:

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project (or use an existing one).
3. Enable the YouTube Data API v3.
4. Create an API key under the "Credentials" tab.
5. Add this key to your `.env` file as `YOUTUBE_API_KEY`.

### Email Notifications

This script is not configured to send notifications via email using SMTP yet, but go ahead and try to modify this script as you wish. You can use services like Gmail, SendGrid, or any other SMTP-compatible service. Update the SMTP configuration in the `.env` file as needed.

If you'd like to use another notification method (e.g., Slack, SMS), you can modify the notification logic in the script.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have any ideas for improvements or find any bugs.
