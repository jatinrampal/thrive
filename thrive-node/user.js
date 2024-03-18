class User {
    constructor(id, firstName, lastName, email, companyId, emailStatus, activeStatus, tokens) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.companyId = companyId;
        this.emailStatus = emailStatus;
        this.activeStatus = activeStatus;
        this.tokens = tokens;
    }
}

module.exports = { User };
