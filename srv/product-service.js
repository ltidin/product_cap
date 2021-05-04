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
const ProdPhases = Object.freeze({
    open: 'P0001',
    inProcess: 'P0002',
    completed: 'P0003',
    rejected: 'P0004'
});
const OrderPhases = Object.freeze({
    new: 'O0001',
    inProcess: 'O0002',
    completed: 'O0003',
    rejected: 'O0004'
});
module.exports = cds.service.impl(async function () {
    const ProductService = await cds.connect.to('ProductService');
    function _parseQueryParams(params, query) {
        let parsedObj = {};
        for (const key in params) {
            if (params.hasOwnProperty(key)) {
                let element = params[key];
                let foundParamIndex = query.search(key);
                let keyParam = query.substr(foundParamIndex);
                let quoteCounter = 0;
                let iterationCounter = 0;
                while ((quoteCounter < 2) || (iterationCounter < keyParam.length)) {
                    if (keyParam[iterationCounter] === `'`) {
                        quoteCounter += 1;
                    } else {
                        if (quoteCounter === 1) {
                            element += keyParam[iterationCounter];
                        };

                    };
                    iterationCounter += 1;
                };
                parsedObj[key] = element;
            }
        }
        return parsedObj;
    }
    ProductService.before("addProductToOrder", async (req) => {
        console.log(req.query);
    });
    ProductService.on("addProductToOrder", async (req) => {
        const { prodID, quantity } = req.data;
        console.log(req.target);
        const db = this.transaction(req);
    });
    ProductService.on("addProdToOrder", async (req) => {
        const { prodId, quantity } = req.data;
        const db = this.transaction(req);
        let { Products, Ord2Prod, Orders } = this.entities;
        const srcQuery = req.query._target.name;

        let orderParams = _parseQueryParams({ mandt: "", ID: "" }, srcQuery);
        //Check if 
        let orderDetails = await db.read(Orders, { mandt: orderParams.mandt, ID: orderParams.ID });
        if (orderDetails !== undefined && orderDetails.hasOwnProperty("phaseID")) {
            if (orderDetails.phaseID !== OrderPhases.new) {
                return req.error({ code: "420", message: "Unable to add product to this order" });
            } else {
                //Check if product exists in db
                let productsToAdd = await db.read(Products, ["mandt", "ID as prodGUID"]).where({ mandt: orderParams.mandt, prodID: prodId });
                if (productsToAdd.length !== 0) {
                    //Add products to the order
                    let prodToOrders = {
                        mandt: orderParams.mandt,
                        orderID: orderParams.ID,
                        productID: productsToAdd[0].prodGUID,
                        quantity: quantity,
                        phaseID: ProdPhases.open
                    };
                    let orderUpdated = await db.insert(prodToOrders).into(Ord2Prod);
                    return orderUpdated;
                } else {
                    return req.error({ code: "410", message: "No product found" })
                };
            }
        } else return req.error({ code: "430", message: "Unable to fetch order" });
    });
})
