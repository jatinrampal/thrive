const { processEmails } = require('./dataProcessing');

const usersFile = 'challenge-docs/users.json';
const companiesFile = 'challenge-docs/companies.json';
const outputFile = 'output.txt';

try {
    processEmails(usersFile, companiesFile, outputFile);
} catch (error) {
    console.error('Error processing data:', error.message);
}
