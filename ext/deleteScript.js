const axios = require("axios");
const fs = require("fs");
const path = require("path");

// GitHub account info
const githubUsername = "username";
const githubToken = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXX";
const repositoryName = "repositoryName";
const folderToClean = "folder/path";

// Base URL for API GitHub
const baseUrl = `https://api.github.com/repos/${githubUsername}/${repositoryName}`;

// Auth header
const authHeader = {
  Authorization: `token ${githubToken}`,
};

// Function for getting folder info
async function getFolderInfo(folderPath) {
  try {
    const response = await axios.get(`${baseUrl}/contents/${folderPath}`, {
      headers: authHeader,
    });

    return response.data;
  } catch (error) {
    console.error("Can't get info about dir", error);
    return null;
  }
}

// Checking if a path is a file
function isFile(path) {
  return path.lastIndexOf(".") !== -1; // Checking for the presence of a file extension
}

// Function for deleting files in a folder
async function deleteFolderContents(folderPath) {
  const folderInfo = await getFolderInfo(folderPath);

  if (!folderInfo) {
    return;
  }

  for (const item of folderInfo) {
    const fullPath = path.join(folderPath, item.name);

    if (isFile(fullPath)) {
      await deleteFile(fullPath);
    } else {
      console.log(`Not sure it is file "${fullPath}" so skip`);
    }
  }
}

// Function for a file deleting
async function deleteFile(filePath) {
  try {
    const fileInfo = await getFolderInfo(filePath);

    if (!fileInfo) {
      return;
    }

    await axios.delete(`${baseUrl}/contents/${filePath}`, {
      headers: authHeader,
      data: {
        message: "Delete old version",
        sha: fileInfo.sha,
      },
    });

    console.log(`File "${filePath}" was deleted`);
  } catch (error) {
    console.error("File delete error", error);
  }
}

// Running the script
async function main() {
  try {
    await deleteFolderContents(folderToClean);
    console.log(`Directory "${folderToClean}" was successfully cleaned`);
  } catch (error) {
    console.error("Error while clearing folder contents", error);
  }
}

main();
