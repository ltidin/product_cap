namespace db;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {SapStandartEntity} from './common';


entity Products : SapStandartEntity, cuid, managed {
    prod_id       : String(16);
    prodGroup     : Association to one ProductGroup;
    height        : Integer;
    depth         : Integer;
    width         : Integer;
    price         : Decimal;
    priceCurrency : Currency;
    taxrate       : Decimal;
}

entity ProductGroup : SapStandartEntity {
    key ID       : String(3);
        name     : String(50);
        imageURL : String;
        products: Association to many Products on products.prodGroup = $self;
}

