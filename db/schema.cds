namespace db;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {SapDefault} from './common';


entity Products : SapDefault, cuid, managed {
    prodId        : String(16);
    pgId          : ProductGroup : ID;
    prodGroup     : Association to one ProductGroup
                        on  prodGroup.ID    = pgId
                        and prodGroup.mandt = mandt;
    phaseId       : Phase : ID;
    phase         : Association to one Phase
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

entity ProductGroup : SapDefault {
    key ID       : String(3);
        name     : String(50);
        imageURL : String;
        products : Association to many Products
                       on products.prodGroup = $self;
}

entity Phase : SapDefault {
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
