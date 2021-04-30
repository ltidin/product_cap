/*module.exports = (srv) => {
    srv.on("addProductToOrder", async (req) => {
        const { prodID, quantity } = req.data;
        const db = srv.transaction(req);

        let { Products } = srv.entities;

        let prodGUID = await db.read(Products, ["ID"]).where({ prodId: prodID });
        console.log(prodGUID);
    })
}*/

const cds = require('@sap/cds');
module.exports = cds.service.impl(async function () {
    const ProductService = await cds.connect.to('ProductService');
    ProductService.before("addProductToOrder", async (req) => {
        console.log(req.query);
    });
    ProductService.on("addProductToOrder", async (req) => {
        const { prodID, quantity } = req.data;
        console.log(req.target);
        const db = this.transaction(req);
    })
})
