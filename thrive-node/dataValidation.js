const Joi = require('joi');

const userSchema = Joi.object({
    id: Joi.number().required(),
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    email: Joi.string().email().required(),
    companyId: Joi.number().required(),
    emailStatus: Joi.boolean().required(),
    activeStatus: Joi.boolean().required(),
    tokens: Joi.number().required()
});

const companySchema = Joi.object({
    id: Joi.number().required(),
    name: Joi.string().required(),
    topUp: Joi.number().required(),
    emailStatus: Joi.boolean().required()
});

function validateUser(user) {
    return userSchema.validate(user).error === undefined;
}

function validateCompany(company) {
    return companySchema.validate(company).error === undefined;
}

module.exports = { validateUser, validateCompany };
