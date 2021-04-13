namespace db;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {SapDefault} from './common';


entity Products : SapDefault, cuid, managed {
    prod_id       : String(16);
    prodGroup     : Association to one ProductGroup;
    phase         : Association to one Phase;
    sizeuom       : Association to one UOM;
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
    key msehi   : String(3);
        dimid   : String(6);
        isocode : String(3);
}
