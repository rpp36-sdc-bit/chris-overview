// const { Sequelize } = require('sequelize');
// const sequelize = new Sequelize('postgres://chrisbaharians:password@db:5432/sdc_overview');
// const Pool = require('pg').Pool;
// const pool = new Pool ({
//   user: 'chrisbaharians',
//   host: 'localhost',
//   database: 'sdc_overview',
//   password: 'password',
//   port: 5432
// });

// const getProd = (request, response) => {
//   pool.query(`SELECT * FROM products
//     WHERE id = ${request.params.id}`, (error, results) => {
//     if (error) {
//       throw error
//     }
//     response.status(200).send(results.rows)
//   })
// }

// const getProds = (request, response) => {
//   pool.query(`SELECT * FROM products LIMIT 5`, (error, results) => {
//     if (error) {
//       throw error
//     }
//     response.status(200).send(results.rows)
//   })
// }

// module.exports = {
//   getProd,
//   getProds
// }
