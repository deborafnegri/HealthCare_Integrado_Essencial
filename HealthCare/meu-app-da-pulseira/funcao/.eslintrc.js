module.exports = {
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
  ],
  rules: {
    "quotes": ["error", "double"],
    "max-len": ["error", {"code": 120}],
    "require-jsdoc": "off",
    "valid-jsdoc": "off",
    "no-unused-vars": "warn",
    "no-console": "off",
  },
  parserOptions: {
    ecmaVersion: 2020, // <-- Mude para 2020 ou 2021
  },
};