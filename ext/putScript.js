const axios = require('axios');
const { Base64 } = require('js-base64');
const fs = require('fs');

// GitHub account info
const githubUsername = "username";
const githubToken = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXX";
const repositoryName = "repositoryName";
const folderPath = "folder";

// Base URL for API GitHub
const baseUrl = `https://api.github.com/repos/${githubUsername}/${repositoryName}/contents/${folderPath}`;

// Auth header
const authHeader = {
  Authorization: `token ${githubToken}`,
};

// Getting a list of files in the /files directory
async function getFiles() {
  const files = await fs.promises.readdir('/root/github_update/files/');
  return files;
}

// Select a random file from the list
async function getRandomFile(files) {
  const randomIndex = Math.floor(Math.random() * files.length);
  return files[randomIndex];
}

// Checking whether the file selected from the list already exists in the repository directory
async function checkFileExists(fileName) {
 
  try {
    const response = await axios.get(`${baseUrl}/${fileName}`);
    const fileExists = response.status === 200;

    console.log(`File "${fileName}":`);
    if (fileExists) {
      console.log(`  already exist`);
    } else {
      console.log(`  does not exist`);
    }

    return fileExists;
  } catch (error) {
    if (error.response.status === 404) {
      return false;
    }
    throw error;
  }
}


// Function for uploading a file to the repository
async function pushFile(fileName) {
  const content = await fs.promises.readFile(`/root/github_update/files/${fileName}`, 'utf8');
  const contentEncoded = Base64.encode(content);
  const data = {
    message: `Contribution ${fileName}`,
    content: contentEncoded, };
  const response = await axios.put(`${baseUrl}/${fileName}`, data, { headers: authHeader });
  
  if (response.status === 201) {
    console.log(`File "${fileName}" successfully uploaded`);
  } else {
    console.log(`Code: ${response.status}`);
  }
}

// Running the script
async function main() {
  let fileName;
  let fileExists;

  do {
    const files = await getFiles();
    fileName = await getRandomFile(files);
    fileExists = await checkFileExists(fileName);
  } while (fileExists); // Repeating until we find a file that is not in the repository

  await pushFile(fileName);
 
}

main();
