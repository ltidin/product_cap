namespace db;

using {
    cuid,
    managed,
    Currency,
    Country
} from '@sap/cds/common';

using {SapDefault} from './lib/common';

annotate cuid with {
    ID @odata.Type : 'Edm.String';
};


entity Products : SapDefault, cuid, managed {
    prodId          : String(16);
    description     : localized String;
    pgId            : ProductGroups : ID;
    toProdGroup     : Association to one ProductGroups
                          on  toProdGroup.ID    = pgId
                          and toProdGroup.mandt = mandt;
    toMarkets       : Association to many Markets
                          on toMarkets.toProduct = $self;
    toOrders        : Association to many Ord2Prod
                          on  toOrders.productID = ID
                          and toOrders.mandt     = mandt;
    sizeUom         : UOM : msehi;
    toUom           : Association to one UOM
                          on  toUom.msehi = sizeUom
                          and toUom.mandt = mandt;
    height          : Integer;
    depth           : Integer;
    width           : Integer;
    price           : Decimal;
    toPriceCurrency : Currency;
    taxrate         : Decimal;
}

entity ProductGroups : SapDefault {
    key ID         : Integer;
        name       : localized String(50);
        imageURL   : String;
        toProducts : Association to many Products
                         on toProducts.toProdGroup = $self;
}

entity Phases : SapDefault {
    key ID          : String(5);
        name        : localized String(50);
        description : localized String;
        toOrders    : Association to many Orders
                          on toOrders.toPhase = $self;
}


entity UOM : SapDefault {
    key msehi      : String(3);
        dimid      : String(6);
        isocode    : String(3);
        toProducts : Association to many Products
                         on toProducts.toUom = $self;
}

entity Markets : SapDefault, cuid, managed {
    prodUUID    : Products : ID;
    name        : localized String;
    description : localized String;
    toProduct   : Association to one Products
                      on  toProduct.ID    = prodUUID
                      and toProduct.mandt = mandt;
    toCountry   : Country;
    status      : String(10);
    startDate   : Date;
    endDate     : Date;
}

entity Orders : SapDefault, cuid, managed {
    toProducts   : Composition of many Ord2Prod
                       on  toProducts.orderID = ID
                       and toProducts.mandt   = mandt;
    mrktUUID     : Markets : ID;
    toMarket     : Association to one Markets
                       on  toMarket.ID    = mrktUUID
                       and toMarket.mandt = mandt;
    phaseID      : Phases : ID;
    toPhase      : Association to one Phases
                       on  toPhase.ID    = phaseID
                       and toPhase.mandt = mandt;
    orderID      : String(10);
    description  : String;
    deliveryDate : Date;
    year         : String(4);
    netAmount    : Decimal;
    grossAmount  : Decimal;
    currency     : Currency;
}

entity Ord2Prod : SapDefault {
    key orderID   : cuid : ID;
    key productID : cuid : ID;
        quantity  : Integer;
        phaseID   : Phases : ID;
        toProduct : Association to Products
                        on  toProduct.ID    = productID
                        and toProduct.mandt = mandt;
        toOrder   : Association to Orders
                        on  toOrder.ID    = orderID
                        and toOrder.mandt = mandt;
}
