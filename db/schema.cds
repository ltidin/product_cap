namespace db;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {SapDefault} from './common';


entity Products : SapDefault, cuid, managed {
    prodId        : String(16);
    pgId          : ProductGroups : ID;
    prodGroup     : Association to one ProductGroups
                        on  prodGroup.ID    = pgId
                        and prodGroup.mandt = mandt;
    markets       : Association to many Markets
                        on markets.product = $self;
    phaseId       : Phases : ID;
    phase         : Association to one Phases
                        on  phase.ID    = phaseId
                        and phase.mandt = mandt;
    sizeUom       : UOM : msehi;
    uom           : Association to one UOM
                        on  uom.msehi = sizeUom
                        and uom.mandt = mandt;
    height        : Integer;
    depth         : Integer;
    width         : Integer;
    price         : Decimal;
    priceCurrency : Currency;
    taxrate       : Decimal;
}

entity ProductGroups : SapDefault {
    key ID       : String(3);
        name     : String(50);
        imageURL : String;
        products : Association to many Products
                       on products.prodGroup = $self;
}

entity Phases : SapDefault {
    key ID       : String(3);
        phase    : String(50);
        products : Association to many Products
                       on products.phase = $self;

}

entity UOM : SapDefault {
    key msehi    : String(3);
        dimid    : String(6);
        isocode  : String(3);
        products : Association to many Products
                       on products.uom = $self;
}

entity Markets : SapDefault, cuid, managed {
    prodUUID  : Products : ID;
    marketId  : Countries : ID;
    product   : Association to one Products
                    on  product.ID    = prodUUID
                    and product.mandt = mandt;
    country   : Association to one Countries
                    on  country.ID    = marketId
                    and country.mandt = mandt;
    status    : String(10);
    startDate : Date;
    endDate   : Date;
}

entity Countries : SapDefault {
    key ID      : String(3);
        country : String(50);
        markets : Association to many Markets
                      on markets.country = $self;
}
