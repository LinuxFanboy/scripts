const { google } = require('googleapis');
const dotenv = require('dotenv');
const readline = require('readline');

dotenv.config();

// API Key from the .env file
const API_KEY = process.env.YOUTUBE_API_KEY;

if (!API_KEY) {
  console.error('Error: Missing YOUTUBE_API_KEY in .env file');
  process.exit(1);
}

// Getting the YouTube handle and interval from command line arguments
const handle = process.argv[2];
const intervalInSeconds = parseInt(process.argv[3]);

if (!handle) {
  console.error('Error: Missing YouTube handle argument (e.g., node yt_channel_video_notification.js "@channel")');
  process.exit(1);
}

if (isNaN(intervalInSeconds)) {
  console.error('Error: Missing or invalid interval argument (e.g., node yt_channel_video_notification.js "@channel" 10)');
  process.exit(1);
}

const youtube = google.youtube('v3');

// Convert interval from seconds to milliseconds
const CHECK_INTERVAL = intervalInSeconds * 1000;

let lastVideoId = null;

// Create an interface for user input to ask whether to continue
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Function to get the Channel ID based on the handle
async function getChannelIdByHandle(handle) {
  try {
    const response = await youtube.search.list({
      key: API_KEY,
      q: handle,
      type: 'channel',
      part: 'snippet',
      maxResults: 1,
    });

    if (response.data.items.length === 0) {
      console.log('Channel not found');
      return null;
    }

    const channel = response.data.items[0];
    const channelId = channel.snippet.channelId;
    const channelTitle = channel.snippet.channelTitle;

    console.log(`Monitoring channel: ${channelTitle} (ID: ${channelId})`);
    console.log(`Selected interval: ${intervalInSeconds} seconds`);

    return channelId;
  } catch (error) {
    console.error('Error fetching channel ID:', error);
    return null;
  }
}

// Function to get the latest video from a channel
async function getLatestVideo(channelId) {
  try {
    const response = await youtube.search.list({
      key: API_KEY,
      channelId: channelId,
      part: 'snippet',
      order: 'date',
      maxResults: 1,
    });

    const video = response.data.items[0];
    const videoId = video.id.videoId;
    const videoTitle = video.snippet.title;
    const videoPublishedAt = video.snippet.publishedAt; // Get the publish date
    const videoUrl = `https://www.youtube.com/watch?v=${videoId}`;

    return { videoId, videoTitle, videoPublishedAt, videoUrl };
  } catch (error) {
    console.error('Error fetching latest video:', error);
    return null;
  }
}

// Function to check for new videos on the channel
async function checkForNewVideos(channelId) {
  const latestVideo = await getLatestVideo(channelId);

  if (latestVideo && latestVideo.videoId !== lastVideoId) {
    console.log(`\nNew video uploaded: ${latestVideo.videoTitle}`);
    console.log(`Published on: ${new Date(latestVideo.videoPublishedAt).toLocaleString()}`);
    console.log(`Watch here: ${latestVideo.videoUrl}`);
    lastVideoId = latestVideo.videoId;

    // Ask the user if they want to continue monitoring
    rl.question('Do you want to keep monitoring? (yes/no): ', (answer) => {
      if (answer.toLowerCase() === 'no') {
        console.log('Stopping the script...');
        rl.close();
        process.exit(0); // Exit the process if the user does not want to continue
      }
    });
  } else {
    console.log('No new videos yet');
  }
}

// Main function that ties everything together
async function main() {
  const channelId = await getChannelIdByHandle(handle);
  if (!channelId) {
    console.error('Error: Unable to find channel with provided handle');
    return;
  }

  // First check for new videos
  await checkForNewVideos(channelId);

  // Set interval to check for new videos
  setInterval(() => checkForNewVideos(channelId), CHECK_INTERVAL);
}

// Start the program
main();
