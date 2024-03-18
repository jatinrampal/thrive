const fs = require('fs');
const { User } = require('./user');
const { Company } = require('./company');
const { validateUser, validateCompany } = require('./dataValidation');

function readJson(file) {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeIndented(stream, line, level = 0) {
    stream.write('\t'.repeat(level) + line + '\n');
}

function writeUsers(stream, users, level) {
    users
        .sort((a, b) => a.lastName.localeCompare(b.lastName))
        .forEach(user => {
            writeIndented(stream, `${user.lastName}, ${user.firstName}, ${user.email}`, level);
            writeIndented(stream, `  Previous Token Balance: ${user.previousTokens}`, level);
            writeIndented(stream, `  New Token Balance: ${user.tokens}`, level);
        });
}

function writeOutput(stream, companies) {
    companies.forEach(({ company, usersEmailed, usersNotEmailed, totalTopUps }) => {
        writeIndented(stream, `Company Id: ${company.id}`, 1);
        writeIndented(stream, `Company Name: ${company.name}`, 1);
        writeIndented(stream, 'Users Emailed:', 1);
        writeUsers(stream, usersEmailed, 2);
        writeIndented(stream, 'Users Not Emailed:', 1);
        writeUsers(stream, usersNotEmailed, 2);
        writeIndented(stream, `Total amount of top-ups for ${company.name}: ${totalTopUps}\n`, 2);
    });
    stream.end();
}

function processEmails(usersFile, companiesFile, outputFile) {
    const usersData = readJson(usersFile);
    const companiesData = readJson(companiesFile);

    const users = usersData.map(user =>
        new User(user.id, user.first_name, user.last_name, user.email, user.company_id, user.email_status, user.active_status, user.tokens)
    );

    const companies = companiesData.map(company =>
        new Company(company.id, company.name, company.top_up, company.email_status)
    );

    const invalidUsers = users.filter(user => !validateUser(user));
    const invalidCompanies = companies.filter(company => !validateCompany(company));

    if (invalidUsers.length > 0 || invalidCompanies.length > 0) {
        console.error('Invalid data detected:');
        invalidUsers.forEach(user => console.error(`Invalid user data: ${JSON.stringify(user)}`));
        invalidCompanies.forEach(company => console.error(`Invalid company data: ${JSON.stringify(company)}`));
    }

    const companyMap = new Map();
    users.forEach(user => {
        if (user.activeStatus) {
            const company = companies.find(c => c.id === user.companyId);
            if (company) {
                const companyInfo = companyMap.get(company.id) || {
                    company,
                    usersEmailed: [],
                    usersNotEmailed: [],
                    totalTopUps: 0
                };
                const previousTokens = user.tokens;
                user.tokens += company.topUp;
                if (company.emailStatus && user.emailStatus) {
                    companyInfo.usersEmailed.push({ ...user, previousTokens });
                } else {
                    companyInfo.usersNotEmailed.push({ ...user, previousTokens });
                }
                companyInfo.totalTopUps += company.topUp;
                companyMap.set(company.id, companyInfo);
            }
        }
    });

    const companiesResult = Array.from(companyMap.values()).sort((a, b) => a.company.id - b.company.id);

    const stream = fs.createWriteStream(outputFile);
    writeOutput(stream, companiesResult);
}

module.exports = { processEmails };
